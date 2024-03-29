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
  final int? sort = jsonConvert.convert<int>(json['sort']);
  if (sort != null) {
    weddingModel.sort = sort;
  }
  return weddingModel;
}

Map<String, dynamic> $WeddingModelToJson(WeddingModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['done'] = entity.done;
  data['sort'] = entity.sort;
  return data;
}

extension WeddingModelExtension on WeddingModel {
  WeddingModel copyWith({
    String? id,
    String? title,
    String? content,
    String? done,
    int? sort,
  }) {
    return WeddingModel()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..done = done ?? this.done
      ..sort = sort ?? this.sort;
  }
}