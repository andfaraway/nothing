
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nothing/constants/constants.dart';
import 'package:nothing/model/models.dart';
import 'package:nothing/widgets/dialogs/confirmation_dialog.dart';

UserInfo get currentUser => UserAPI.currentUser;

set currentUser(UserInfo? user) {
  if (user == null) {
    return;
  }
  UserAPI.currentUser = user;
}

class UserAPI {
  const UserAPI._();

  static UserInfo currentUser = const UserInfo();


  static Future<Response<Map<String, dynamic>>> login(
    Map<String, dynamic> params,
  ) {
    return NetUtils.tokenDio.post(API.login, data: params);
  }

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
}
