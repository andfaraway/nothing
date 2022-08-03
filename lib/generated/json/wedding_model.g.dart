import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/wedding_model.dart';

WeddingModel $WeddingModelFromJson(Map<String, dynamic> json) {
	final WeddingModel weddingModel = WeddingModel();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		weddingModel.id = id;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		weddingModel.title = title;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		weddingModel.content = content;
	}
	final String? done = jsonConvert.convert<String>(json['done']);
	if (done != null) {
		weddingModel.done = done;
	}
	return weddingModel;
}

Map<String, dynamic> $WeddingModelToJson(WeddingModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['done'] = entity.done;
	return data;
}