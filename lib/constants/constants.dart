import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
export 'package:intl/intl.dart' show DateFormat;
export 'package:pull_to_refresh/pull_to_refresh.dart';

export '../api/api.dart';
export '../extensions/extensions.e.dart';
export '../model/models.dart';
export '../providers/providers.dart';
export '../utils/utils.dart';
export 'enums.dart';
export 'events.dart';
export 'hive_boxes.dart';
export 'instances.dart';
export 'messages.dart';
export 'resources.dart';
export 'screens.dart';
export 'widgets.dart';
export '../utils/local_data_utils.dart';

export 'singleton.dart';

const double kAppBarHeight = 86.0;
const double kDrawerMarginLeft = 16.0;

Color getRandomColor() {
  int a = 255;
  int r = Random().nextInt(255);
  int g = Random().nextInt(255);
  int b = Random().nextInt(255);
  return Color.fromARGB(a, r, g, b);
}

class Constants {
  const Constants._();

  /// Whether force logger to print.
  static bool get forceLogging => false;

  ///暗黑模式
  static bool isDark = false;

  static const String endLineTag = '没有更多了';

  /// Fow news list.
  static final int appId = Platform.isIOS ? 274 : 273;
  static const String apiKey = 'c2bd7a89a377595c1da3d49a0ca825d5';
  static const String cloudId = 'jmu';
  static final String deviceType = Platform.isIOS ? 'iPhone' : 'Android';
  static const int marketTeamId = 430;
  static const String unitCode = 'jmu';
  static const int unitId = 55;

  static const String postApiKeyAndroid = '1FD8506EF9FF0FAB7CAFEBB610F536A1';
  static const String postApiSecretAndroid = 'E3277DE3AED6E2E5711A12F707FA2365';
  static const String postApiKeyIOS = '3E63F9003DF7BE296A865910D8DEE630';
  static const String postApiSecretIOS = '773958E5CFE0FF8252808C417A8ECCAB';

  static const String keyFavoriteList = 'keyFavoriteList';

}
