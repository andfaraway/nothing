import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/poetry_model.dart';

PoetryModel $PoetryModelFromJson(Map<String, dynamic> json) {
  final PoetryModel poetryModel = PoetryModel();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    poetryModel.title = title;
  }
  final String? author = jsonConvert.convert<String>(json['author']);
  if (author != null) {
    poetryModel.author = author;
  }
  final String? book = jsonConvert.convert<String>(json['book']);
  if (book != null) {
    poetryModel.book = book;
  }
  final String? dynasty = jsonConvert.convert<String>(json['dynasty']);
  if (dynasty != null) {
    poetryModel.dynasty = dynasty;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    poetryModel.content = content;
  }
  final bool? expand = jsonConvert.convert<bool>(json['expand']);
  if (expand != null) {
    poetryModel.expand = expand;
  }
  return poetryModel;
}

Map<String, dynamic> $PoetryModelToJson(PoetryModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['author'] = entity.author;
  data['book'] = entity.book;
  data['dynasty'] = entity.dynasty;
  data['content'] = entity.content;
  data['expand'] = entity.expand;
  return data;
}

extension PoetryModelExtension on PoetryModel {
  PoetryModel copyWith({
    String? title,
    String? author,
    String? book,
    String? dynasty,
    String? content,
    bool? expand,
  }) {
    return PoetryModel()
      ..title = title ?? this.title
      ..author = author ?? this.author
      ..book = book ?? this.book
      ..dynasty = dynasty ?? this.dynasty
      ..content = content ?? this.content
      ..expand = expand ?? this.expand;
  }
}