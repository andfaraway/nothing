//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 10:49:11
//

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/utils/notification_utils.dart';
import 'package:nothing/utils/photo_save.dart';
import 'package:nothing/widgets/launch_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/constants.dart';

const int secondCount = 5;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, String? localPath}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Map<dynamic, dynamic>? result;

  ValueNotifier<int> timeCount = ValueNotifier(secondCount);

  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      timeCount.value--;
      if (timeCount.value == 0) {
        if (mounted) {
          jumpPage();
        }
        timer.cancel();
      }
    });
  }

  // 跳转页面
  Future<void> jumpPage() async {
    //判断是否登录
    if (Singleton.currentUser.userId != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (_) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (_) => false);
    }

    if (result != null) {
      if (globalContext?.widget.toString() != 'MessagePage') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MessagePage()));
      }
    }
  }

  Future<void> initData() async {
    //读取本地信息
    await Singleton.loadData();
    //初始化推送信息
    if (await Constants.isPhysicalDevice() || !kIsWeb) {
      NotificationUtils.jPushInit();
    }

    // 页面加载完毕
    result = await platformChannel.invokeMapMethod(ChannelKey.welcomeLoad);

    LaunchProvider provider = context.read<LaunchProvider>();

    Map<String, dynamic>? map;

    map = await UserAPI.getLaunchInfo();
    print('map = $map');

    if (map != null && provider.launchInfo?.image != map['image']) {
      provider.launchInfo = LaunchInfo.fromJson(map);
      String saveName = map['image'].toString().split('/').last;
      String? localPath = await saveToDocument(
          url: provider.launchInfo?.image ?? '', saveName: saveName);
      provider.launchInfo?.localPath = localPath;
      provider.updateHives();
      provider.update();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Screens.init(context);
    return Scaffold(
      body: Consumer<LaunchProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              provider.launchInfo == null
                  ? Center(
                      child: Text(
                        'Hi',
                        style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.lerp(
                                FontWeight.normal, FontWeight.bold, .1)),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onLongPress: () {
                          // saveLocalPhoto(
                          //   saveName: 'launchImage.jpg',
                          //   localPath: ,
                          // );
                        },
                        child: LaunchWidget(
                          title: provider.launchInfo?.title,
                          url: provider.launchInfo?.image,
                          localPath: provider.launchInfo?.localPath,
                          dayStr: provider.launchInfo?.dayStr,
                          monthStr: provider.launchInfo?.monthStr,
                          dateDetailStr: provider.launchInfo?.dateDetailStr,
                          contentStr: provider.launchInfo?.contentStr,
                          author: provider.launchInfo?.authorStr,
                          codeStr: provider.launchInfo?.contentStr,
                        ),
                      ),
                    ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox.shrink()),
                      TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ValueListenableBuilder(
                              builder: (context, value, child) {
                                return Text(
                                  '$value ',
                                );
                              },
                              valueListenable: timeCount,
                            ),
                            const Text('跳过'),
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black26),
                          minimumSize: MaterialStateProperty.all(Size.zero),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          jumpPage();
                        },
                      ),
                    ],
                  ),
                ),
                alignment: Alignment.bottomRight,
              )
            ],
          );
        },
      ),
    );
  }
}
