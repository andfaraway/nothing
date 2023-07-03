import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/error_model.dart';

ErrorModel $ErrorModelFromJson(Map<String, dynamic> json) {
  final ErrorModel errorModel = ErrorModel();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    errorModel.code = code;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    errorModel.type = type;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    errorModel.message = message;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    errorModel.remark = remark;
  }
  return errorModel;
}

Map<String, dynamic> $ErrorModelToJson(ErrorModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['type'] = entity.type;
  data['message'] = entity.message;
  data['remark'] = entity.remark;
  return data;
}
