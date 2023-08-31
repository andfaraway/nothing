import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/device_info_model.dart';

DeviceInfoModel $DeviceInfoModelFromJson(Map<String, dynamic> json) {
  final DeviceInfoModel deviceInfoModel = DeviceInfoModel();
  final DeviceInfoDeviceInfo? device = jsonConvert.convert<DeviceInfoDeviceInfo>(json['device']);
  if (device != null) {
    deviceInfoModel.device = device;
  }
  final DeviceInfoRuntimeInfo? runtime = jsonConvert.convert<DeviceInfoRuntimeInfo>(json['runtime']);
  if (runtime != null) {
    deviceInfoModel.runtime = runtime;
  }
  final DeviceInfoPackageInfo? package = jsonConvert.convert<DeviceInfoPackageInfo>(json['package']);
  if (package != null) {
    deviceInfoModel.package = package;
  }
  return deviceInfoModel;
}

Map<String, dynamic> $DeviceInfoModelToJson(DeviceInfoModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['device'] = entity.device.toJson();
  data['runtime'] = entity.runtime.toJson();
  data['package'] = entity.package.toJson();
  return data;
}

extension DeviceInfoModelExtension on DeviceInfoModel {
  DeviceInfoModel copyWith({
    DeviceInfoDeviceInfo? device,
    DeviceInfoRuntimeInfo? runtime,
    DeviceInfoPackageInfo? package,
  }) {
    return DeviceInfoModel()
      ..device = device ?? this.device
      ..runtime = runtime ?? this.runtime
      ..package = package ?? this.package;
  }
}

DeviceInfoDeviceInfo $DeviceInfoDeviceInfoFromJson(Map<String, dynamic> json) {
  final DeviceInfoDeviceInfo deviceInfoDeviceInfo = DeviceInfoDeviceInfo();
  final DeviceInfoDeviceInfoInfo? info = jsonConvert.convert<DeviceInfoDeviceInfoInfo>(json['info']);
  if (info != null) {
    deviceInfoDeviceInfo.info = info;
  }
  final DeviceInfoDeviceInfoIosInfo? iosInfo = jsonConvert.convert<DeviceInfoDeviceInfoIosInfo>(json['iosInfo']);
  if (iosInfo != null) {
    deviceInfoDeviceInfo.iosInfo = iosInfo;
  }
  final DeviceInfoDeviceInfoAndroidInfo? androidInfo =
      jsonConvert.convert<DeviceInfoDeviceInfoAndroidInfo>(json['androidInfo']);
  if (androidInfo != null) {
    deviceInfoDeviceInfo.androidInfo = androidInfo;
  }
  return deviceInfoDeviceInfo;
}

Map<String, dynamic> $DeviceInfoDeviceInfoToJson(DeviceInfoDeviceInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['info'] = entity.info.toJson();
  data['iosInfo'] = entity.iosInfo?.toJson();
  data['androidInfo'] = entity.androidInfo?.toJson();
  return data;
}

extension DeviceInfoDeviceInfoExtension on DeviceInfoDeviceInfo {
  DeviceInfoDeviceInfo copyWith({
    DeviceInfoDeviceInfoInfo? info,
    DeviceInfoDeviceInfoIosInfo? iosInfo,
    DeviceInfoDeviceInfoAndroidInfo? androidInfo,
  }) {
    return DeviceInfoDeviceInfo()
      ..info = info ?? this.info
      ..iosInfo = iosInfo ?? this.iosInfo
      ..androidInfo = androidInfo ?? this.androidInfo;
  }
}

