//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 10:49:11
//

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/page/login_page.dart';
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

    //判断是否登录
    if (Singleton.currentUser.userId != null) {
      goPage(const HomePage());
    } else {
      goPage(const LoginPage());
    }

    //初始化推送
    if (kIsWeb) return;
    if (Platform.isIOS || Platform.isAndroid) {
      NotificationUtils.jPushInit();
    }
  }

  goPage(Widget page) async {
    await Future.delayed(const Duration(microseconds: 150), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => page), (_) => false);
      }
    });
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
