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
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  late LaunchInfo launchInfo;

  /// 选择图片的类型 0.image 1.image_background
  int imageType = 0;

  @override
  void initState() {
    super.initState();
    launchInfo = context.read<LaunchProvider>().launchInfo ?? LaunchInfo();
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
                  AppResponse response = await API.insertLaunchInfo(param);
                  if (response.isSuccess) {
                    showToast(S.current.success);
                    setState(() {
                      launchInfo = LaunchInfo();
                    });
                  }
                },
                child: Text(
                  S.current.upload,
                  style: const TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
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
              25.hSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [_imageBox(url: launchInfo.image), 10.hSizedBox, const Text('image')],
                  ),
                  50.wSizedBox,
                  Column(
                    children: [
                      _imageBox(url: launchInfo.backgroundImage),
                      10.hSizedBox,
                      const Text('image_background')
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageBox({required String? url}) {
    Widget child;

    if (url != null) {
      child = AppImage.network(url);
    } else {
      child = const SizedBox.shrink();
    }

    BorderRadiusGeometry borderRadius = BorderRadius.circular(AppSize.radiusMedium);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColor.black.withOpacity(.2)),
        borderRadius: borderRadius,
      ),
      width: 100.w,
      height: 100.w,
      child: ClipRRect(borderRadius: borderRadius, child: child),
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
    XFile? file = await picker.pickImage(source: source).catchError((error) {
      openAppSettings();
      return null;
    });

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file?.path ?? '',
      // aspectRatioPresets: Constants.isAndroid
      //     ? [
      //         CropAspectRatioPreset.square,
      //         CropAspectRatioPreset.ratio3x2,
      //         CropAspectRatioPreset.original,
      //         CropAspectRatioPreset.ratio4x3,
      //         CropAspectRatioPreset.ratio16x9
      //       ]
      //     : [
      //         CropAspectRatioPreset.original,
      //         CropAspectRatioPreset.square,
      //         CropAspectRatioPreset.ratio3x2,
      //         CropAspectRatioPreset.ratio4x3,
      //         CropAspectRatioPreset.ratio5x3,
      //         CropAspectRatioPreset.ratio5x4,
      //         CropAspectRatioPreset.ratio7x5,
      //         CropAspectRatioPreset.ratio16x9
      //       ],
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
    );

    if (croppedFile != null) {
      File compressedFile = await FlutterNativeImage.compressImage(croppedFile.path, quality: 70, percentage: 70);
      PickedFile? file = PickedFile(compressedFile.path);
      upload(file);
    }
  }

  /// 上传文件
  Future<void> upload(PickedFile? file) async {
    final DateTime now = DateTime.now();
    String fileName =
        '${now.year.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.jpg';
    AppResponse response = await API.uploadFile(
        path: file?.path ?? '',
        fileName: fileName,
        onSendProgress: (progress) {
          EasyLoading.showProgress(progress);
        });
    if (response.isSuccess) {
      String url = response.dataMap['url'];
      if (imageType == 0) {
        launchInfo.image = url;
      } else if (imageType == 1) {
        launchInfo.backgroundImage = url;
      }
      setState(() {});
      showToast(S.current.success);
    }
  }
}
