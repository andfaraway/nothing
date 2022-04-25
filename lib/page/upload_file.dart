//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-06 15:53:41
//
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nothing/constants/constants.dart';
import 'package:nothing/public.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({Key? key}) : super(key: key);

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  PickedFile? file;
  String? fileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final DateTime now = DateTime.now();
    fileName =
        '${now.year.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.upload_file),
        actions: file == null
            ? null
            : [
                TextButton(
                    onPressed: () {
                      upload();
                    },
                    child: Text(
                      S.current.upload,
                      style: const TextStyle(color: Colors.white),
                    ))
              ],
      ),
      body: Column(
        children: [
          if (file != null) Column(
            children: [
              TextField(
                controller: TextEditingController(text: fileName),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  fileName = value;
                },
              ),
              Image.asset(file!.path),
            ],
          ),
          Expanded(
            child: Center(
              child: MaterialButton(
                  color: Colors.blue,
                  child: const Text('select file'),
                  onPressed: () {
                    selectFile();
                  }),
            ),
          )
        ],
      ),
    );
  }

  // 上传文件
  Future<void> upload() async {
    EasyLoading.show();
    // 上传文件
    await UserAPI.uploadFile(file?.path ?? '', fileName ?? '');
    EasyLoading.dismiss();
    showToast(S.current.success);
    setState(() {
      file = null;
    });
  }

  // 选择文件
  Future<void> selectFile() async {
    SheetButtonModel model1 = SheetButtonModel(
        icon: const Icon(Icons.camera_alt),
        title: S.current.camera,
        onTap: () async {
          _cropImage(0);
        });
    SheetButtonModel model2 = SheetButtonModel(
        icon: const Icon(Icons.photo_album),
        title: S.current.photo_album,
        onTap: () async {
          _cropImage(1);
        });
    showSheet(context, [model1, model2]);
  }

  Future<void> _cropImage(int type) async {
    ImageSource source = ImageSource.camera;
    if (type == 1) {
      source = ImageSource.gallery;
    }
    ImagePicker picker = ImagePicker();
    file = await picker.getImage(source: source).catchError((error) {
      print('picker error : ' + error.toString());
      openAppSettings();
    });

    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: file?.path ?? '',
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Clip',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Clip',
        ));
    if (croppedFile != null) {
      File compressedFile = await FlutterNativeImage.compressImage(
          croppedFile.path,
          quality: 70,
          percentage: 70);
      file = PickedFile(compressedFile.path);
      // file = PickedFile(croppedFile.path);
      setState(() {});
    }
  }
}
