//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-16 18:49:44
//
import 'package:flutter/material.dart';
import 'package:nothing/page/favorite_page.dart';
import 'package:nothing/page/feedback_page.dart';
import 'package:nothing/page/information_page.dart';
import 'package:nothing/page/live_photo_page.dart';
import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/logins_page.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/page/release_version.dart';
import 'package:nothing/page/say_hi.dart';
import 'package:nothing/page/theme_setting.dart';
import 'package:nothing/page/upload_file.dart';
import 'package:nothing/page/wedding_about.dart';
import 'package:nothing/public.dart';
import 'package:nothing/welcome_page.dart';

class AppRoutes {
  final String routeName;
  final Widget page;
  final String? pageTitle;
  final String? pageType;

  const AppRoutes(
    this.routeName,
    this.page, {
    this.pageTitle,
    this.pageType,
  });

  static Future<dynamic> pushPage(BuildContext context, Widget page) async {
    dynamic value =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
    return value;
  }

  static Future<dynamic> pushNamePage(
      BuildContext context, String routeName) async {
    dynamic value = await Navigator.pushNamed(context, routeName);
    return value;
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
      BuildContext context, String newRouteName) async {
    dynamic value = await Navigator.pushNamedAndRemoveUntil(
        context, newRouteName, (route) => false);
    return value;
  }

  static Future<void> popUntil(BuildContext context, String routeName) async {
    Navigator.popUntil(context, (route) {
      if (route.settings.name == routeName) {
        return true;
      }
      return false;
    });
  }

  static Map<String, Widget Function(BuildContext)> routes = {
    welcomeRoute.routeName: (BuildContext context) => welcomeRoute.page,
    favoriteRoute.routeName: (BuildContext context) => favoriteRoute.page,
    feedbackRoute.routeName: (BuildContext context) => feedbackRoute.page,
    loginRoute.routeName: (BuildContext context) => loginRoute.page,
    messageRoute.routeName: (BuildContext context) => messageRoute.page,
    welcomeRoute.routeName: (BuildContext context) => welcomeRoute.page,
    releaseVersionRoute.routeName: (BuildContext context) =>
        releaseVersionRoute.page,
    sayHiRoute.routeName: (BuildContext context) => sayHiRoute.page,
    themeSettingRoute.routeName: (BuildContext context) =>
        themeSettingRoute.page,
    uploadFileRoute.routeName: (BuildContext context) => uploadFileRoute.page,
    informationRoute.routeName: (BuildContext context) => informationRoute.page,
    livePhotoRoute.routeName: (BuildContext context) => livePhotoRoute.page,
    weddingAboutRoute.routeName: (BuildContext context) => weddingAboutRoute.page,
    loginsRoute.routeName: (BuildContext context) => loginsRoute.page,
  };
}

const AppRoutes welcomeRoute = AppRoutes('/welcomeRoute', WelcomePage());
const AppRoutes favoriteRoute = AppRoutes('/favoriteRoute', FavoritePage());
const AppRoutes feedbackRoute = AppRoutes('/feedbackRoute', FeedbackPage());
const AppRoutes loginRoute = AppRoutes('/loginRoute', LoginPage());
const AppRoutes messageRoute = AppRoutes('/messageRoute', MessagePage());
const AppRoutes releaseVersionRoute =
    AppRoutes('/releaseVersionRoute', ReleaseVersion());
const AppRoutes sayHiRoute = AppRoutes('/sayHiRoute', SayHi());
const AppRoutes themeSettingRoute =
    AppRoutes('/themeSettingRoute', ThemeSettingPage());
const AppRoutes uploadFileRoute = AppRoutes('/uploadFileRoute', UploadFile());
const AppRoutes informationRoute = AppRoutes('/informationRoute',
    InformationPage());
const AppRoutes livePhotoRoute = AppRoutes('/livePhotoRoute',
    LivePhotoPage());
const AppRoutes weddingAboutRoute = AppRoutes('/weddingAboutRoute',
    WeddingAbout());
const AppRoutes loginsRoute = AppRoutes('/loginsRoute',
    LoginsPage());


/// 处理服务器目标页面
class ServerTargetModel {
  ServerTargetModel({this.type = 0, this.url, this.page, this.routeName});

  /// [type] 类型0.页面  1.webView
  int type;

  /// [url] webView url
  String? url;

  /// [page] 路由页面
  Widget? page;

  ///  [routeName]路由名称
  String? routeName;

  /// 安全头部
  bool safeTop = false;

  static ServerTargetModel fromString(BuildContext context, String targetStr) {
    ServerTargetModel model = ServerTargetModel();
    if ('web:'.matchAsPrefix(targetStr) != null) {
      model.type = 1;
      String content = targetStr.split('web:').last;
      if(targetStr.contains("&")){
        if(content.split('&').first.toString() == '1'){
          model.safeTop = true;
        }
        model.url = content.split("&").last;
      }else{
        model.url = content;
      }

    } else {
      model.type = 0;
      model.routeName = targetStr;
      model.page = AppRoutes.routes[targetStr]?.call(context);
    }
    return model;
  }
}
