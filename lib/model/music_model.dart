import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/music_model.g.dart';

export 'package:nothing/generated/json/music_model.g.dart';

@JsonSerializable()
class MusicModel {
  late String album = '';
  late String author = '';
  late String cover = '';
  late String genre = '';
  late String id = '';
  late String lyrics = '';
  late String name = '';
  @JSONField(name: "track_number")
  late String trackNumber = '';
  late String url = '';
  late String year = '';

  MusicModel();

  factory MusicModel.fromJson(Map<String, dynamic> json) => $MusicModelFromJson(json);

  Map<String, dynamic> toJson() => $MusicModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
