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
import 'package:path_provider/path_provider.dart';
import 'constants/constants.dart';

const int secondCount = 3;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  ValueNotifier<String?> launchUrl = ValueNotifier(null);

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

    // 页面加载完毕
    result = await platformChannel.invokeMapMethod(ChannelKey.welcomeLoad);

    // 获取启动图片
    List<dynamic>? s = await UserAPI.getDesktopImage();
    String url = s?.first['url'];
    String name = 'launchImage${s?.first['format']}';

    // 本地图片路径
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = appDocDir.path + '/' + name;

    // 查询本地是否已经下载图片
    String? localUrl = await LocalDataUtils.get('launchImgDate');
    if (url != localUrl) {
      // 未下载，保存图片到本地
      Response s = await NetUtils.download(urlPath: url, savePath: localPath);

      // 下载完成，记录状态
      if (s.statusCode == 200) {
        LogUtils.i('launchImage:$url');
        await LocalDataUtils.setString('launchImgDate', url);

        launchUrl.value = localPath;
      }
    } else {
      launchUrl.value = localPath;
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
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Screens.init(context);

    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: launchUrl,
          builder: (context, String? value, child) {
            return Stack(
              children: [
                if (value != null)
                  (value != ''
                      ? GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onLongPress: () {
                            saveLocalPhoto(
                              saveName: 'launchImage.jpg',
                              localPath: value,
                            );
                          },
                          child: Image.asset(
                            value,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Center(
                          child: Text(
                            'Hi',
                            style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.lerp(
                                    FontWeight.normal, FontWeight.bold, .1)),
                          ),
                        )),
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
          }),
    );
  }
}
