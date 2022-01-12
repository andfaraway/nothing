import 'package:nothing/generated/json/base/json_convert_content.dart';

class UserInfoModel with JsonConvert<UserInfoModel> {
	String? username;
	String? nickname;
	String? email;
	String? platform;
	String? userId;
	String? avatar;
	String? token;
	String? openId;
}
