import 'package:nothing/model/message_model.dart';

messageModelFromJson(MessageModel data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['time'] != null) {
		data.time = json['time'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	return data;
}

Map<String, dynamic> messageModelToJson(MessageModel entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['time'] = entity.time;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['type'] = entity.type;
	return data;
}