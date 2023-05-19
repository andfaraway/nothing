import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/file_model.g.dart';

@JsonSerializable()
class FileModel {
  bool isDir = false;
  String? name;
  int? size;
  String? type;
  String? prefix;
  String? catalog;
  String? savePath;

  String get url => prefix == null ? '' : '$prefix/$catalog/$name';

  FileModel();

  factory FileModel.fromJson(Map<String, dynamic> json) => $FileModelFromJson(json);

  Map<String, dynamic> toJson() => $FileModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
