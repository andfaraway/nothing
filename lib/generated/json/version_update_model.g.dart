import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/version_update_model.dart';

VersionUpdateModel $VersionUpdateModelFromJson(Map<String, dynamic> json) {
  final VersionUpdateModel versionUpdateModel = VersionUpdateModel();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    versionUpdateModel.id = id;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    versionUpdateModel.platform = platform;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    versionUpdateModel.version = version;
  }
  final String? path = jsonConvert.convert<String>(json['path']);
  if (path != null) {
    versionUpdateModel.path = path;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    versionUpdateModel.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    versionUpdateModel.content = content;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    versionUpdateModel.date = date;
  }
  return versionUpdateModel;
}

Map<String, dynamic> $VersionUpdateModelToJson(VersionUpdateModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['platform'] = entity.platform;
  data['version'] = entity.version;
  data['path'] = entity.path;
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['date'] = entity.date;
  return data;
}