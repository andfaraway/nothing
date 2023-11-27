import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/device_info_model.g.dart';

@JsonSerializable()
class DeviceInfoModel {
  DeviceInfoDeviceInfo device = DeviceInfoDeviceInfo();
  DeviceInfoRuntimeInfo runtime = DeviceInfoRuntimeInfo();
  DeviceInfoPackageInfo package = DeviceInfoPackageInfo();

  DeviceInfoModel();

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) => $DeviceInfoModelFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoDeviceInfo {
  DeviceInfoDeviceInfoInfo info = DeviceInfoDeviceInfoInfo();
  DeviceInfoDeviceInfoIosInfo? iosInfo;
  DeviceInfoDeviceInfoAndroidInfo? androidInfo;

  DeviceInfoDeviceInfo();

  factory DeviceInfoDeviceInfo.fromJson(Map<String, dynamic> json) => $DeviceInfoDeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoDeviceInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoDeviceInfoIosInfo {
  String? systemName = '';
  String? isPhysicalDevice = '';
  Utsname? utsname;
  String? model = '';
  String? localizedModel = '';
  String? systemVersion = '';
  String? name = '';
  String? identifierForVendor = '';

  DeviceInfoDeviceInfoIosInfo();

  factory DeviceInfoDeviceInfoIosInfo.fromJson(Map<String, dynamic> json) => $DeviceInfoDeviceInfoIosInfoFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoDeviceInfoIosInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoDeviceInfoInfo {
  String uuid = '';
  bool isPhysicalDevice = true;
  String deviceInfo = '';

  DeviceInfoDeviceInfoInfo();

  factory DeviceInfoDeviceInfoInfo.fromJson(Map<String, dynamic> json) => $DeviceInfoDeviceInfoInfoFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoDeviceInfoInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class Utsname {
  String? release = '';
  String? sysname = '';
  String? nodename = '';
  String? machine = '';
  String? version = '';

  Utsname();

  factory Utsname.fromJson(Map<String, dynamic> json) => $UtsnameFromJson(json);

  Map<String, dynamic> toJson() => $UtsnameToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoDeviceInfoAndroidInfo {
  String? product = '';
  List<String>? supportedAbis = [];
  String? serialNumber = '';
  DeviceInfoDeviceInfoAndroidInfoDisplayMetrics? displayMetrics;
  List<dynamic>? supported32BitAbis = [];
  String? display = '';
  String? type = '';
  bool? isPhysicalDevice = false;
  DeviceInfoDeviceInfoAndroidInfoVersion? version;
  List<String>? supported64BitAbis = [];
  String? bootloader = '';
  String? fingerprint = '';
  String? host = '';
  String? model = '';
  String? id = '';
  String? brand = '';
  String? device = '';
  String? board = '';
  String? hardware = '';

  DeviceInfoDeviceInfoAndroidInfo();

  factory DeviceInfoDeviceInfoAndroidInfo.fromJson(Map<String, dynamic> json) =>
      $DeviceInfoDeviceInfoAndroidInfoFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoDeviceInfoAndroidInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoDeviceInfoAndroidInfoDisplayMetrics {
  int? xDpi = 0;
  int? widthPx = 0;
  int? heightPx = 0;
  int? yDpi = 0;

  DeviceInfoDeviceInfoAndroidInfoDisplayMetrics();

  factory DeviceInfoDeviceInfoAndroidInfoDisplayMetrics.fromJson(Map<String, dynamic> json) =>
      $DeviceInfoDeviceInfoAndroidInfoDisplayMetricsFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoDeviceInfoAndroidInfoDisplayMetricsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoDeviceInfoAndroidInfoVersion {
  String? baseOS = '';
  String? securityPatch = '';
  int? sdkInt = 0;
  String? release = '';
  String? codename = '';
  int? previewSdkInt = 0;
  String? incremental = '';

  DeviceInfoDeviceInfoAndroidInfoVersion();

  factory DeviceInfoDeviceInfoAndroidInfoVersion.fromJson(Map<String, dynamic> json) =>
      $DeviceInfoDeviceInfoAndroidInfoVersionFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoDeviceInfoAndroidInfoVersionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoRuntimeInfo {
  String? network;
  String battery = '';
  String deviceToken = '';
  String? date;

  DeviceInfoRuntimeInfo();

  factory DeviceInfoRuntimeInfo.fromJson(Map<String, dynamic> json) => $DeviceInfoRuntimeInfoFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoRuntimeInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class DeviceInfoPackageInfo {
  String? appName = '';
  String? packageName = '';
  String? version = '';
  String? buildNumber = '';

  DeviceInfoPackageInfo();

  factory DeviceInfoPackageInfo.fromJson(Map<String, dynamic> json) => $DeviceInfoPackageInfoFromJson(json);

  Map<String, dynamic> toJson() => $DeviceInfoPackageInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
