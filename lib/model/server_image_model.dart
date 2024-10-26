import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/server_image_model.g.dart';

@JsonSerializable()
class ServerImageModel {
  String? id;
  String? name;
  int? size;
  String? prefix;

  String get imageUrl => '$prefix$name';

  ServerImageModel();

  factory ServerImageModel.fromJson(Map<String, dynamic> json) => $ServerImageModelFromJson(json);

  Map<String, dynamic> toJson() => $ServerImageModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
