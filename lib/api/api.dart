///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/2 13:25
///
import 'dart:core';

import 'package:nothing/widgets/webview/in_app_webview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';

export 'sign_api.dart';
export 'user_api.dart';

/// Definition of various sorts of APIs.
/// 各项接口定义
class API {
  const API._();

  static const bool isDebug = true;
  // static const bool isDebug = false;

  static const baseUrl = isDebug ? 'http://192.168.0.3:5000' : 'http://1.14.252.115:5000';

  ///第三方登录
  static const String thirdLogin = baseUrl + '/thirdLogin';

  ///注册推送
  static const String registerNotification = baseUrl + '/registerNotification';

  ///发送消息
  static const String sayHello = baseUrl + '/sayHello';

  ///检查更新
  static const String checkUpdate = baseUrl + '/checkUpdate';

  ///登录
  static const String login = 'https://openjmu.jmu.edu.cn';

  ///登录
  static const String signList = 'https://openjmu.jmu.edu.cn';

  ///登录
  static const String signSummary = 'https://openjmu.jmu.edu.cn';

  ///状态
  static const String signStatus = 'https://openjmu.jmu.edu.cn';

  ///公告
  static const String announcement = 'https://openjmu.jmu.edu.cn';

  static const String tianApi = 'http://api.tianapi.com';
  static const String secretKey = 'e1d306002add9c529feaa829d3969766';

  ///生活小窍门
  static const String qiaomen =
      tianApi + '/qiaomen/index' + '?key=' + secretKey;

  ///健康提示
  static const String healthTips =
      tianApi + '/healthtip/index' + '?key=' + secretKey;

  ///彩虹屁
  static const String caihongpi =
      tianApi + '/caihongpi/index' + '?key=' + secretKey;

  ///今日头条新闻
  static const String topNews =
      tianApi + '/topnews/index' + '?key=' + secretKey;

  ///中国老黄历
  static const String huangli = tianApi + '/lunar/index' + '?key=' + secretKey;

  ///土味情话
  static const String sayLove = tianApi + '/saylove/index' + '?key=' + secretKey;


  static Future<bool> launchWeb({
    required String url,
    String? title,
    WebApp? app,
    bool withCookie = true,
  }) async {
    final SettingsProvider provider = Provider.of<SettingsProvider>(
      currentContext,
      listen: false,
    );
    final bool shouldLaunchFromSystem = provider.launchFromSystemBrowser;
    final String uri = '${Uri.parse(url.trim())}';
    if (shouldLaunchFromSystem) {
      LogUtils.d('Launching web: $uri');
      return launch(
        uri,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: true,
        enableDomStorage: true,
      );
    } else {
      LogUtils.d('Launching web: $uri');
      AppWebView.launch(
        url: uri,
        title: title,
        app: app,
        withCookie: withCookie,
      );
      return true;
    }
  }

  static Future<String> loadTips() async{
    var response = await NetUtils.get(API.sayLove);
    String tipsStr = '';
    if(response.data['code'].toString() == "200"){
      tipsStr = response.data['newslist'].first['content'];
    }
    return tipsStr;
  }


}
