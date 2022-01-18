//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 10:49:11
//

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/utils/notification_utils.dart';
import 'constants/constants.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
  }

  Future<void> initData() async {
    //读取本地信息
    await Singleton.loadData();
    //初始化推送信息
    if (await Constants.isPhysicalDevice() || !kIsWeb) {
      NotificationUtils.jPushInit();
    }

    //判断是否登录
    if (Singleton.currentUser.userId != null) {
      goPage(const HomePage());
    } else {
      goPage(const LoginPage());
    }

    //通知加载完毕
    Map<dynamic, dynamic>? result =
        await Instances.platformChannel.invokeMapMethod('welcomeLoad');

    if (result != null) {
      BuildContext context = navigatorState.overlay!.context;
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => const MessagePage()));
    }

  }

  goPage(Widget page) async {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => page), (_) => false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screens.init(context, const Size(750, 1624));

    return const Scaffold(
      body: Center(
        child: Text('Nothing'),
      ),
    );
  }
}
