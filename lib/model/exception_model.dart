import 'dart:convert';

import 'package:info_utils_plugin/info_utils_plugin.dart';
import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/exception_model.g.dart';

@JsonSerializable()
class ExceptionModel {
  int? id = 0;
  String? type = '';
  String? des = '';
  String? stack = '';
  DeviceInfoModel? deviceInfo;
  String? date = '';

  ExceptionModel();

  factory ExceptionModel.fromJson(Map<String, dynamic> json) => $ExceptionModelFromJson(json);

  Map<String, dynamic> toJson() => $ExceptionModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
