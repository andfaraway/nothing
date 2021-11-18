import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nothing/constants/constants.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/utils/notification_utils.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  if(Platform.version.contains('ios_x86')){
     NotificationUtils.jPushInit();
  }
  runApp(MultiProvider(providers: [
    buildProvider<SettingsProvider>(SettingsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      child: MaterialApp(
        navigatorKey: Instances.navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}



