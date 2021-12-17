import 'package:nothing/generated/json/base/json_convert_content.dart';

class UserInfoModel with JsonConvert<UserInfoModel> {
	String? name;
	String? platform;
	String? userId;
	String? icon;
	String? token;
}
