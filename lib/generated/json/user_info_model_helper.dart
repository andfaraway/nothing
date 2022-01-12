import 'package:nothing/model/user_info_model.dart';

userInfoModelFromJson(UserInfoModel data, Map<String, dynamic> json) {
	if (json['username'] != null) {
		data.username = json['username'].toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['email'] != null) {
		data.email = json['email'].toString();
	}
	if (json['platform'] != null) {
		data.platform = json['platform'].toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['token'] != null) {
		data.token = json['token'].toString();
	}
	if (json['openId'] != null) {
		data.openId = json['openId'].toString();
	}
	return data;
}

Map<String, dynamic> userInfoModelToJson(UserInfoModel entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
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