import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/file_model.dart';

FileModel $FileModelFromJson(Map<String, dynamic> json) {
	final FileModel fileModel = FileModel();
	final bool? isDir = jsonConvert.convert<bool>(json['isDir']);
	if (isDir != null) {
		fileModel.isDir = isDir;
	}
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    fileModel.name = name;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    fileModel.size = size;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    fileModel.type = type;
  }
  final String? prefix = jsonConvert.convert<String>(json['prefix']);
  if (prefix != null) {
    fileModel.prefix = prefix;
  }
  final String? catalog = jsonConvert.convert<String>(json['catalog']);
  if (catalog != null) {
    fileModel.catalog = catalog;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    fileModel.status = status;
  }
  final String? path = jsonConvert.convert<String>(json['path']);
  if (path != null) {
    fileModel.path = path;
  }
  return fileModel;
}

Map<String, dynamic> $FileModelToJson(FileModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
  data['isDir'] = entity.isDir;
  data['name'] = entity.name;
  data['size'] = entity.size;
  data['type'] = entity.type;
  data['prefix'] = entity.prefix;
  data['catalog'] = entity.catalog;
  data['status'] = entity.status;
  data['path'] = entity.path;
  return data;
}