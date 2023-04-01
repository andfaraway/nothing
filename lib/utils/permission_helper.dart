import 'dart:io';

import 'package:nothing/utils/toast_utils.dart';
import 'package:permission_handler/permission_handler.dart';

/// 检查照相机权限
Future<bool> checkPermissionCamera({
  bool isShowToast = true,
}) async {
  PermissionStatus status = await Permission.camera.status;
  if (status.isDenied) {
    status = await Permission.camera.request();
  }
  if (!status.isGranted) {
    if (isShowToast) {
      showToast('未开启权限');
    }
    return false;
  }
  return true;
}

/// 检查相册权限
Future<bool> checkPermissionPhotos({
  bool isShowToast = true,
}) async {
  PermissionStatus status = Platform.isIOS
      ? (await Permission.photos.status)
      : (await Permission.storage.status);
  if (status.isDenied) {
    status = Platform.isIOS
        ? (await Permission.photos.request())
        : (await Permission.storage.request());
  }
  if (!status.isGranted && !status.isLimited) {
    if (isShowToast) {
      showToast('未开启权限');
    }
    return false;
  }
  return true;
}

/// 检查保存图片权限
Future<bool> checkPermissionSavePhoto({
  bool isShowToast = true,
}) async {
  PermissionStatus status = Platform.isIOS
      ? (await Permission.photosAddOnly.status)
      : (await Permission.storage.status);
  if (status.isDenied) {
    status = Platform.isIOS
        ? (await Permission.photosAddOnly.request())
        : (await Permission.storage.request());
  }
  if (!status.isGranted) {
    if (isShowToast) {
      showToast('未开启权限');
    }
    return false;
  }
  return true;
}

/// 检查安装权限
Future<bool> checkPermissionInstall({
  bool isShowToast = true,
}) async {
  PermissionStatus status = await Permission.requestInstallPackages.status;
  if (status.isDenied) {
    status = await Permission.requestInstallPackages.request();
  }
  if (!status.isGranted) {
    if (isShowToast) {
      showToast('未开启权限');
    }
    return false;
  }
  return true;
}
