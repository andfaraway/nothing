import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:nothing/common/prefix_header.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Constants.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Constants.isDark = Theme.of(context).brightness == Brightness.dark;

      Future.delayed(const Duration(seconds: 3), () async {
        await API.insertLaunch();

        AppResponse response = await API.checkUpdate(needLoading: false);
        if (response.isSuccess) {
          API.refreshToken();
          Map<String, dynamic> data = response.dataMap;
          if (data['update'] == true) {
            int force = data['force'];
            if (currentContext.mounted) {
              showIOSAlert(
                context: currentContext,
                title: S.current.version_update,
                content: data['content'],
                cancelOnPressed: force == 1
                    ? null
                    : () {
                        Navigator.pop(currentContext);
                      },
                confirmOnPressed: () async {
                  String url = data['path'];
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              );
            }
          }
        }
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
              child: KeyboardHideOnTap(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  theme: themesProvider.currentThemeData,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  initialRoute: AppRoute.initialRoute,
                  onGenerateRoute: onGenerateRoute,
                  scrollBehavior: const CupertinoScrollBehavior(),
                  navigatorObservers: [FlutterSmartDialog.observer, AppNavigatorObserver()],
                  builder: EasyLoading.init(builder: FlutterSmartDialog.init()),
                ),
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
        NotificationUtils.jPush?.setBadge(0);
        // Constants.insertLaunch();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
    }
  }
}
