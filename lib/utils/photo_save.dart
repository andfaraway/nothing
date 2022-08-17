//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-12 16:13:39
//

import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nothing/constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nothing/utils/toast_utils.dart';

import 'net_utils.dart';

//全局key-截图key
final GlobalKey boundaryKey = GlobalKey();

/// 截屏图片生成图片流ByteData
Future<String> captureImage() async {
  RenderRepaintBoundary? boundary =
      boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
  double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
  var image = await boundary!.toImage(pixelRatio: dpr);
  // 将image转化成byte
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

  var filePath = "";

  Uint8List pngBytes = byteData!.buffer.asUint8List();
  // 获取手机存储（getTemporaryDirectory临时存储路径）
  Directory applicationDir = await getTemporaryDirectory();
  // getApplicationDocumentsDirectory();
  // 判断路径是否存在
  bool isDirExist = await Directory(applicationDir.path).exists();
  if (!isDirExist) Directory(applicationDir.path).create();
  // 直接保存，返回的就是保存后的文件
  File saveFile = await File(
          applicationDir.path + "${DateTime.now().toIso8601String()}.jpg")
      .writeAsBytes(pngBytes);
  filePath = saveFile.path;
  // if (Platform.isAndroid) {
  //   // 如果是Android 的话，直接使用image_gallery_saver就可以了
  //   // 图片byte数据转化unit8
  //   Uint8List images = byteData!.buffer.asUint8List();
  //   // 调用image_gallery_saver的saveImages方法，返回值就是图片保存后的路径
  //   String result = await ImageGallerySaver.saveImage(images);
  //   // 需要去除掉file://开头。生成要使用的file
  //   File saveFile = new File(result.replaceAll("file://", ""));
  //   filePath = saveFile.path;
  //
  //
  // } else if (Platform.isIOS) {
  //   // 图片byte数据转化unit8
  //
  // }

  return filePath;
}

//申请存本地相册权限
Future<bool> getPormiation() async {
  if (Platform.isIOS) {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
      ].request();
      // saveImage(globalKey);
    }
    return status.isGranted;
  } else {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
    return status.isGranted;
  }
}

//保存到相册
void savePhoto() async {
  RenderRepaintBoundary? boundary =
      boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;

  double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
  var image = await boundary!.toImage(pixelRatio: dpr);
  // 将image转化成byte
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  //获取保存相册权限，如果没有，则申请改权限
  bool permition = await getPormiation();

  var status = await Permission.photos.status;
  if (permition) {
    if (Platform.isIOS) {
      if (status.isGranted) {
        Uint8List images = byteData!.buffer.asUint8List();
        final result = await ImageGallerySaver.saveImage(images,
            quality: 60, name: "hello");
        EasyLoading.showToast("保存成功");
      }
      if (status.isDenied) {
        print("IOS拒绝");
      }
    } else {
      //安卓
      if (status.isGranted) {
        print("Android已授权");
        Uint8List images = byteData!.buffer.asUint8List();
        final result = await ImageGallerySaver.saveImage(images, quality: 60);
        if (result != null) {
          EasyLoading.showToast("保存成功");
        } else {
          print('error');
          // toast("保存失败");
        }
      }
    }
  } else {
    //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
    savePhoto();
  }
}

Future<void> saveLocalPhoto(
    {String? saveName, required String localPath}) async {
  final result = await ImageGallerySaver.saveFile(localPath, name: saveName);
  print(result);
  if (result['isSuccess'] == true) {
    showToast("保存成功");
  } else {
    showToast("请在设置中打开图片保存权限");
  }
  return;
  //获取保存相册权限，如果没有，则申请改权限
  bool permition = await getPormiation();
  var status = await Permission.photos.status;
  print(status);
  if (permition) {
    if (Platform.isIOS) {
      if (status.isGranted) {
        final result =
            await ImageGallerySaver.saveFile(localPath, name: saveName);
        EasyLoading.showToast("保存成功");
      }
      if (status.isDenied) {
        print("IOS拒绝");
      }
    } else {
      //安卓
      if (status.isGranted) {
        print("Android已授权");
        final result =
            await ImageGallerySaver.saveFile(localPath, name: saveName);
        if (result != null) {
          EasyLoading.showToast("保存成功");
        } else {
          print('error');
          // toast("保存失败");
        }
      }
    }
  } else {
    //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
    // saveLocalPhoto(saveName, localPath);
  }
}

/// 下载/保存到本地
Future<String?> saveToDocument(
    {required String url, required String saveName}) async {
  assert(
    url.contains('http'),
    'url is unavailable',
  );

  // 本地图片路径
  String localPath = PathUtils.documentPath + '/' + saveName;
  Response s = await NetUtils.download(urlPath: url, savePath: localPath,
      onReceiveProgress: (a,b){

      });

  // 下载完成，记录状态
  if (s.statusCode == 200) {
    return saveName;
  } else {
    LogUtils.d("download error ${s.toString()}");
    return null;
  }
}

// 保存网络图片
saveNetworkImg({required String imgUrl,ProgressCallback? progressCallback})
async {
  var response = await Dio()
      .get(imgUrl, options: Options(responseType: ResponseType.bytes),
      onReceiveProgress:progressCallback);
  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 100);
  if (result['isSuccess']) {
    EasyLoading.showToast(S.current.success);
  } else {
    EasyLoading.showToast(S.current.fail);
  }
}
