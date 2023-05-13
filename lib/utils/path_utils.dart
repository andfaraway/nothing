//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-27 15:53:52
//
import 'package:path_provider/path_provider.dart';

class PathUtils {
  PathUtils._();

  static Future<void> init() async {
    documentPath = (await getApplicationDocumentsDirectory()).path;
    tempPath = (await getTemporaryDirectory()).path;
  }

  static late String documentPath;
  static late String tempPath;

  static get fontPath => '${PathUtils.documentPath}/fonts';
}
