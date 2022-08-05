import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/login_model.g.dart';
import 'dart:convert';

@JsonSerializable()
class LoginModel {

	String? userid;
	String? username;
	String? date;
	String? alias;
	String? version;
	@JSONField(name: "device_info")
	String? deviceInfo;
	String? network;
	String? battery;
  
  LoginModel();

  factory LoginModel.fromJson(Map<String, dynamic> json) => $LoginModelFromJson(json);

  Map<String, dynamic> toJson() => $LoginModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}