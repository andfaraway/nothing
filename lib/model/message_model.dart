import 'package:nothing/generated/json/base/json_convert_content.dart';

class MessageModel with JsonConvert<MessageModel> {
	int? id;
	String? time;
	String? title;
	String? content;
	int? type;
}
