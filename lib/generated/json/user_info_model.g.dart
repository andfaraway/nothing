import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/user_info_model.dart';

UserInfoModel $UserInfoModelFromJson(Map<String, dynamic> json) {
	final UserInfoModel userInfoModel = UserInfoModel();
	final String? username = jsonConvert.convert<String>(json['username']);
	if (username != null) {
		userInfoModel.username = username;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		userInfoModel.nickname = nickname;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		userInfoModel.email = email;
	}
	final String? platform = jsonConvert.convert<String>(json['platform']);
	if (platform != null) {
		userInfoModel.platform = platform;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		userInfoModel.userId = userId;
	}
	final String? avatar = jsonConvert.convert<String>(json['avatar']);
	if (avatar != null) {
		userInfoModel.avatar = avatar;
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
	data['username'] = entity.username;
	data['nickname'] = entity.nickname;
	data['email'] = entity.email;
	data['platform'] = entity.platform;
	data['userId'] = entity.userId;
	data['avatar'] = entity.avatar;
	data['token'] = entity.token;
	data['openId'] = entity.openId;
	return data;
}