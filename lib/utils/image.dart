import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nothing/utils/permission_helper.dart';
import 'package:nothing/utils/web_import.dart';

import '../common/constants.dart';
import '../common/style.dart';

class AppImage {
  AppImage._();

  static Widget asset(
    String assetName, {
    Key? key,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.cover,
  }) {
    if (assetName.toLowerCase().endsWith('svg')) {
      return SvgPicture.asset(
        assetName,
        key: key,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(
                color,
                BlendMode.srcIn,
              )
            : null,
        fit: fit,
      );
    } else {
      return Image.asset(
        assetName,
        key: key,
        width: width,
        height: height,
        color: color,
        fit: fit,
      );
    }
  }

  static Widget network(String url,
      {Key? key,
      double? width,
      double? height,
      Color? color,
      Widget? placeholder,
      Widget? errorWidget,
      BoxFit fit = BoxFit.cover}) {
    return CachedNetworkImage(
      key: key,
      imageUrl: url,
      width: width,
      height: height,
      color: color,
      fit: fit,
      placeholder: (_, __) =>
          placeholder ??
          Container(
            color: AppColor.transparent,
          ),
      errorWidget: (_, __, ___) => errorWidget ?? placeholder ?? Container(),
    );
  }

  static Widget file(
    File? asset, {
    Key? key,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.cover,
  }) {
    if (asset == null) return const SizedBox.shrink();
    if (Constants.isWeb) {
      return ExtendedImage.network(asset as String);
    } else {
      return ExtendedImage.file(asset);
    }
  }
}

Future<bool> saveImageToLocal(
  Uint8List? imageBytes, {
  int quality = 80,
  String? name,
}) async {
  if (imageBytes == null) {
    showToast('保存失败');
    return Future.value(false);
  }
  bool status = await checkPermissionPhotos();
  if (status) {
    try {
      final result = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: quality,
        name: name,
      );
      bool isSuccess = result is Map && result['isSuccess'] == true;
      showToast(isSuccess ? '保存成功' : '保存失败');
      return isSuccess;
    } catch (e) {
      Log.e('saveImageToLocal=>$e');
      return false;
    }
  }
  return false;
}

Future<Uint8List?> imageFromRenderRepaintBoundary(RenderRepaintBoundary renderRepaintBoundary) async {
  var image = await renderRepaintBoundary.toImage(pixelRatio: window.devicePixelRatio);
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  Uint8List? pnyBytes = byteData?.buffer.asUint8List();
  return pnyBytes;
}

Future<Uint8List?> imageCompress(String path) async {
  return FlutterImageCompress.compressWithFile(
    path,
    minWidth: 1000,
    minHeight: 1200,
    quality: 85,
  );
}
