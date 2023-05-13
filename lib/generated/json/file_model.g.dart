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
  final int? downloadStatus = jsonConvert.convert<int>(json['downloadStatus']);
  if (downloadStatus != null) {
    fileModel.status = downloadStatus;
  }
  final double? process = jsonConvert.convert<double>(json['process']);
  if (process != null) {
    fileModel.process = process;
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
  data['downloadStatus'] = entity.status;
  data['process'] = entity.process;
  return data;
}