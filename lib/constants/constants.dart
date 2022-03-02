import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nothing/api/user_api.dart';
import 'package:nothing/constants/instances.dart';
import 'package:nothing/constants/platform_channel.dart';
import 'package:nothing/constants/singleton.dart';
import 'package:nothing/widgets/check_update_widget.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/local_data_utils.dart';
import '../utils/utils.dart';

export 'package:flutter/material.dart';
export 'package:intl/intl.dart' show DateFormat;
export 'package:pull_to_refresh/pull_to_refresh.dart'
    hide RefreshIndicator, RefreshIndicatorState;
export 'package:nothing/generated/l10n.dart';
export '../api/api.dart';
export '../extensions/extensions.e.dart';
export '../model/models.dart';
export '../providers/providers.dart';
export 'enums.dart';
export 'events.dart';
export 'hive_boxes.dart';
export 'instances.dart';
export 'messages.dart';
export 'resources.dart';
export 'screens.dart';
export 'widgets.dart';
export '../utils/local_data_utils.dart';
export 'platform_channel.dart';
export 'package:nothing/utils/utils.dart';

export 'singleton.dart';

const double kAppBarHeight = 86.0;
const double kDrawerMarginLeft = 16.0;

//标记界面的context
BuildContext? globalContext;

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

  /// 检查更新
  static Future<void> checkUpdate({Map? data}) async {
    BuildContext context = navigatorState.overlay!.context;
    if (data == null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      data = await UserAPI.checkUpdate('ios', version);
    }
    if (data != null && data['update'] == true) {
      showDialog(
          context: context,
          builder: (context) {
            return CheckUpdateWidget(
              content: data!['content'],
              updateOnTap: () async {
                String url = data!['path'];
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              cancelOnTap: () {
                Navigator.pop(context);
              },
            );
          });
    } else {}
  }

  static Future<void> insertLaunchInfo() async{
    Map<String,dynamic>? param = {};
    param['userid'] = Singleton.currentUser.userId;
    param['username'] = Singleton.currentUser.username;

    //推送别名
    String? localAlias = await LocalDataUtils.get(KEY_ALIAS);
    param['alias'] = localAlias;

    //电池电量
    String battery = await DeviceUtils.battery();
    param['battery'] = battery;

    //设备信息
    String info = await DeviceUtils.getDeviceInfo();
    param['device_info'] = info;

    //network
    //设备信息
    String network = await DeviceUtils.network();
    param['network'] = network;

    UserAPI.insertLaunchInfo(param);
  }

  /// true:真机 false:模拟器
  static Future<bool> isPhysicalDevice() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await plugin.iosInfo;
      return iosInfo.isPhysicalDevice;
    } else {
      AndroidDeviceInfo androidInfo = await plugin.androidInfo;
      return androidInfo.isPhysicalDevice;
    }
  }

  static hideKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