DeviceInfoDeviceInfoIosInfo $DeviceInfoDeviceInfoIosInfoFromJson(Map<String, dynamic> json) {
  final DeviceInfoDeviceInfoIosInfo deviceInfoDeviceInfoIosInfo = DeviceInfoDeviceInfoIosInfo();
  final String? systemName = jsonConvert.convert<String>(json['systemName']);
  if (systemName != null) {
    deviceInfoDeviceInfoIosInfo.systemName = systemName;
  }
  final String? isPhysicalDevice = jsonConvert.convert<String>(json['isPhysicalDevice']);
  if (isPhysicalDevice != null) {
    deviceInfoDeviceInfoIosInfo.isPhysicalDevice = isPhysicalDevice;
  }
  final Utsname? utsname = jsonConvert.convert<Utsname>(json['utsname']);
  if (utsname != null) {
    deviceInfoDeviceInfoIosInfo.utsname = utsname;
  }
  final String? model = jsonConvert.convert<String>(json['model']);
  if (model != null) {
    deviceInfoDeviceInfoIosInfo.model = model;
  }
  final String? localizedModel = jsonConvert.convert<String>(json['localizedModel']);
  if (localizedModel != null) {
    deviceInfoDeviceInfoIosInfo.localizedModel = localizedModel;
  }
  final String? systemVersion = jsonConvert.convert<String>(json['systemVersion']);
  if (systemVersion != null) {
    deviceInfoDeviceInfoIosInfo.systemVersion = systemVersion;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    deviceInfoDeviceInfoIosInfo.name = name;
  }
  final String? identifierForVendor = jsonConvert.convert<String>(json['identifierForVendor']);
  if (identifierForVendor != null) {
    deviceInfoDeviceInfoIosInfo.identifierForVendor = identifierForVendor;
  }
  return deviceInfoDeviceInfoIosInfo;
}

Map<String, dynamic> $DeviceInfoDeviceInfoIosInfoToJson(DeviceInfoDeviceInfoIosInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['systemName'] = entity.systemName;
  data['isPhysicalDevice'] = entity.isPhysicalDevice;
  data['utsname'] = entity.utsname?.toJson();
  data['model'] = entity.model;
  data['localizedModel'] = entity.localizedModel;
  data['systemVersion'] = entity.systemVersion;
  data['name'] = entity.name;
  data['identifierForVendor'] = entity.identifierForVendor;
  return data;
}

extension DeviceInfoDeviceInfoIosInfoExtension on DeviceInfoDeviceInfoIosInfo {
  DeviceInfoDeviceInfoIosInfo copyWith({
    String? systemName,
    String? isPhysicalDevice,
    Utsname? utsname,
    String? model,
    String? localizedModel,
    String? systemVersion,
    String? name,
    String? identifierForVendor,
  }) {
    return DeviceInfoDeviceInfoIosInfo()
      ..systemName = systemName ?? this.systemName
      ..isPhysicalDevice = isPhysicalDevice ?? this.isPhysicalDevice
      ..utsname = utsname ?? this.utsname
      ..model = model ?? this.model
      ..localizedModel = localizedModel ?? this.localizedModel
      ..systemVersion = systemVersion ?? this.systemVersion
      ..name = name ?? this.name
      ..identifierForVendor = identifierForVendor ?? this.identifierForVendor;
  }
}

DeviceInfoDeviceInfoInfo $DeviceInfoDeviceInfoInfoFromJson(Map<String, dynamic> json) {
  final DeviceInfoDeviceInfoInfo deviceInfoDeviceInfoInfo = DeviceInfoDeviceInfoInfo();
  final String? uuid = jsonConvert.convert<String>(json['uuid']);
  if (uuid != null) {
    deviceInfoDeviceInfoInfo.uuid = uuid;
  }
  final bool? isPhysicalDevice = jsonConvert.convert<bool>(json['isPhysicalDevice']);
  if (isPhysicalDevice != null) {
    deviceInfoDeviceInfoInfo.isPhysicalDevice = isPhysicalDevice;
  }
  final String? deviceInfo = jsonConvert.convert<String>(json['deviceInfo']);
  if (deviceInfo != null) {
    deviceInfoDeviceInfoInfo.deviceInfo = deviceInfo;
  }
  return deviceInfoDeviceInfoInfo;
}

Map<String, dynamic> $DeviceInfoDeviceInfoInfoToJson(DeviceInfoDeviceInfoInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['uuid'] = entity.uuid;
  data['isPhysicalDevice'] = entity.isPhysicalDevice;
  data['deviceInfo'] = entity.deviceInfo;
  return data;
}

extension DeviceInfoDeviceInfoInfoExtension on DeviceInfoDeviceInfoInfo {
  DeviceInfoDeviceInfoInfo copyWith({
    String? uuid,
    bool? isPhysicalDevice,
    String? deviceInfo,
  }) {
    return DeviceInfoDeviceInfoInfo()
      ..uuid = uuid ?? this.uuid
      ..isPhysicalDevice = isPhysicalDevice ?? this.isPhysicalDevice
      ..deviceInfo = deviceInfo ?? this.deviceInfo;
  }
}

