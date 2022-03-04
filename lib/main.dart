import 'package:flutter/services.dart';
import 'package:nothing/constants/constants.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/utils/notification_utils.dart';
import 'package:nothing/welcome_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  runApp(MultiProvider(providers: providers, child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance?.addObserver(this);

    platformChannel.setMethodCallHandler((MethodCall call) async {
      if(call.method == 'deviceToken'){
        String deviceToken = call.arguments.toString();
        UserAPI.pushDeviceToken(Singleton.currentUser.userId, deviceToken);
        print('deviceToken：${call.arguments.toString()}');
      }
    });

    Constants.isDark = context.theme.brightness == Brightness.dark;

    Future.delayed(Duration(seconds: 3),(){
      Constants.checkUpdate();
      Constants.insertLaunchInfo();
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
          // home: const HomePage(),
          home: WelcomePage(),
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
      case AppLifecycleState.resumed:// 应用程序可见，前台
        NotificationUtils.jpush.setBadge(0);
        // Constants.insertLaunchInfo();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
    }
  }


}


