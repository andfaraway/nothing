import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nothing/common/prefix_header.dart';

import 'exception_report_util.dart';

export 'package:flutter/material.dart';
export 'package:nothing/generated/l10n.dart';
export 'package:nothing/utils/utils.dart';

export '../extensions/extensions.e.dart';
export '../model/models.dart';
export '../providers/providers.dart';
export '../utils/hive_boxes.dart';
export 'platform_channel.dart';
export 'screens.dart';
export 'singleton.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigatorState => navigatorKey.currentState!;

BuildContext get currentContext => navigatorState.context;

DateTime get currentTime => DateTime.now();

int get currentTimeStamp => currentTime.millisecondsSinceEpoch;

Color getRandomColor() {
  int a = 255;
  int r = Random().nextInt(255);
  int g = Random().nextInt(255);
  int b = Random().nextInt(255);
  return Color.fromARGB(a, r, g, b);
}

class Constants {
  const Constants._();

  static Future<void> init() async {
    await HiveBoxes.init();
    if (Constants.isWeb) return;
    await DeviceUtils.init();

    ExceptionReportUtil.init();
    await NotificationUtils.jPushInit();
    await PathUtils.init();

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(AppOverlayStyle.dark);

    PaintingBinding.instance.imageCache.maximumSizeBytes = 200 << 20;

    Singleton.welcomeLoadResult = await platformChannel.invokeMapMethod(ChannelKey.welcomeLoad);
  }

  static bool get isWeb => kIsWeb;

  static bool get isIOS => isWeb ? false : Platform.isIOS;

  static bool get isAndroid => isWeb ? false : Platform.isAndroid;

  static String get platform => isIOS
      ? 'ios'
      : isAndroid
          ? 'android'
          : 'web';

  /// Whether force logger to print.
  static bool get forceLogging => false;

  ///暗黑模式
  static bool isDark = false;

  /// 中文
  static final bool isChinese = (Intl.getCurrentLocale() == 'zh') ? true : false;

  static final bool isPhysicalDevice = DeviceUtils.deviceInfoModel.isPhysical;

  // 初始化音频播放
  static bool justAudioBackgroundInit = false;

  static const String endLineTag = '没有更多了';

  static final int appId = Constants.isIOS ? 274 : 273;
  static const String apiKey = 'c2bd7a89a377595c1da3d49a0ca825d5';

  /// 获取当天时间字符串
  static String get nowString => DateTime.now().format('yyyyMMdd');

  static bool get isLogin {
    return Handler.isLogin;
  }

  static void logout() {
    Singleton.cleanData();
    AppRoute.pushNamedAndRemoveUntil(currentContext, AppRoute.login.name);
  }

  static bool get isDebugMode {
    bool isDebugMode = false;
    // 如果debug模式下会触发赋值，只有在debug模式下才会执行assert
    assert(isDebugMode = true);
    return isDebugMode;
  }
}
