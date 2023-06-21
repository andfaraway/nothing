import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/image_compression_model.g.dart';

@JsonSerializable()
class ImageCompressionModel {
  int byteSizeAfter = 0;
  int byteSizeBefore = 0;
  String fileNameBefore = '';
  String output = '';
  String serverHost = '';

  String get ratio => byteSizeAfter == 0
      ? '0%'
      : '- ${((byteSizeBefore - byteSizeAfter) / byteSizeAfter.toDouble() * 100).toStringAsFixed(0)}%';

  ImageCompressionModel();

  factory ImageCompressionModel.fromJson(Map<String, dynamic> json) => $ImageCompressionModelFromJson(json);

  Map<String, dynamic> toJson() => $ImageCompressionModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
