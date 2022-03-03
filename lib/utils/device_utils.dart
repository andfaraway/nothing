import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:nothing/constants/constants.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';

class DeviceUtils {
  const DeviceUtils._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static dynamic deviceInfo;

  static String deviceModel = 'OpenJMU Device';
  static String? devicePushToken;
  static String? deviceUuid;

  static Future<void> initDeviceInfo() async {
    await getModel();
    // await getDevicePushToken();
    await getDeviceUuid();
  }

  static Future<void> getModel() async {
    if (Platform.isAndroid) {
      deviceInfo = await _deviceInfoPlugin.androidInfo;
      final AndroidDeviceInfo androidInfo = deviceInfo as AndroidDeviceInfo;

      final String model = '${androidInfo.brand} ${androidInfo.product}';
      deviceModel = model;
    } else if (Platform.isIOS) {
      deviceInfo = await _deviceInfoPlugin.iosInfo;
      final IosDeviceInfo iosInfo = deviceInfo as IosDeviceInfo;

      final String model =
          '${iosInfo.model} ${iosInfo.utsname.machine} ${iosInfo.systemVersion}';
      deviceModel = model;
    }

    LogUtils.d('deviceModel: $deviceModel');
  }

  // static Future<void> getDevicePushToken() async {
  //   if (Platform.isIOS) {
  //     final String _savedToken = HiveFieldUtils.getDevicePushToken();
  //     final String _tempToken = await ChannelUtils.iOSGetPushToken();
  //     if (_savedToken != null) {
  //       if (_savedToken != _tempToken) {
  //         await HiveFieldUtils.setDevicePushToken(_tempToken);
  //       } else {
  //         devicePushToken = HiveFieldUtils.getDevicePushToken();
  //       }
  //     } else {
  //       await HiveFieldUtils.setDevicePushToken(_tempToken);
  //     }
  //     LogUtils.d('devicePushToken: $devicePushToken');
  //   }
  // }

  static Future<void> getDeviceUuid() async {
    if (HiveFieldUtils.getDeviceUuid() != null) {
      deviceUuid = HiveFieldUtils.getDeviceUuid();
    } else {
      if (Platform.isIOS) {
        deviceUuid = (deviceInfo as IosDeviceInfo).identifierForVendor!;
      } else {
        deviceUuid = const Uuid().v4();
        // await HiveFieldUtils.setDeviceUuid(const Uuid().v4());
      }
    }
    LogUtils.d('deviceUuid: $deviceUuid');
  }

  /// Set default display mode to compatible with the highest refresh rate on
  /// supported devices.
  /// 在支持的手机上尝试以最高的刷新率显示
  static void setHighestRefreshRate() {
    if (Platform.isAndroid &&
        (deviceInfo as AndroidDeviceInfo).version.sdkInt! >= 23) {
      FlutterDisplayMode.setHighRefreshRate();
    }
  }

  static Future<String> battery() async{
    int battery = await platformChannel.invokeMethod(ChannelKey.getBatteryLevel);
    if(battery == -1){
      return "unknown";
    }else{
      return battery.toString() + "%";
    }
  }

  static Future<String> network() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // 网络类型为移动网络
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // 网络类型为WIFI
    }
    return connectivityResult.toString().split('.').last;
  }

  static Future<String> version() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  static Future<String> getDeviceInfo() async{
    if (Platform.isAndroid) {
      deviceInfo = await _deviceInfoPlugin.androidInfo;
      final AndroidDeviceInfo androidInfo = deviceInfo as AndroidDeviceInfo;

      final String model = '${androidInfo.brand} ${androidInfo.product}';
      deviceModel = model;
    } else if (Platform.isIOS) {
      deviceInfo = await _deviceInfoPlugin.iosInfo;
      final IosDeviceInfo iosInfo = deviceInfo as IosDeviceInfo;

      final String model =
          '${iosInfo.name}(${getCurrentIphoneName(iosInfo.utsname.machine ?? '')},${iosInfo.systemVersion})';
      deviceModel = model;
    }
    return deviceModel;
  }
}

