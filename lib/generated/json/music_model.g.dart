import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/music_model.dart';

MusicModel $MusicModelFromJson(Map<String, dynamic> json) {
  final MusicModel musicModel = MusicModel();
  final String? album = jsonConvert.convert<String>(json['album']);
  if (album != null) {
    musicModel.album = album;
  }
  final String? author = jsonConvert.convert<String>(json['author']);
  if (author != null) {
    musicModel.author = author;
  }
  final String? cover = jsonConvert.convert<String>(json['cover']);
  if (cover != null) {
    musicModel.cover = cover;
  }
  final String? genre = jsonConvert.convert<String>(json['genre']);
  if (genre != null) {
    musicModel.genre = genre;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    musicModel.id = id;
  }
  final String? lyrics = jsonConvert.convert<String>(json['lyrics']);
  if (lyrics != null) {
    musicModel.lyrics = lyrics;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    musicModel.name = name;
  }
  final String? trackNumber = jsonConvert.convert<String>(json['track_number']);
  if (trackNumber != null) {
    musicModel.trackNumber = trackNumber;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    musicModel.url = url;
  }
  final String? year = jsonConvert.convert<String>(json['year']);
  if (year != null) {
    musicModel.year = year;
  }
  return musicModel;
}

Map<String, dynamic> $MusicModelToJson(MusicModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['album'] = entity.album;
  data['author'] = entity.author;
  data['cover'] = entity.cover;
  data['genre'] = entity.genre;
  data['id'] = entity.id;
  data['lyrics'] = entity.lyrics;
  data['name'] = entity.name;
  data['track_number'] = entity.trackNumber;
  data['url'] = entity.url;
  data['year'] = entity.year;
  return data;
}

extension MusicModelExtension on MusicModel {
  MusicModel copyWith({
    String? album,
    String? author,
    String? cover,
    String? genre,
    String? id,
    String? lyrics,
    String? name,
    String? trackNumber,
    String? url,
    String? year,
  }) {
    return MusicModel()
      ..album = album ?? this.album
      ..author = author ?? this.author
      ..cover = cover ?? this.cover
      ..genre = genre ?? this.genre
      ..id = id ?? this.id
      ..lyrics = lyrics ?? this.lyrics
      ..name = name ?? this.name
      ..trackNumber = trackNumber ?? this.trackNumber
      ..url = url ?? this.url
      ..year = year ?? this.year;
  }
}