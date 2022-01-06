import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/user_info_model.dart';

UserInfoModel $UserInfoModelFromJson(Map<String, dynamic> json) {
	final UserInfoModel userInfoModel = UserInfoModel();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		userInfoModel.name = name;
	}
	final String? platform = jsonConvert.convert<String>(json['platform']);
	if (platform != null) {
		userInfoModel.platform = platform;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		userInfoModel.userId = userId;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		userInfoModel.icon = icon;
	}
	final String? token = jsonConvert.convert<String>(json['token']);
	if (token != null) {
		userInfoModel.token = token;
	}
	final String? openId = jsonConvert.convert<String>(json['openId']);
	if (openId != null) {
		userInfoModel.openId = openId;
	}
	return userInfoModel;
}

Map<String, dynamic> $UserInfoModelToJson(UserInfoModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['platform'] = entity.platform;
	data['userId'] = entity.userId;
	data['icon'] = entity.icon;
	data['token'] = entity.token;
	data['openId'] = entity.openId;
	return data;
}