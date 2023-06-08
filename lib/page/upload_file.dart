//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-06 15:53:41
//
import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({Key? key}) : super(key: key);

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  String? fileName;
  LaunchInfo launchInfo = LaunchInfo();
  PickedFile? imageFile;
  PickedFile? bgImageFile;

  /// 选择图片的类型 0.image 1.image_background
  int imageType = 0;

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.launch_screen),
          actions: [
            TextButton(
                onPressed: () async {
                  Map<String, dynamic> param = {
                    'id': launchInfo.date,
                    'festival': launchInfo.date,
                    'content': launchInfo.contentStr,
                    'author': launchInfo.authorStr,
                    'qr_code': launchInfo.codeStr,
                    'home_page': launchInfo.homePage,
                    'image': launchInfo.image,
                    'image_background': launchInfo.backgroundImage,
                  };
                  await API.insertLaunchInfo(param);
                  showToast(S.current.success);
                  setState(() {
                    launchInfo = LaunchInfo();
                  });
                },
                child: Text(
                  S.current.upload,
                  style: const TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Column(
          children: [
            inputCell(
                title: 'id',
                text: launchInfo.date,
                onChanged: (value) {
                  launchInfo.date = value;
                }),
            inputCell(
                title: 'festival',
                text: launchInfo.title,
                onChanged: (value) {
                  launchInfo.title = value;
                }),
            inputCell(
                title: 'content',
                text: launchInfo.contentStr,
                onChanged: (value) {
                  launchInfo.contentStr = value;
                },
                required: true),
            inputCell(
                title: 'author',
                text: launchInfo.authorStr,
                onChanged: (value) {
                  launchInfo.authorStr = value;
                }),
            inputCell(
                title: 'qr_code',
                text: launchInfo.codeStr,
                onChanged: (value) {
                  launchInfo.codeStr = value;
                }),
            inputCell(
                title: 'homePage',
                text: launchInfo.homePage,
                onChanged: (value) {
                  launchInfo.homePage = value;
                }),
            inputCell(
                title: 'image',
                text: launchInfo.image,
                onChanged: (value) {
                  launchInfo.image = value;
                },
                trailing: MaterialButton(
                    color: Colors.blue,
                    child: Text(S.current.select),
                    onPressed: () {
                      imageType = 0;
                      selectFile();
                    }),
                required: true),
            inputCell(
                title: 'image_background',
                text: launchInfo.backgroundImage,
                onChanged: (value) {
                  launchInfo.backgroundImage = value;
                },
                trailing: MaterialButton(
                    color: Colors.blue,
                    child: Text(S.current.select),
                    onPressed: () {
                      imageType = 1;
                      selectFile();
                    }),
                required: true),
            50.hSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColor.black.withOpacity(.2)),
                      ),
                      width: 100.w,
                      height: 100.w,
                      child: imageFile?.path == null ? const SizedBox.shrink() : Image.asset(imageFile?.path ?? ''),
                    ),
                    10.hSizedBox,
                    const Text('image')
                  ],
                ),
                100.wSizedBox,
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColor.black.withOpacity(.2)),
                      ),
                      width: 100.w,
                      height: 100.w,
                      child: bgImageFile?.path == null ? const SizedBox.shrink() : Image.asset(bgImageFile?.path ?? ''),
                    ),
                    10.hSizedBox,
                    const Text('image_background')
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 输入cell
  Widget inputCell(
      {required String title, String? text, ValueChanged<String>? onChanged, Widget? trailing, bool required = false}) {
    return ListTile(
        // title: Text(title),
        subtitle: TextField(
            controller: TextEditingController(text: text),
            decoration: InputDecoration(
                labelText: title,
                labelStyle: TextStyle(color: required ? AppColor.red : AppColor.black),
                hintText: required ? S.current.input_required : S.current.input_optional,
                hintStyle: TextStyle(color: required ? AppColor.red.withOpacity(.5) : AppColor.black.withOpacity(.2))),
            onChanged: onChanged),
        trailing: trailing);
  }

  /// 选择文件
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

  /// 裁剪图片 0.相机  1.相册
  Future<void> _cropImage(int type) async {
    ImageSource source = ImageSource.camera;
    if (type == 1) {
      source = ImageSource.gallery;
    }
    ImagePicker picker = ImagePicker();
    PickedFile? file = await picker.getImage(source: source).catchError((error) {
      print('picker error : ' + error.toString());
      openAppSettings();
    });

    File? croppedFile = (await ImageCropper().cropImage(
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
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Clip',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Clip',
        )
      ],
    )) as File?;

    if (croppedFile != null) {
      File compressedFile = await FlutterNativeImage.compressImage(croppedFile.path, quality: 70, percentage: 70);
      PickedFile? file = PickedFile(compressedFile.path);
      imageType == upload(file);
    }
  }

  /// 上传文件
  Future<void> upload(PickedFile? file) async {
    EasyLoading.show();
    // 上传文件
    var data = await API.uploadFile(file?.path ?? '', fileName ?? '');
    String url = data['url'];
    if (imageType == 0) {
      launchInfo.image = url;
    } else if (imageType == 1) {
      launchInfo.backgroundImage = url;
    }
    setState(() {});
    EasyLoading.dismiss();
    showToast(S.current.success);
  }
}
