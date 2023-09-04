import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/exception_model.g.dart';
import 'package:nothing/model/device_info_model.dart';

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
