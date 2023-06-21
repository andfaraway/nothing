//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-27 15:53:52
//
import 'package:path_provider/path_provider.dart';

import '../common/constants.dart';

class PathUtils {
  PathUtils._();

  static Future<void> init() async {
    if (Constants.isWeb) {
      documentPath = '';
      tempPath = '';
      webPath = '';
      return;
    }
    documentPath = (await getApplicationDocumentsDirectory()).path;
    tempPath = (await getTemporaryDirectory()).path;
  }

  static late String documentPath;
  static late String tempPath;
  static late String webPath;

  static String get fontPath => Constants.isWeb ? '' : '${PathUtils.documentPath}/fonts';
}
