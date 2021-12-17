import 'package:nothing/model/user_info_model.dart';

userInfoModelFromJson(UserInfoModel data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['platform'] != null) {
		data.platform = json['platform'].toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'].toString();
	}
	if (json['icon'] != null) {
		data.icon = json['icon'].toString();
	}
	if (json['token'] != null) {
		data.token = json['token'].toString();
	}
	return data;
}

Map<String, dynamic> userInfoModelToJson(UserInfoModel entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['platform'] = entity.platform;
	data['userId'] = entity.userId;
	data['icon'] = entity.icon;
	data['token'] = entity.token;
	return data;
}