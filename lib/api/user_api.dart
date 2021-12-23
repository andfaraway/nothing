
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nothing/constants/constants.dart';
import 'package:nothing/model/models.dart';
import 'package:nothing/widgets/dialogs/confirmation_dialog.dart';


class UserAPI {
  const UserAPI._();

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

  // 第三方登录
  static Future<Map<String,dynamic>?> thirdLogin({String? name,int? platform,String? openId,String? icon,}) async{
    Map<String,dynamic> param = {'name':name,'platform':platform,'openId':openId,'icon':icon};
    var response = await NetUtils.post(API.thirdLogin,queryParameters: param);
    print(response);
    if(response?.data['code'].toString() == "200"){
      return response?.data['data'][0];
    }else{
      return null;
    }
  }


  // 注册推送 userId, 推送id：pushToken, 别名：alias
  static Future<Map<String,dynamic>?> registerNotification({String? userId, String? pushToken,String? alias, String? registrationId, String? identifier}) async{
    Map<String,dynamic> param = {'user_id':userId,'push_token':pushToken,'alias':alias,'registration_id':registrationId,'identifier':identifier};
    var response = await NetUtils.post(API.registerNotification,queryParameters: param);
    print(response);
    if(response?.data['code'].toString() == "200"){
      return response?.data['data'][0];
    }else{
      return null;
    }
  }

}
