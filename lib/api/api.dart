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

  static const baseUrl =
      isDebug ? 'http://10.0.21.183:5000' : 'http://1.14.252.115:5000';

  ///登录
  static const String login = baseUrl + '/login';

  ///第三方登录
  static const String thirdLogin = baseUrl + '/thirdLogin';

  ///注册推送
  static const String registerNotification = baseUrl + '/registerNotification';

  ///发送消息
  static const String sayHello = baseUrl + '/sayHello';

  ///检查更新
  static const String checkUpdate = baseUrl + '/checkUpdate';

  ///获取消息列表
  static const String getMessages = baseUrl + '/getMessages';

  ///删除消息
  static const String deleteMessage = baseUrl + '/deleteMessage';

  ///添加收藏
  static const String addFavorite = baseUrl + '/addFavorite';

  ///查询收藏
  static const String getFavorite = baseUrl + '/getFavorite';

  ///删除收藏
  static const String deleteFavorite = baseUrl + '/deleteFavorite';

  ///添加反馈
  static const String addFeedback = baseUrl + '/addFeedback';

  ///获取启动页信息
  static const String getLaunchInfo = baseUrl + '/getLaunchInfo';

  ///获取设置模块
  static const String getSettingModule = baseUrl + '/getSettingModule';

  ///上传文件
  static const String uploadFile = baseUrl + '/uploadFile';

  ///获取每日提示
  static const String getTips = baseUrl + '/getTips';

  ///添加登录信息
  static const String insertLaunchInfo = baseUrl + '/insertLaunchInfo';

  ///添加登录信息
  static const String pushDeviceToken = baseUrl + '/pushDeviceToken';

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
  static const String sayLove =
      tianApi + '/saylove/index' + '?key=' + secretKey;

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

  static Future<String> loadTips() async {
    var response = await NetUtils.get(API.sayLove);
    String tipsStr = '';
    if (response.data['code'].toString() == "200") {
      tipsStr = response.data['newslist'].first['content'];
    }
    return tipsStr;
  }
}
