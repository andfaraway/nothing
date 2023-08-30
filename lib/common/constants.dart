import 'dart:io';
import 'dart:math';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:nothing/common/prefix_header.dart';

export 'package:flutter/material.dart';
export 'package:nothing/generated/l10n.dart';
export 'package:nothing/utils/utils.dart';

export '../extensions/extensions.e.dart';
export '../model/models.dart';
export '../providers/providers.dart';
export '../utils/hive_boxes.dart';
export '../utils/local_data_utils.dart';
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
    if (Constants.isWeb) return;
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    if (Constants.isIOS) {
      IosDeviceInfo iosInfo = await plugin.iosInfo;
      Constants.isPhysicalDevice = iosInfo.isPhysicalDevice;
    } else {
      AndroidDeviceInfo androidInfo = await plugin.androidInfo;
      isPhysicalDevice = androidInfo.isPhysicalDevice;
    }

    Singleton.welcomeLoadResult = await platformChannel.invokeMapMethod(ChannelKey.welcomeLoad);

    bugsnag.start(apiKey: '4fd3ffbad81d0bdd92652a79e208b91d');
  }

  static bool get isWeb => kIsWeb;

  static bool get isIOS => isWeb ? false : Platform.isIOS;

  static bool get isAndroid => isWeb ? false : Platform.isAndroid;

  static String get platform => isIOS
      ? 'ios'
      : isAndroid
          ? 'android'
          : 'web';

  static bool isPhysicalDevice = false;

  /// Whether force logger to print.
  static bool get forceLogging => false;

  ///暗黑模式
  static bool isDark = false;

  ///
  static late BuildContext context;

  /// 中文
  static final bool isChinese = (Intl.getCurrentLocale() == 'zh') ? true : false;

  // 初始化音频播放
  static bool justAudioBackgroundInit = false;

  static const String endLineTag = '没有更多了';

  static final int appId = Constants.isIOS ? 274 : 273;
  static const String apiKey = 'c2bd7a89a377595c1da3d49a0ca825d5';
  static final String deviceType = Constants.isIOS ? 'iPhone' : 'Android';

  /// 获取当天时间字符串
  static String get nowString => DateTime.now().format('yyyyMMdd');

  static Future<AppResponse> insertLaunch() async {
    if (Constants.isWeb) return AppResponse();
    if (Constants.isIOS && !Constants.isPhysicalDevice) return AppResponse();

    Map<String, dynamic>? param = {};
    param['userid'] = Singleton().currentUser.userId;
    param['username'] = Singleton().currentUser.username;
    //推送别名
    param['alias'] = HiveBoxes.get(HiveKey.pushAlias);
    //推送注册id
    param['registrationID'] = await NotificationUtils.jPush?.getRegistrationID();
    //电量
    param['battery'] = await DeviceUtils.battery();
    //设备信息
    param['device_info'] = await DeviceUtils.getDeviceInfo();
    //网络
    param['network'] = await DeviceUtils.network();
    //版本
    param['version'] = DeviceUtils.appVersion;

    return API.insertLaunch(param);
  }

  static bool get isLogin {
    return Handler.isLogin;
  }

  static void logout() {
    Singleton.cleanData();
    AppRoute.pushNamedAndRemoveUntil(currentContext, AppRoute.login.name);
  }
}
