import 'package:info_utils_plugin/info_utils_plugin.dart';

class DeviceUtils {
  const DeviceUtils._();

  static late DeviceInfoModel deviceInfoModel;

  static Future<void> init() async {
    deviceInfoModel = await InfoUtilsPlugin().getDeviceInfo();
  }
}
