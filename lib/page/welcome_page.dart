//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-07 10:49:11
//

import 'dart:async';

import 'package:nothing/utils/photo_save.dart';
import 'package:nothing/widgets/dialogs/privacy_dialog.dart';
import 'package:nothing/widgets/launch_widget.dart';

import '../common/prefix_header.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, String? localPath}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  ValueNotifier<int> timeCount = ValueNotifier(0);

  late Timer timer;

  @override
  void initState() {
    super.initState();

    bool agreement = HiveBoxes.get(HiveKey.agreement, defaultValue: false, isSetting: true);

    if (agreement) {
      initData();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog<bool>(
            context: context,
            useSafeArea: false,
            barrierColor: Colors.black38,
            barrierDismissible: true,
            builder: (_) => PrivacyDiaLog(
                  userAgreementUrl: '${Config.netServer}/userAgreement.html',
                  privacyPolicyUrl: '${Config.netServer}/privacyPolicy.html',
                  continueCallback: () async {
                    await HiveBoxes.put(HiveKey.agreement, true, isSetting: true);
                    initData();
                  },
                ));
      });
    }
  }

  // 跳转页面
  Future<void> jumpPage() async {
    //判断是否登录
    if (Constants.isLogin) {
      AppRoute.pushNamedAndRemoveUntil(context, AppRoute.root.name);
    } else {
      AppRoute.pushNamedAndRemoveUntil(context, AppRoute.login.name);
    }

    if (Singleton.welcomeLoadResult != null) {
      if (currentContext.widget.toString() != 'MessagePage') {
        context.read<HomeProvider>().pageIndex = 1;
        AppRoute.pushNamedAndRemoveUntil(context, AppRoute.root.name);
      }
    }
  }

  Future<void> initData() async {
    LaunchProvider provider = context.read<LaunchProvider>();
    AppResponse response = await API.getLaunchInfo();
    if (response.isSuccess) {
      provider.launchInfo = LaunchInfo.fromJson(response.dataMap);
    }

    timeCount.value = provider.launchInfo?.timeCount ?? timeCount.value;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timeCount.value <= 1) {
        if (mounted) {
          jumpPage();
        }
        timer.cancel();
      } else {
        timeCount.value--;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<LaunchProvider>(
            builder: (context, provider, child) {
              return provider.launchInfo == null
                  ? Center(
                      child: Text(
                        'Hi',
                        style: TextStyle(
                            fontSize: 80, fontWeight: FontWeight.lerp(FontWeight.normal, FontWeight.bold, .1)),
                      ),
                    )
                  : provider.launchInfo?.launchType == 0
                      ? Container(
                          color: Colors.black,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onLongPress: () {
                              saveNetworkImg(imgUrl: provider.launchInfo!.image!);
                            },
                            child: LaunchWidget(
                              title: provider.launchInfo?.title,
                              image: provider.launchInfo?.image ?? '',
                              backgroundImage: provider.launchInfo?.backgroundImage,
                              dayStr: provider.launchInfo?.dayStr,
                              monthStr: provider.launchInfo?.monthStr,
                              dateDetailStr: provider.launchInfo?.dateDetailStr,
                              contentStr: provider.launchInfo?.contentStr,
                              author: provider.launchInfo?.authorStr,
                              codeStr: provider.launchInfo?.codeStr,
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: provider.launchInfo!.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorWidget: (context, string, child) {
                            return Image.asset(
                              R.imagesHandsomeman,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                        );
            },
          ),
          ValueListenableBuilder(
            builder: (context, value, child) {
              if (value == 0) return const SizedBox.shrink();
              return Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox.shrink()),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black26),
                          minimumSize: MaterialStateProperty.all(Size.zero),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          jumpPage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$value ',
                            ),
                            const Text('跳过'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            valueListenable: timeCount,
          ),
        ],
      ),
    );
  }
}
