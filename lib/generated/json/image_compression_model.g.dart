import 'package:nothing/generated/json/base/json_convert_content.dart';
import 'package:nothing/model/image_compression_model.dart';

ImageCompressionModel $ImageCompressionModelFromJson(Map<String, dynamic> json) {
  final ImageCompressionModel imageCompressionModel = ImageCompressionModel();
  final int? byteSizeAfter = jsonConvert.convert<int>(json['byteSizeAfter']);
  if (byteSizeAfter != null) {
    imageCompressionModel.byteSizeAfter = byteSizeAfter;
  }
  final int? byteSizeBefore = jsonConvert.convert<int>(json['byteSizeBefore']);
  if (byteSizeBefore != null) {
    imageCompressionModel.byteSizeBefore = byteSizeBefore;
  }
  final String? fileNameBefore = jsonConvert.convert<String>(json['fileNameBefore']);
  if (fileNameBefore != null) {
    imageCompressionModel.fileNameBefore = fileNameBefore;
  }
  final String? output = jsonConvert.convert<String>(json['output']);
  if (output != null) {
    imageCompressionModel.output = output;
  }
  final String? serverHost = jsonConvert.convert<String>(json['serverHost']);
  if (serverHost != null) {
    imageCompressionModel.serverHost = serverHost;
  }
  return imageCompressionModel;
}

Map<String, dynamic> $ImageCompressionModelToJson(ImageCompressionModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['byteSizeAfter'] = entity.byteSizeAfter;
  data['byteSizeBefore'] = entity.byteSizeBefore;
  data['fileNameBefore'] = entity.fileNameBefore;
  data['output'] = entity.output;
  data['serverHost'] = entity.serverHost;
  return data;
}

extension ImageCompressionModelExtension on ImageCompressionModel {
  ImageCompressionModel copyWith({
    int? byteSizeAfter,
    int? byteSizeBefore,
    String? fileNameBefore,
    String? output,
    String? serverHost,
  }) {
    return ImageCompressionModel()
      ..byteSizeAfter = byteSizeAfter ?? this.byteSizeAfter
      ..byteSizeBefore = byteSizeBefore ?? this.byteSizeBefore
      ..fileNameBefore = fileNameBefore ?? this.fileNameBefore
      ..output = output ?? this.output
      ..serverHost = serverHost ?? this.serverHost;
  }
}