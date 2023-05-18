import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/favorite_model.dart';

FavoriteModel $FavoriteModelFromJson(Map<String, dynamic> json) {
  final FavoriteModel favoriteModel = FavoriteModel();
  final String? favoriteId = jsonConvert.convert<String>(json['favoriteId']);
  if (favoriteId != null) {
    favoriteModel.favoriteId = favoriteId;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    favoriteModel.content = content;
  }
  final String? xSource = jsonConvert.convert<String>(json['source']);
  if (xSource != null) {
    favoriteModel.xSource = xSource;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    favoriteModel.date = date;
  }
  return favoriteModel;
}

Map<String, dynamic> $FavoriteModelToJson(FavoriteModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['favoriteId'] = entity.favoriteId;
  data['content'] = entity.content;
  data['source'] = entity.xSource;
  data['date'] = entity.date;
  return data;
}