Utsname $UtsnameFromJson(Map<String, dynamic> json) {
  final Utsname utsname = Utsname();
  final String? release = jsonConvert.convert<String>(json['release']);
  if (release != null) {
    utsname.release = release;
  }
  final String? sysname = jsonConvert.convert<String>(json['sysname']);
  if (sysname != null) {
    utsname.sysname = sysname;
  }
  final String? nodename = jsonConvert.convert<String>(json['nodename']);
  if (nodename != null) {
    utsname.nodename = nodename;
  }
  final String? machine = jsonConvert.convert<String>(json['machine']);
  if (machine != null) {
    utsname.machine = machine;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    utsname.version = version;
  }
  return utsname;
}

Map<String, dynamic> $UtsnameToJson(Utsname entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['release'] = entity.release;
  data['sysname'] = entity.sysname;
  data['nodename'] = entity.nodename;
  data['machine'] = entity.machine;
  data['version'] = entity.version;
  return data;
}

extension UtsnameExtension on Utsname {
  Utsname copyWith({
    String? release,
    String? sysname,
    String? nodename,
    String? machine,
    String? version,
  }) {
    return Utsname()
      ..release = release ?? this.release
      ..sysname = sysname ?? this.sysname
      ..nodename = nodename ?? this.nodename
      ..machine = machine ?? this.machine
      ..version = version ?? this.version;
  }
}

