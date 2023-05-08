import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:nothing/utils/notification_utils.dart';

import 'common/prefix_header.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PathUtils.init();
  await HiveBoxes.init();

  //初始化推送信息
  if (await Constants.isPhysicalDevice() && !kIsWeb) {
    await NotificationUtils.jPushInit();
  }
  await DeviceUtils.getDeviceUuid();

  Singleton.welcomeLoadResult = await platformChannel.invokeMapMethod(ChannelKey.welcomeLoad);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(AppOverlayStyle.dark);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    platformChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'deviceToken') {
        String deviceToken = call.arguments.toString();
        API.pushDeviceToken(Singleton().currentUser.userId, deviceToken);
        print('deviceToken：${call.arguments.toString()}');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Constants.context = context;
      Constants.isDark = context.theme.brightness == Brightness.dark;

      Future.delayed(const Duration(seconds: 1), () async {
        await Constants.insertLaunch();
      });

      Future.delayed(const Duration(seconds: 8), () async {
        //检查更新
        await Constants.checkUpdate(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenUtilInit(
      builder: (context, child) => MultiProvider(
        providers: providers,
        builder: (context, child) => Consumer<ThemesProvider>(builder: (context, themesProvider, child) {
          return AppRefreshConfiguration(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(themesProvider.filterColor, BlendMode.color),
              child: MaterialApp(
                navigatorKey: Instances.navigatorKey,
                theme: themesProvider.currentThemeData,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                initialRoute: Routes.root.name,
                onGenerateRoute: onGenerateRoute,
                scrollBehavior: const CupertinoScrollBehavior(),
                navigatorObservers: [FlutterSmartDialog.observer, AppNavigatorObserver()],
                builder: EasyLoading.init(builder: FlutterSmartDialog.init()),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        NotificationUtils.jpush.setBadge(0);
        // Constants.insertLaunch();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
