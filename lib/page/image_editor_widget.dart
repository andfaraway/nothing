import 'dart:io' as io;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/utils/web_import.dart';

class SimpleImageEditor extends StatefulWidget {
  final File image;

  const SimpleImageEditor(this.image, {super.key});

  @override
  State<SimpleImageEditor> createState() => _SimpleImageEditorState();
}

class _SimpleImageEditorState extends State<SimpleImageEditor> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();

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
              cropRectPadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: kBottomNavigationBarHeight),
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
    final Uint8List? fileData = editorKey.currentState?.rawImageData;
    if (fileData == null) {
      showToast('crop error');
    }
    File imageFile = await saveImageToTemp(fileData!);
    if (mounted) {
      Navigator.of(context).pop(imageFile);
    }
  }

  Future<dynamic> saveImageToTemp(Uint8List imageByte) async {
    String path = '${PathUtils.tempPath}/${widget.image.path.split('/').last}';
    io.File file = io.File(path);
    if (await file.exists()) {
      file.delete();
    }

    file = await io.File(path).create();

    file.writeAsBytesSync(imageByte);
    return file;
  }
}
