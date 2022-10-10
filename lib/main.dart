import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nothing/main_test.dart';
import 'package:nothing/utils/notification_utils.dart';
import 'public.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  mainTest();

  await PathUtils.init();
  await HiveBoxes.init();

  //初始化推送信息
  if (await Constants.isPhysicalDevice() && !kIsWeb) {
    await NotificationUtils.jPushInit();
  }
  await DeviceUtils.getDeviceUuid();

  Singleton.welcomeLoadResult =
      await platformChannel.invokeMapMethod(ChannelKey.welcomeLoad);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
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

    Constants.isDark = context.theme.brightness == Brightness.dark;
    Constants.context = context;

    Future.delayed(const Duration(seconds: 1), () async{
      await Constants.insertLaunch();
    });

    Future.delayed(const Duration(seconds: 8), () async{
      //检查更新
      await Constants.checkUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => WaterDropHeader(
        complete: const Icon(
          Icons.done,
          color: Colors.grey,
        ),
        waterDropColor: Theme.of(context).backgroundColor,
      ),
      footerBuilder: () => const ClassicFooter(),
      child: Consumer<ThemesProvider>(builder: (context, provider, child) {
        MaterialColor primarySwatch = MaterialColor(
          provider.currentThemeGroup.themeColor.value,
          <int, Color>{
            50: const Color(0xFFE3F2FD),
            100: const Color(0xFFBBDEFB),
            200: const Color(0xFF90CAF9),
            300: const Color(0xFF64B5F6),
            400: const Color(0xFF42A5F5),
            500: Color(provider.currentThemeGroup.themeColor.value),
            600: const Color(0xFF1E88E5),
            700: const Color(0xFF1976D2),
            800: const Color(0xFF1565C0),
            900: const Color(0xFF0D47A1),
          },
        );
        return MaterialApp(
          navigatorKey: Instances.navigatorKey,
          theme: ThemeData(
            primarySwatch: primarySwatch,
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          routes: AppRoutes.routes,
          initialRoute: welcomeRoute.routeName,
          // home: const HomePage(),
          builder: EasyLoading.init(),
        );
      }),
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
