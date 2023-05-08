import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:nothing/common/prefix_header.dart';

import '../utils/crop_editor_helper.dart';

class SimpleImageEditor extends StatefulWidget {
  final File image;

  const SimpleImageEditor(this.image, {Key? key}) : super(key: key);

  @override
  _SimpleImageEditorState createState() => _SimpleImageEditorState();
}

class _SimpleImageEditorState extends State<SimpleImageEditor> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Crop'),
        actions: [
          IconButton(
              onPressed: () {
                cropImage();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: ExtendedImage.file(
        widget.image,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        enableLoadState: true,
        extendedImageEditorKey: editorKey,
        cacheRawData: true,
        initEditorConfigHandler: (ExtendedImageState? state) {
          return EditorConfig(
              maxScale: 5.0,
              cropRectPadding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: kBottomNavigationBarHeight),
              hitTestSize: 20.0,
              initCropRectType: InitCropRectType.layoutRect,
              cropAspectRatio: Screens.width / Screens.height,
              editActionDetailsIsChanged: (EditActionDetails? details) {
                //print(details?.totalScale);
              });
        },
      ),
    );
  }

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }
    _cropping = true;
    try {
      final Uint8List fileData = Uint8List.fromList(kIsWeb
          ? (await cropImageDataWithDartLibrary(
              state: editorKey.currentState!))!
          : (await cropImageDataWithNativeLibrary(
              state: editorKey.currentState!))!);

      File imageFile = await saveImageToTemp(fileData);
      if (mounted) {
        Navigator.of(context).pop(imageFile);
      }
    } finally {
      _cropping = false;
    }
  }

  Future<File> saveImageToTemp(Uint8List imageByte) async {
    String path = '${PathUtils.tempPath}/${widget.image.path.split('/').last}';
    File file = File(path);
    if (await file.exists()) {
      file.delete();
    }
    //生成file文件格式
    file = await File(path).create();
    //转成file文件
    file.writeAsBytesSync(imageByte);
    return file;
  }
}
