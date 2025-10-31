import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:nothing/common/prefix_header.dart';
import 'page/my_app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Constants.init();

  isDebug = true;
  runApp(const MyApp());
}
