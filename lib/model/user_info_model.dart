import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/user_info_model.g.dart';


@JsonSerializable()
class UserInfoModel {

	UserInfoModel();

	factory UserInfoModel.fromJson(Map<String, dynamic> json) {
		json['accountType'] = json['account_type'];
		return $UserInfoModelFromJson(json);
	}

	Map<String, dynamic> toJson() => $UserInfoModelToJson(this);

	String? username;
	String? nickname;
	String? email;
	String? platform;
	String? userId;
	String? avatar;
	String? token;
	String? openId;
	String? accountType;
}
