import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/poetry_model.g.dart';

export 'package:nothing/generated/json/poetry_model.g.dart';

@JsonSerializable()
class PoetryModel {
  String? title;
  String? author;
  String? book;
  String? dynasty;
  String? content;
  bool expand = false;

  PoetryModel();

  factory PoetryModel.fromJson(Map<String, dynamic> json) => $PoetryModelFromJson(json);

  Map<String, dynamic> toJson() => $PoetryModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
