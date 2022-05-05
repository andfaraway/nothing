//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-15 18:21:40
//

import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/constants.dart';
import 'http.dart';

/// Definition of various sorts of APIs.
/// 各项接口定义
class API {
  const API._();

  /// 生活小窍门
  static Future<dynamic> getQiaomen() async {
    return Http.get(ConstUrl.qiaomen);
  }

  // 登录
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    Map<String, dynamic> param = {'username': username, 'password': password};
    var response = await Http.post(ConstUrl.login, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'][0];
    } else {
      return null;
    }
  }

  // 第三方登录
  static Future<Map<String, dynamic>?> thirdLogin({
    String? name,
    int? platform,
    String? openId,
    String? icon,
  }) async {
    Map<String, dynamic> param = {
      'name': name,
      'platform': platform,
      'openId': openId,
      'icon': icon
    };
    var response = await Http.post(ConstUrl.thirdLogin, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'][0];
    } else {
      return null;
    }
  }

  // 检查更新
  static Future<Map<String, dynamic>?> checkUpdate(
      String platform, String version) async {
    Map<String, dynamic> param = {
      'platform': platform,
      'version': version,
    };
    var response = await Http.post(ConstUrl.checkUpdate, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'][0];
    } else {
      return null;
    }
  }

  // 注册推送 userId, 推送id：pushToken, 别名：alias
  static Future<Map<String, dynamic>?> registerNotification(
      {String? userId,
      String? pushToken,
      String? alias,
      String? registrationId,
      String? identifier}) async {
    Map<String, dynamic> param = {
      'user_id': userId,
      'push_token': pushToken,
      'alias': alias,
      'registration_id': registrationId,
      'identifier': identifier
    };
    var response =
        await Http.post(ConstUrl.registerNotification, params: param);
    if (response?.data['code'].toString() == "200") {
      return {};
    } else {
      return null;
    }
  }

  // 发送消息 alias：别名  alert：消息内容
  static Future<Map<String, dynamic>?> sayHello(
      String alias, String alert) async {
    Map<String, dynamic> param = {
      'alias': alias,
      'alert': alert,
    };
    var response = await Http.post(ConstUrl.sayHello, params: param);
    if (response?.data['code'].toString() == "200") {
      return {};
    } else {
      return null;
    }
  }

  // 获取消息列表
  static Future<List?> getMessages(String? alias) async {
    Map<String, dynamic> param = {'alias': alias};
    var response = await Http.post(ConstUrl.getMessages, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }

  //删除消息
  static Future<List?> deleteMessages(String? id) async {
    Map<String, dynamic> param = {'id': id};
    var response = await Http.post(ConstUrl.deleteMessage, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }

  //删除消息
  static Future<List?> pushDeviceToken(
    String? userid,
    String? deviceToken,
  ) async {
    Map<String, dynamic> param = {
      'userid': userid,
      'deviceToken': deviceToken,
      'debug': isDebug
    };
    var response = await Http.post(ConstUrl.pushDeviceToken, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }

  // 添加收藏
  static Future<List?> addFavorite(String content, {String? source}) async {
    Map<String, dynamic> param = {
      'userid': Singleton.currentUser.userId,
      'content': content,
      'source': source
    };
    var response = await Http.post(ConstUrl.addFavorite, params: param);
    if (response?.data['code'].toString() == "200") {
      return [];
    } else {
      showToast(response?.data['msg']);
      return null;
    }
  }

  // 查询收藏
  static Future<List?> getFavorite() async {
    Map<String, dynamic> param = {'userid': Singleton.currentUser.userId};
    var response = await Http.post(ConstUrl.getFavorite, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }

  // 删除收藏
  static Future<List?> deleteFavorite(String favoriteId) async {
    Map<String, dynamic> param = {
      'userid': Singleton.currentUser.userId,
      'favoriteId': favoriteId
    };
    var response = await Http.post(ConstUrl.deleteFavorite, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data;
    } else {
      return null;
    }
  }

  // 添加反馈
  static Future<List?> addFeedback(String content, String? nickname) async {
    Map<String, dynamic> param = {
      'userid': Singleton.currentUser.userId,
      'content': content,
      'nickname': nickname
    };
    var response = await Http.post(ConstUrl.addFeedback, params: param);
    if (response?.data['code'].toString() == "200") {
      return [];
    } else {
      showToast(response?.data['msg']);
      return null;
    }
  }

  //插入登录表
  static Future<List<dynamic>?> insertLaunchInfo(
      Map<String, dynamic>? param) async {
    var response = await Http.post(ConstUrl.insertLaunchInfo, params: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }

  // 获取启动页信息
  static Future<Map<String, dynamic>?> getLaunchInfo({String? date}) async {
    Map<String, dynamic>? param = date == null ? null : {'date': date};
    var response = await Http.get(ConstUrl.getLaunchInfo, params: param);
    if (response.data['code'].toString() == "200") {
      return response.data['data'];
    } else {
      return null;
    }
  }

  // 获取设置模块
  static Future<List<dynamic>?> getSettingModule({String? accountType}) async {
    Map<String, dynamic>? param =
        accountType == null ? null : {'accountType': accountType};
    var response = await Http.get(ConstUrl.getSettingModule, params: param);
    if (response.data['code'].toString() == "200") {
      return response.data['data'];
    } else {
      return null;
    }
  }

  // 获取获取今日提示
  static Future<Map<String, dynamic>?> getTips() async {
    var response = await Http.get(
      ConstUrl.getTips,
    );
    if (response.data['code'].toString() == "200") {
      return response.data['data'];
    } else {
      return null;
    }
  }

  // 上传文件
  static uploadFile(String imagePath, String fileName) async {
    List list = imagePath.split('.');
    String houzhui = list.last;
    if (houzhui.length == 1) {
      houzhui = 'jpg';
    }

    MultipartFile f =
        await MultipartFile.fromFile(imagePath, filename: fileName);
    FormData formData = FormData.fromMap({
      'file': f,
      //传参信息
      "type": 'launchImage',
      "name": fileName
    });

    return Http.post(ConstUrl.uploadFile, data: formData,
        onSendProgress: (a, b) {
      double s = double.parse(a.toString()) / double.parse(b.toString());
      EasyLoading.showProgress(s);
    });
  }

  static Future<String> loadTips() async {
    var response = await Http.get(ConstUrl.sayLove);
    String tipsStr = '';
    if (response.data['code'].toString() == "200") {
      tipsStr = response.data['newslist'].first['content'];
    }
    return tipsStr;
  }
}

class ConstUrl {
  ConstUrl._();

  static const baseUrl =
      isDebug ? 'http://10.0.21.184:5000' : 'http://1.14.252.115:5000';

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
}
