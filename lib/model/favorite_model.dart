//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-17 17:33:08
//

import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  String? favoriteId;
  String? content;
  @JSONField(name: "source")
  String? xSource;
  String? date;

  FavoriteModel();

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => $FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => $FavoriteModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
