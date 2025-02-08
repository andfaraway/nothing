import 'package:info_utils_plugin/info_utils_plugin.dart';
import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/exception_model.dart';

ExceptionModel $ExceptionModelFromJson(Map<String, dynamic> json) {
  final ExceptionModel exceptionModel = ExceptionModel();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    exceptionModel.id = id;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    exceptionModel.type = type;
  }
  final String? des = jsonConvert.convert<String>(json['des']);
  if (des != null) {
    exceptionModel.des = des;
  }
  final String? stack = jsonConvert.convert<String>(json['stack']);
  if (stack != null) {
    exceptionModel.stack = stack;
  }
  final DeviceInfoModel? deviceInfo = jsonConvert.convert<DeviceInfoModel>(json['deviceInfo']);
  if (deviceInfo != null) {
    exceptionModel.deviceInfo = deviceInfo;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    exceptionModel.date = date;
  }
  return exceptionModel;
}

Map<String, dynamic> $ExceptionModelToJson(ExceptionModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['type'] = entity.type;
  data['des'] = entity.des;
  data['stack'] = entity.stack;
  data['deviceInfo'] = entity.deviceInfo?.toJson();
  data['date'] = entity.date;
  return data;
}

extension ExceptionModelExtension on ExceptionModel {
  ExceptionModel copyWith({
    int? id,
    String? type,
    String? des,
    String? stack,
    DeviceInfoModel? deviceInfo,
    String? date,
  }) {
    return ExceptionModel()
      ..id = id ?? this.id
      ..type = type ?? this.type
      ..des = des ?? this.des
      ..stack = stack ?? this.stack
      ..deviceInfo = deviceInfo ?? this.deviceInfo
      ..date = date ?? this.date;
  }
}