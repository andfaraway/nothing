//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 10:49:11
//

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/utils/notification_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/constants.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  ValueNotifier<String?> launchUrl = ValueNotifier(null);

  Map<dynamic, dynamic>? result;

  ValueNotifier<int> timeCount = ValueNotifier(5);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();

    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      timeCount.value--;
      if (timeCount.value == 0) {
        if(mounted){
          jumpPage();
        }
        timer.cancel();
      }
    });
  }

  //
  Future<void> jumpPage() async {
    //判断是否登录
    if (Singleton.currentUser.userId != null) {
      goPage(const HomePage());
    } else {
      goPage(const LoginPage());
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

    String? localPath = await LocalDataUtils.get('localPath');
    if (localPath != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();

      launchUrl.value = appDocDir.path + localPath;
    }

    // 页面加载完毕
    result = await platformChannel.invokeMapMethod(ChannelKey.welcomeLoad);

    Future.delayed(const Duration(seconds: 2), () async {
      List<dynamic>? s = await UserAPI.getDesktopImage();
      String url = s?.first['url'];
      String name = 'launchImage${s?.first['format']}';
      //本地路径
      Directory appDocDir = await getApplicationDocumentsDirectory();
      localPath = appDocDir.path + '/' + name;
      NetUtils.download(urlPath: url, savePath: localPath!);
      print('appDocPath = $localPath');
      LocalDataUtils.setString('localPath', '/$name');
    });
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

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: launchUrl,
          builder: (context, String? value, child) {
            return value == null
                ? const Center(child: Text('nothing'))
                : Stack(
                    children: [
                      Image.asset(
                        value,
                        width: double.infinity,
                        height: double.infinity,
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
                                  minimumSize:
                                      MaterialStateProperty.all(Size.zero),
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
          }),
    );
  }
}
