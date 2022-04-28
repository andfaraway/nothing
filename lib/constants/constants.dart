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
import 'package:nothing/utils/photo_save.dart';

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
export 'screens.dart';
export 'widgets.dart';
export '../utils/local_data_utils.dart';
export 'platform_channel.dart';
export 'package:nothing/utils/utils.dart';

export 'colors.dart';

export 'singleton.dart';

const double kAppBarHeight = 86.0;
const double kDrawerMarginLeft = 16.0;

const bool isDebug =  true;

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
  static final String deviceType = Platform.isIOS ? 'iPhone' : 'Android';


  /// 检查更新
  static Future<void> checkUpdate({Map? data}) async {
    BuildContext context = navigatorState.overlay!.context;
    if (data == null) {
      String version = await DeviceUtils.version();
      data = await UserAPI.checkUpdate('ios', version);
    }
    if (data != null && data['update'] == true) {
      showDialog(
          context: context,
          builder: (context) {
            return CheckUpdateWidget(
              title: data!['title'],
              content: data['content'],
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
    param['alias'] = await LocalDataUtils.get(KEY_ALIAS);
    //电量
    param['battery'] = await DeviceUtils.battery();
    //设备信息
    param['device_info'] = await DeviceUtils.getDeviceInfo();
    //网络
    param['network'] = await DeviceUtils.network();
    //版本
    param['version'] = await DeviceUtils.version();

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
