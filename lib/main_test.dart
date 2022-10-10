import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:nothing/utils/photo_save.dart';

void mainTest() async {
  return;
  String path = '/Users/libin/Downloads/hunligenpai_z/IMG_7510.jpg';
  File compressedFile = await FlutterNativeImage.compressImage(
    path,
    quality: 80,
  );
  print('compressedFile.path=${compressedFile.path}');
  exit(0);
}
