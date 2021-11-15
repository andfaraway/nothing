import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nothing/home_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'constants/instances.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  runApp(const MyApp());
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
