import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/message_model.dart';

MessageModel $MessageModelFromJson(Map<String, dynamic> json) {
	final MessageModel messageModel = MessageModel();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		messageModel.id = id;
	}
	final String? date = jsonConvert.convert<String>(json['date']);
	if (date != null) {
		messageModel.date = date;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		messageModel.title = title;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		messageModel.content = content;
	}
	final int? type = jsonConvert.convert<int>(json['type']);
	if (type != null) {
		messageModel.type = type;
	}
	return messageModel;
}

Map<String, dynamic> $MessageModelToJson(MessageModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['date'] = entity.date;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['type'] = entity.type;
	return data;
}