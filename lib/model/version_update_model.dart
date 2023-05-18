import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/version_update_model.g.dart';

@JsonSerializable()
class VersionUpdateModel {
  String? id;
  String? platform;
  String? version;
  String? path;
  String? title;
  String? content;
  String? date;

  VersionUpdateModel();

  factory VersionUpdateModel.fromJson(Map<String, dynamic> json) => $VersionUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => $VersionUpdateModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