DeviceInfoDeviceInfoAndroidInfo $DeviceInfoDeviceInfoAndroidInfoFromJson(Map<String, dynamic> json) {
  final DeviceInfoDeviceInfoAndroidInfo deviceInfoDeviceInfoAndroidInfo = DeviceInfoDeviceInfoAndroidInfo();
  final String? product = jsonConvert.convert<String>(json['product']);
  if (product != null) {
    deviceInfoDeviceInfoAndroidInfo.product = product;
  }
  final List<String>? supportedAbis =
      (json['supportedAbis'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (supportedAbis != null) {
    deviceInfoDeviceInfoAndroidInfo.supportedAbis = supportedAbis;
  }
  final String? serialNumber = jsonConvert.convert<String>(json['serialNumber']);
  if (serialNumber != null) {
    deviceInfoDeviceInfoAndroidInfo.serialNumber = serialNumber;
  }
  final DeviceInfoDeviceInfoAndroidInfoDisplayMetrics? displayMetrics =
      jsonConvert.convert<DeviceInfoDeviceInfoAndroidInfoDisplayMetrics>(json['displayMetrics']);
  if (displayMetrics != null) {
    deviceInfoDeviceInfoAndroidInfo.displayMetrics = displayMetrics;
  }
  final List<dynamic>? supported32BitAbis = (json['supported32BitAbis'] as List<dynamic>?)?.map((e) => e).toList();
  if (supported32BitAbis != null) {
    deviceInfoDeviceInfoAndroidInfo.supported32BitAbis = supported32BitAbis;
  }
  final String? display = jsonConvert.convert<String>(json['display']);
  if (display != null) {
    deviceInfoDeviceInfoAndroidInfo.display = display;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    deviceInfoDeviceInfoAndroidInfo.type = type;
  }
  final bool? isPhysicalDevice = jsonConvert.convert<bool>(json['isPhysicalDevice']);
  if (isPhysicalDevice != null) {
    deviceInfoDeviceInfoAndroidInfo.isPhysicalDevice = isPhysicalDevice;
  }
  final DeviceInfoDeviceInfoAndroidInfoVersion? version =
      jsonConvert.convert<DeviceInfoDeviceInfoAndroidInfoVersion>(json['version']);
  if (version != null) {
    deviceInfoDeviceInfoAndroidInfo.version = version;
  }
  final List<String>? supported64BitAbis =
      (json['supported64BitAbis'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (supported64BitAbis != null) {
    deviceInfoDeviceInfoAndroidInfo.supported64BitAbis = supported64BitAbis;
  }
  final String? bootloader = jsonConvert.convert<String>(json['bootloader']);
  if (bootloader != null) {
    deviceInfoDeviceInfoAndroidInfo.bootloader = bootloader;
  }
  final String? fingerprint = jsonConvert.convert<String>(json['fingerprint']);
  if (fingerprint != null) {
    deviceInfoDeviceInfoAndroidInfo.fingerprint = fingerprint;
  }
  final String? host = jsonConvert.convert<String>(json['host']);
  if (host != null) {
    deviceInfoDeviceInfoAndroidInfo.host = host;
  }
  final String? model = jsonConvert.convert<String>(json['model']);
  if (model != null) {
    deviceInfoDeviceInfoAndroidInfo.model = model;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    deviceInfoDeviceInfoAndroidInfo.id = id;
  }
  final String? brand = jsonConvert.convert<String>(json['brand']);
  if (brand != null) {
    deviceInfoDeviceInfoAndroidInfo.brand = brand;
  }
  final String? device = jsonConvert.convert<String>(json['device']);
  if (device != null) {
    deviceInfoDeviceInfoAndroidInfo.device = device;
  }
  final String? board = jsonConvert.convert<String>(json['board']);
  if (board != null) {
    deviceInfoDeviceInfoAndroidInfo.board = board;
  }
  final String? hardware = jsonConvert.convert<String>(json['hardware']);
  if (hardware != null) {
    deviceInfoDeviceInfoAndroidInfo.hardware = hardware;
  }
  return deviceInfoDeviceInfoAndroidInfo;
}

Map<String, dynamic> $DeviceInfoDeviceInfoAndroidInfoToJson(DeviceInfoDeviceInfoAndroidInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['product'] = entity.product;
  data['supportedAbis'] = entity.supportedAbis;
  data['serialNumber'] = entity.serialNumber;
  data['displayMetrics'] = entity.displayMetrics?.toJson();
  data['supported32BitAbis'] = entity.supported32BitAbis;
  data['display'] = entity.display;
  data['type'] = entity.type;
  data['isPhysicalDevice'] = entity.isPhysicalDevice;
  data['version'] = entity.version?.toJson();
  data['supported64BitAbis'] = entity.supported64BitAbis;
  data['bootloader'] = entity.bootloader;
  data['fingerprint'] = entity.fingerprint;
  data['host'] = entity.host;
  data['model'] = entity.model;
  data['id'] = entity.id;
  data['brand'] = entity.brand;
  data['device'] = entity.device;
  data['board'] = entity.board;
  data['hardware'] = entity.hardware;
  return data;
}

extension DeviceInfoDeviceInfoAndroidInfoExtension on DeviceInfoDeviceInfoAndroidInfo {
  DeviceInfoDeviceInfoAndroidInfo copyWith({
    String? product,
    List<String>? supportedAbis,
    String? serialNumber,
    DeviceInfoDeviceInfoAndroidInfoDisplayMetrics? displayMetrics,
    List<dynamic>? supported32BitAbis,
    String? display,
    String? type,
    bool? isPhysicalDevice,
    DeviceInfoDeviceInfoAndroidInfoVersion? version,
    List<String>? supported64BitAbis,
    String? bootloader,
    String? fingerprint,
    String? host,
    String? model,
    String? id,
    String? brand,
    String? device,
    String? board,
    String? hardware,
  }) {
    return DeviceInfoDeviceInfoAndroidInfo()
      ..product = product ?? this.product
      ..supportedAbis = supportedAbis ?? this.supportedAbis
      ..serialNumber = serialNumber ?? this.serialNumber
      ..displayMetrics = displayMetrics ?? this.displayMetrics
      ..supported32BitAbis = supported32BitAbis ?? this.supported32BitAbis
      ..display = display ?? this.display
      ..type = type ?? this.type
      ..isPhysicalDevice = isPhysicalDevice ?? this.isPhysicalDevice
      ..version = version ?? this.version
      ..supported64BitAbis = supported64BitAbis ?? this.supported64BitAbis
      ..bootloader = bootloader ?? this.bootloader
      ..fingerprint = fingerprint ?? this.fingerprint
      ..host = host ?? this.host
      ..model = model ?? this.model
      ..id = id ?? this.id
      ..brand = brand ?? this.brand
      ..device = device ?? this.device
      ..board = board ?? this.board
      ..hardware = hardware ?? this.hardware;
  }
}

DeviceInfoDeviceInfoAndroidInfoDisplayMetrics $DeviceInfoDeviceInfoAndroidInfoDisplayMetricsFromJson(
    Map<String, dynamic> json) {
  final DeviceInfoDeviceInfoAndroidInfoDisplayMetrics deviceInfoDeviceInfoAndroidInfoDisplayMetrics =
      DeviceInfoDeviceInfoAndroidInfoDisplayMetrics();
  final int? xDpi = jsonConvert.convert<int>(json['xDpi']);
  if (xDpi != null) {
    deviceInfoDeviceInfoAndroidInfoDisplayMetrics.xDpi = xDpi;
  }
  final int? widthPx = jsonConvert.convert<int>(json['widthPx']);
  if (widthPx != null) {
    deviceInfoDeviceInfoAndroidInfoDisplayMetrics.widthPx = widthPx;
  }
  final int? heightPx = jsonConvert.convert<int>(json['heightPx']);
  if (heightPx != null) {
    deviceInfoDeviceInfoAndroidInfoDisplayMetrics.heightPx = heightPx;
  }
  final int? yDpi = jsonConvert.convert<int>(json['yDpi']);
  if (yDpi != null) {
    deviceInfoDeviceInfoAndroidInfoDisplayMetrics.yDpi = yDpi;
  }
  return deviceInfoDeviceInfoAndroidInfoDisplayMetrics;
}

Map<String, dynamic> $DeviceInfoDeviceInfoAndroidInfoDisplayMetricsToJson(
    DeviceInfoDeviceInfoAndroidInfoDisplayMetrics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['xDpi'] = entity.xDpi;
  data['widthPx'] = entity.widthPx;
  data['heightPx'] = entity.heightPx;
  data['yDpi'] = entity.yDpi;
  return data;
}

extension DeviceInfoDeviceInfoAndroidInfoDisplayMetricsExtension on DeviceInfoDeviceInfoAndroidInfoDisplayMetrics {
  DeviceInfoDeviceInfoAndroidInfoDisplayMetrics copyWith({
    int? xDpi,
    int? widthPx,
    int? heightPx,
    int? yDpi,
  }) {
    return DeviceInfoDeviceInfoAndroidInfoDisplayMetrics()
      ..xDpi = xDpi ?? this.xDpi
      ..widthPx = widthPx ?? this.widthPx
      ..heightPx = heightPx ?? this.heightPx
      ..yDpi = yDpi ?? this.yDpi;
  }
}

DeviceInfoDeviceInfoAndroidInfoVersion $DeviceInfoDeviceInfoAndroidInfoVersionFromJson(Map<String, dynamic> json) {
  final DeviceInfoDeviceInfoAndroidInfoVersion deviceInfoDeviceInfoAndroidInfoVersion =
      DeviceInfoDeviceInfoAndroidInfoVersion();
  final String? baseOS = jsonConvert.convert<String>(json['baseOS']);
  if (baseOS != null) {
    deviceInfoDeviceInfoAndroidInfoVersion.baseOS = baseOS;
  }
  final String? securityPatch = jsonConvert.convert<String>(json['securityPatch']);
  if (securityPatch != null) {
    deviceInfoDeviceInfoAndroidInfoVersion.securityPatch = securityPatch;
  }
  final int? sdkInt = jsonConvert.convert<int>(json['sdkInt']);
  if (sdkInt != null) {
    deviceInfoDeviceInfoAndroidInfoVersion.sdkInt = sdkInt;
  }
  final String? release = jsonConvert.convert<String>(json['release']);
  if (release != null) {
    deviceInfoDeviceInfoAndroidInfoVersion.release = release;
  }
  final String? codename = jsonConvert.convert<String>(json['codename']);
  if (codename != null) {
    deviceInfoDeviceInfoAndroidInfoVersion.codename = codename;
  }
  final int? previewSdkInt = jsonConvert.convert<int>(json['previewSdkInt']);
  if (previewSdkInt != null) {
    deviceInfoDeviceInfoAndroidInfoVersion.previewSdkInt = previewSdkInt;
  }
  final String? incremental = jsonConvert.convert<String>(json['incremental']);
  if (incremental != null) {
    deviceInfoDeviceInfoAndroidInfoVersion.incremental = incremental;
  }
  return deviceInfoDeviceInfoAndroidInfoVersion;
}

Map<String, dynamic> $DeviceInfoDeviceInfoAndroidInfoVersionToJson(DeviceInfoDeviceInfoAndroidInfoVersion entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['baseOS'] = entity.baseOS;
  data['securityPatch'] = entity.securityPatch;
  data['sdkInt'] = entity.sdkInt;
  data['release'] = entity.release;
  data['codename'] = entity.codename;
  data['previewSdkInt'] = entity.previewSdkInt;
  data['incremental'] = entity.incremental;
  return data;
}

extension DeviceInfoDeviceInfoAndroidInfoVersionExtension on DeviceInfoDeviceInfoAndroidInfoVersion {
  DeviceInfoDeviceInfoAndroidInfoVersion copyWith({
    String? baseOS,
    String? securityPatch,
    int? sdkInt,
    String? release,
    String? codename,
    int? previewSdkInt,
    String? incremental,
  }) {
    return DeviceInfoDeviceInfoAndroidInfoVersion()
      ..baseOS = baseOS ?? this.baseOS
      ..securityPatch = securityPatch ?? this.securityPatch
      ..sdkInt = sdkInt ?? this.sdkInt
      ..release = release ?? this.release
      ..codename = codename ?? this.codename
      ..previewSdkInt = previewSdkInt ?? this.previewSdkInt
      ..incremental = incremental ?? this.incremental;
  }
}

DeviceInfoRuntimeInfo $DeviceInfoRuntimeInfoFromJson(Map<String, dynamic> json) {
  final DeviceInfoRuntimeInfo deviceInfoRuntimeInfo = DeviceInfoRuntimeInfo();
  final String? network = jsonConvert.convert<String>(json['network']);
  if (network != null) {
    deviceInfoRuntimeInfo.network = network;
  }
  final String? battery = jsonConvert.convert<String>(json['battery']);
  if (battery != null) {
    deviceInfoRuntimeInfo.battery = battery;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    deviceInfoRuntimeInfo.date = date;
  }
  return deviceInfoRuntimeInfo;
}

Map<String, dynamic> $DeviceInfoRuntimeInfoToJson(DeviceInfoRuntimeInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['network'] = entity.network;
  data['battery'] = entity.battery;
  data['date'] = entity.date;
  return data;
}

extension DeviceInfoRuntimeInfoExtension on DeviceInfoRuntimeInfo {
  DeviceInfoRuntimeInfo copyWith({
    String? network,
    String? battery,
    String? date,
  }) {
    return DeviceInfoRuntimeInfo()
      ..network = network ?? this.network
      ..battery = battery ?? this.battery
      ..date = date ?? this.date;
  }
}

DeviceInfoPackageInfo $DeviceInfoPackageInfoFromJson(Map<String, dynamic> json) {
  final DeviceInfoPackageInfo deviceInfoPackageInfo = DeviceInfoPackageInfo();
  final String? appName = jsonConvert.convert<String>(json['appName']);
  if (appName != null) {
    deviceInfoPackageInfo.appName = appName;
  }
  final String? packageName = jsonConvert.convert<String>(json['packageName']);
  if (packageName != null) {
    deviceInfoPackageInfo.packageName = packageName;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    deviceInfoPackageInfo.version = version;
  }
  final String? buildNumber = jsonConvert.convert<String>(json['buildNumber']);
  if (buildNumber != null) {
    deviceInfoPackageInfo.buildNumber = buildNumber;
  }
  return deviceInfoPackageInfo;
}

Map<String, dynamic> $DeviceInfoPackageInfoToJson(DeviceInfoPackageInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['appName'] = entity.appName;
  data['packageName'] = entity.packageName;
  data['version'] = entity.version;
  data['buildNumber'] = entity.buildNumber;
  return data;
}

extension DeviceInfoPackageInfoExtension on DeviceInfoPackageInfo {
  DeviceInfoPackageInfo copyWith({
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
  }) {
    return DeviceInfoPackageInfo()
      ..appName = appName ?? this.appName
      ..packageName = packageName ?? this.packageName
      ..version = version ?? this.version
      ..buildNumber = buildNumber ?? this.buildNumber;
  }
}
