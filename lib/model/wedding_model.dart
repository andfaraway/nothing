import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/wedding_model.g.dart';

@JsonSerializable()
class WeddingModel {
  String? id;
  String? title;
  String? content;
  String? done;
  int sort = 0;

  WeddingModel();

  factory WeddingModel.fromJson(Map<String, dynamic> json) => $WeddingModelFromJson(json);

  Map<String, dynamic> toJson() => $WeddingModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
