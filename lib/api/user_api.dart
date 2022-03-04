import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nothing/constants/constants.dart';
import 'package:nothing/model/models.dart';
import 'package:nothing/widgets/dialogs/confirmation_dialog.dart';

class UserAPI {
  const UserAPI._();

  static Future<void> logout(BuildContext context) async {
    final bool confirm = await ConfirmationDialog.show(
      context,
      title: '退出登录',
      showConfirm: true,
      content: '您正在退出账号，请确认操作',
    );
    if (confirm) {
      NetUtils.dio.clear();
      NetUtils.tokenDio.clear();
      // Instances.eventBus.fire(LogoutEvent());
    }
  }

  static Future<dynamic> getQiaomen() async {
    return NetUtils.get(API.qiaomen);
  }

  // 登录
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    Map<String, dynamic> param = {'username': username, 'password': password};
    var response = await NetUtils.post(API.login, queryParameters: param);
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
    var response = await NetUtils.post(API.thirdLogin, queryParameters: param);
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
    var response = await NetUtils.post(API.checkUpdate, queryParameters: param);
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
        await NetUtils.post(API.registerNotification, queryParameters: param);
    print(response);
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
      'alias': alias
    };
    var response = await NetUtils.post(API.sayHello, queryParameters: param);
    if (response?.data['code'].toString() == "200") {
      return {};
    } else {
      return null;
    }
  }

  // 获取消息列表
  static Future<List?> getMessages(String? alias) async {
    Map<String, dynamic> param = {'alias': alias};
    var response = await NetUtils.post(API.getMessages, queryParameters: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }

  //删除消息
  static Future<List?> deleteMessages(String? id) async {
    Map<String, dynamic> param = {'id': id};
    var response = await NetUtils.post(API.deleteMessage, queryParameters: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }

  //删除消息
  static Future<List?> pushDeviceToken(String? userid,String? deviceToken,) async {
    Map<String, dynamic> param = {'userid': userid,'deviceToken':deviceToken,'debug':isDebug};
    var response = await NetUtils.post(API.pushDeviceToken, queryParameters: param);
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
    var response = await NetUtils.post(API.addFavorite, queryParameters: param);
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
    var response = await NetUtils.post(API.getFavorite, queryParameters: param);
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
    var response =
        await NetUtils.post(API.deleteFavorite, queryParameters: param);
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
    var response = await NetUtils.post(API.addFeedback, queryParameters: param);
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
    var response =
        await NetUtils.post(API.insertLaunchInfo, queryParameters: param);
    if (response?.data['code'].toString() == "200") {
      return response?.data['data'];
    } else {
      return null;
    }
  }
}
