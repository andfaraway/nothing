//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 10:49:11
//

import 'dart:async';

import 'package:nothing/constants/constants.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/utils/photo_save.dart';
import 'package:nothing/widgets/launch_widget.dart';
import 'public.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, String? localPath}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  ValueNotifier<int> timeCount = ValueNotifier(0);

  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();

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

    if (Singleton.welcomeLoadResult != null) {
      if (globalContext?.widget.toString() != 'MessagePage') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MessagePage()));
      }
    }
  }

  Future<void> initData() async {
    LaunchProvider provider = context.read<LaunchProvider>();
    Map<String, dynamic>? map = await API.getLaunchInfo();
    LogUtils.i("map:" + map.toString());
    if (map != null) {
      String? image = provider.launchInfo?.image;
      String? imageBackground = provider.launchInfo?.backgroundImage;
      String? localPath = provider.launchInfo?.localPath;
      String? localBackgroundPath = provider.launchInfo?.localBackgroundPath;
      provider.launchInfo = LaunchInfo.fromJson(map);

      provider.launchInfo?.localPath = localPath;
      provider.launchInfo?.localBackgroundPath = localBackgroundPath;
      if (map['image'] != image || localPath == null) {
        String saveName = 'launchImage.jpg';
        String? path = await saveToDocument(
            url: provider.launchInfo?.image ?? '', saveName: saveName);
        provider.launchInfo?.localPath = path;
      }

      if (map['backgroundImage'] == map['image']) {
        provider.launchInfo?.localBackgroundPath =
            provider.launchInfo?.localPath;
      } else {
        if (map['backgroundImage'] != imageBackground ||
            localBackgroundPath == null) {
          String saveName = 'launchImageBg.jpg';
          String? path = await saveToDocument(
              url: provider.launchInfo?.backgroundImage ?? '',
              saveName: saveName);
          provider.launchInfo?.localBackgroundPath = path;
        }
      }
      provider.updateHives();
      // provider.update();
    }

    timeCount.value = provider.launchInfo?.timeCount ?? timeCount.value;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timeCount.value <= 1) {
        if (mounted) {
          jumpPage();
        }
        timer.cancel();
      }else{
        timeCount.value--;
      }
    });

    LogUtils.i('document:${PathUtils.documentPath}');
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Screens.init(context);
    return Scaffold(
      body: Stack(
        children: [
          Consumer<LaunchProvider>(
            builder: (context, provider, child) {
              LogUtils.i("provider.launchInfo?.launchType:${provider.launchInfo?.launchType}");
              return provider.launchInfo == null
                  ? Center(
                      child: Text(
                        'Hi',
                        style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.lerp(
                                FontWeight.normal, FontWeight.bold, .1)),
                      ),
                    )
                  : provider.launchInfo?.launchType == 0
                      ? Container(
                color: Colors.black,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPress: () {
                    saveLocalPhoto(
                      saveName: 'launchImage.jpg',
                      localPath:
                      '${PathUtils.documentPath}/${provider.launchInfo?.localPath}',
                    );
                  },
                  child: LaunchWidget(
                    title: provider.launchInfo?.title,
                    image: provider.launchInfo?.image,
                    localPath: provider.launchInfo?.localPath,
                    backgroundImage:
                    provider.launchInfo?.backgroundImage,
                    localBackgroundPath:
                    provider.launchInfo?.localBackgroundPath,
                    dayStr: provider.launchInfo?.dayStr,
                    monthStr: provider.launchInfo?.monthStr,
                    dateDetailStr: provider.launchInfo?.dateDetailStr,
                    contentStr: provider.launchInfo?.contentStr,
                    author: provider.launchInfo?.authorStr,
                    codeStr: provider.launchInfo?.codeStr,
                  ),
                ),
              )
                      : Container(
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Image.network(provider.launchInfo?.image ?? '',fit:
              BoxFit.fitWidth),
                      );
            },
          ),
          ValueListenableBuilder(
            builder: (context, value, child) {
              if(value == 0) return const SizedBox.shrink();
              return Align(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox.shrink()),
                      TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Text(
                              '$value ',
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
              );
            },
            valueListenable: timeCount,
          ),
        ],
      ),
    );
  }
}
