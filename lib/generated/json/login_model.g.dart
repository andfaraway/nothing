import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/login_model.dart';

LoginModel $LoginModelFromJson(Map<String, dynamic> json) {
  final LoginModel loginModel = LoginModel();
  final String? userid = jsonConvert.convert<String>(json['userid']);
  if (userid != null) {
    loginModel.userid = userid;
  }
  final String? username = jsonConvert.convert<String>(json['username']);
  if (username != null) {
    loginModel.username = username;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    loginModel.date = date;
  }
  final String? alias = jsonConvert.convert<String>(json['alias']);
  if (alias != null) {
    loginModel.alias = alias;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    loginModel.version = version;
  }
  final String? deviceInfo = jsonConvert.convert<String>(json['device_info']);
  if (deviceInfo != null) {
    loginModel.deviceInfo = deviceInfo;
  }
  final String? network = jsonConvert.convert<String>(json['network']);
  if (network != null) {
    loginModel.network = network;
  }
  final String? battery = jsonConvert.convert<String>(json['battery']);
  if (battery != null) {
    loginModel.battery = battery;
  }
  return loginModel;
}

Map<String, dynamic> $LoginModelToJson(LoginModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['userid'] = entity.userid;
  data['username'] = entity.username;
  data['date'] = entity.date;
  data['alias'] = entity.alias;
  data['version'] = entity.version;
  data['device_info'] = entity.deviceInfo;
  data['network'] = entity.network;
  data['battery'] = entity.battery;
  return data;
}

extension LoginModelExtension on LoginModel {
  LoginModel copyWith({
    String? userid,
    String? username,
    String? date,
    String? alias,
    String? version,
    String? deviceInfo,
    String? network,
    String? battery,
  }) {
    return LoginModel()
      ..userid = userid ?? this.userid
      ..username = username ?? this.username
      ..date = date ?? this.date
      ..alias = alias ?? this.alias
      ..version = version ?? this.version
      ..deviceInfo = deviceInfo ?? this.deviceInfo
      ..network = network ?? this.network
      ..battery = battery ?? this.battery;
  }
}