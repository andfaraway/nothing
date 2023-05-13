import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/setting_config_model.dart';

SettingConfigModel $SettingConfigModelFromJson(Map<String, dynamic> json) {
	final SettingConfigModel settingConfigModel = SettingConfigModel();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		settingConfigModel.id = id;
	}
	final String? module = jsonConvert.convert<String>(json['module']);
	if (module != null) {
		settingConfigModel.module = module;
	}
	final String? accountType = jsonConvert.convert<String>(json['account_type']);
	if (accountType != null) {
		settingConfigModel.accountType = accountType;
	}
	final String? routeName = jsonConvert.convert<String>(json['route_name']);
	if (routeName != null) {
		settingConfigModel.routeName = routeName;
	}
	final String? onTap = jsonConvert.convert<String>(json['onTap']);
	if (onTap != null) {
		settingConfigModel.onTap = onTap;
	}
	final String? onLongPress = jsonConvert.convert<String>(json['onLongPress']);
	if (onLongPress != null) {
		settingConfigModel.onLongPress = onLongPress;
	}
	final String? sort = jsonConvert.convert<String>(json['sort']);
	if (sort != null) {
    settingConfigModel.sort = sort;
  }
  final String? drawer = jsonConvert.convert<String>(json['drawer']);
  if (drawer != null) {
    settingConfigModel.drawer = drawer;
  }
  final String? icon = jsonConvert.convert<String>(json['icon']);
  if (icon != null) {
    settingConfigModel.icon = icon;
  }
  final dynamic arguments = jsonConvert.convert<dynamic>(json['arguments']);
  if (arguments != null) {
    settingConfigModel.arguments = arguments;
  }
  return settingConfigModel;
}

Map<String, dynamic> $SettingConfigModelToJson(SettingConfigModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['module'] = entity.module;
	data['account_type'] = entity.accountType;
	data['route_name'] = entity.routeName;
	data['onTap'] = entity.onTap;
	data['onLongPress'] = entity.onLongPress;
	data['sort'] = entity.sort;
	data['drawer'] = entity.drawer;
	data['icon'] = entity.icon;
	data['arguments'] = entity.arguments;
	return data;
}