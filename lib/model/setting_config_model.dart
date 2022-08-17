import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/setting_config_model.g.dart';
import 'dart:convert';

@JsonSerializable()
class SettingConfigModel {

	String? id;
	String? module;
	@JSONField(name: "account_type")
	String? accountType;
	@JSONField(name: "route_name")
	String? routeName;
	String? onTap;
	String? onLongPress;
	String? sort;
	String? drawer;
	String? icon;
  
  SettingConfigModel();

  factory SettingConfigModel.fromJson(Map<String, dynamic> json) => $SettingConfigModelFromJson(json);

  Map<String, dynamic> toJson() => $SettingConfigModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}