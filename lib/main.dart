import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nothing/constants/constants.dart';
import 'package:nothing/home_page.dart';
import 'package:nothing/utils/notification_utils.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  //读取本地信息
  // LocalDataUtils.cleanData();
  await Singleton.loadData();

  runApp(MultiProvider(providers: providers, child: const MyApp()));

  if(kIsWeb) return;
  if(Platform.version.contains('ios_x86')){
     NotificationUtils.jPushInit();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Constants.isDark = context.theme.brightness == Brightness.dark;
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



