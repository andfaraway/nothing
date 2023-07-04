import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  int? code;
  String? type;
  String? message;
  String? remark;

  ErrorModel();

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      $ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => $ErrorModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
