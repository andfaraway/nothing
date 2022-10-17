import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/file_model.g.dart';
import 'dart:convert';

@JsonSerializable()
class FileModel {

	bool? isDir;
	String? name;
	int? size;
	String? type;
	String? prefix;
  String? catalog;
  
  FileModel();

  factory FileModel.fromJson(Map<String, dynamic> json) => $FileModelFromJson(json);

  Map<String, dynamic> toJson() => $FileModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}