String getCurrentIphoneName(String machine) {
  if (machine.contains("iPhone3,1"))    return "iPhone 4";
  if (machine.contains("iPhone3,2"))    return "iPhone 4";
  if (machine.contains("iPhone3,3"))    return "iPhone 4";
  if (machine.contains("iPhone4,1"))    return "iPhone 4S";
  if (machine.contains("iPhone5,1"))    return "iPhone 5";
  if (machine.contains("iPhone5,2"))    return "iPhone 5 (GSM+CDMA)";
  if (machine.contains("iPhone5,3"))    return "iPhone 5c (GSM)";
  if (machine.contains("iPhone5,4"))    return "iPhone 5c (GSM+CDMA)";
  if (machine.contains("iPhone6,1"))    return "iPhone 5s (GSM)";
  if (machine.contains("iPhone6,2"))    return "iPhone 5s (GSM+CDMA)";
  if (machine.contains("iPhone7,1"))    return "iPhone 6 Plus";
  if (machine.contains("iPhone7,2"))    return "iPhone 6";
  if (machine.contains("iPhone8,1"))    return "iPhone 6s";
  if (machine.contains("iPhone8,2"))    return "iPhone 6s Plus";
  if (machine.contains("iPhone8,4"))    return "iPhone SE";
// 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
  if (machine.contains("iPhone9,1"))    return "iPhone 7";
  if (machine.contains("iPhone9,2"))    return "iPhone 7 Plus";
  if (machine.contains("iPhone9,3"))    return "iPhone 7";
  if (machine.contains("iPhone9,4"))    return "iPhone 7 Plus";
  if (machine.contains("iPhone10,1"))   return "iPhone_8";
  if (machine.contains("iPhone10,4"))   return "iPhone_8";
  if (machine.contains("iPhone10,2"))   return "iPhone_8_Plus";
  if (machine.contains("iPhone10,5"))   return "iPhone_8_Plus";
  if (machine.contains("iPhone10,3"))   return "iPhone X";
  if (machine.contains("iPhone10,6"))   return "iPhone X";
  if (machine.contains("iPhone11,8"))   return "iPhone XR";
  if (machine.contains("iPhone11,2"))   return "iPhone XS";
  if (machine.contains("iPhone11,6"))   return "iPhone XS Max";
  if (machine.contains("iPhone11,4"))   return "iPhone XS Max";
  if (machine.contains("iPhone12,1"))   return "iPhone 11";
  if (machine.contains("iPhone12,3"))   return "iPhone 11 Pro";
  if (machine.contains("iPhone12,5"))   return "iPhone 11 Pro Max";
  if (machine.contains("iPhone12,8"))   return "iPhone SE2";
  if (machine.contains("iPhone13,1"))   return "iPhone 12 mini";
  if (machine.contains("iPhone13,2"))   return "iPhone 12";
  if (machine.contains("iPhone13,3"))   return "iPhone 12 Pro";
  if (machine.contains("iPhone13,4"))   return "iPhone 12 Pro Max";
  if (machine.contains("iPhone14,4"))   return "iPhone 13 mini";
  if (machine.contains("iPhone14,5"))   return "iPhone 13";
  if (machine.contains("iPhone14,2"))   return "iPhone 13 Pro";
  if (machine.contains("iPhone14,3"))   return "iPhone 13 Pro Max";
  if (machine.contains("iPod1,1"))      return "iPod Touch 1G";
  if (machine.contains("iPod2,1"))      return "iPod Touch 2G";
  if (machine.contains("iPod3,1"))      return "iPod Touch 3G";
  if (machine.contains("iPod4,1"))      return "iPod Touch 4G";
  if (machine.contains("iPod5,1"))      return "iPod Touch (5 Gen)";
  if (machine.contains("iPad1,1"))      return "iPad";
  if (machine.contains("iPad1,2"))      return "iPad 3G";
  if (machine.contains("iPad2,1"))      return "iPad 2 (WiFi)";
  if (machine.contains("iPad2,2"))      return "iPad 2";
  if (machine.contains("iPad2,3"))      return "iPad 2 (CDMA)";
  if (machine.contains("iPad2,4"))      return "iPad 2";
  if (machine.contains("iPad2,5"))      return "iPad Mini (WiFi)";
  if (machine.contains("iPad2,6"))      return "iPad Mini";
  if (machine.contains("iPad2,7"))      return "iPad Mini (GSM+CDMA)";
  if (machine.contains("iPad3,1"))      return "iPad 3 (WiFi)";
  if (machine.contains("iPad3,2"))      return "iPad 3 (GSM+CDMA)";
  if (machine.contains("iPad3,3"))      return "iPad 3";
  if (machine.contains("iPad3,4"))      return "iPad 4 (WiFi)";
  if (machine.contains("iPad3,5"))      return "iPad 4";
  if (machine.contains("iPad3,6"))      return "iPad 4 (GSM+CDMA)";
  if (machine.contains("iPad4,1"))      return "iPad Air (WiFi)";
  if (machine.contains("iPad4,2"))      return "iPad Air (Cellular)";
  if (machine.contains("iPad4,4"))      return "iPad Mini 2 (WiFi)";
  if (machine.contains("iPad4,5"))      return "iPad Mini 2 (Cellular)";
  if (machine.contains("iPad4,6"))      return "iPad Mini 2";
  if (machine.contains("iPad4,7"))      return "iPad Mini 3";
  if (machine.contains("iPad4,8"))      return "iPad Mini 3";
  if (machine.contains("iPad4,9"))      return "iPad Mini 3";
  if (machine.contains("iPad5,1"))      return "iPad Mini 4 (WiFi)";
  if (machine.contains("iPad5,2"))      return "iPad Mini 4 (LTE)";
  if (machine.contains("iPad5,3"))      return "iPad Air 2";
  if (machine.contains("iPad5,4"))      return "iPad Air 2";
  if (machine.contains("iPad6,3"))      return "iPad Pro 9.7";
  if (machine.contains("iPad6,4"))      return "iPad Pro 9.7";
  if (machine.contains("iPad6,7"))      return "iPad Pro 12.9";
  if (machine.contains("iPad6,8"))      return "iPad Pro 12.9";

  if (machine.contains("AppleTV2,1"))      return "Apple TV 2";
  if (machine.contains("AppleTV3,1"))      return "Apple TV 3";
  if (machine.contains("AppleTV3,2"))      return "Apple TV 3";
  if (machine.contains("AppleTV5,3"))      return "Apple TV 4";

  if (machine.contains("i386"))         return "Simulator";
  if (machine.contains("x86_64"))       return "Simulator";
  return "unknown";
}
