//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-27 15:53:52
//
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathUtils{
  PathUtils._();

  static Future<void> init()async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    PathUtils.documentPath = appDocDir.path;
  }
  static late String documentPath;
}
