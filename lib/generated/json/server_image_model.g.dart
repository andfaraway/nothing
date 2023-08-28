import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/server_image_model.dart';

ServerImageModel $ServerImageModelFromJson(Map<String, dynamic> json) {
  final ServerImageModel serverImageModel = ServerImageModel();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    serverImageModel.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    serverImageModel.name = name;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    serverImageModel.size = size;
  }
  final String? prefix = jsonConvert.convert<String>(json['prefix']);
  if (prefix != null) {
    serverImageModel.prefix = prefix;
  }
  final String? imageUrl = jsonConvert.convert<String>(json['imageUrl']);
  if (imageUrl != null) {
    serverImageModel.imageUrl = imageUrl;
  }
  return serverImageModel;
}

Map<String, dynamic> $ServerImageModelToJson(ServerImageModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['size'] = entity.size;
  data['prefix'] = entity.prefix;
  data['imageUrl'] = entity.imageUrl;
  return data;
}

extension ServerImageModelExtension on ServerImageModel {
  ServerImageModel copyWith({
    String? id,
    String? name,
    int? size,
    String? prefix,
    String? imageUrl,
  }) {
    return ServerImageModel()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..size = size ?? this.size
      ..prefix = prefix ?? this.prefix
      ..imageUrl = imageUrl ?? this.imageUrl;
  }
}