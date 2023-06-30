import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../common/constants.dart';
import '../model/image_compression_model.dart';

class DownloadModel {
  String path;
  bool complete;
  double? progress;
  String tips;
  XFile? file;
  ImageCompressionModel? imageCompressionModel;

  DownloadModel(
      {this.path = '', this.complete = false, this.progress, this.tips = '', this.file, this.imageCompressionModel});
}

class DownloadController extends ValueNotifier<DownloadModel> {
  DownloadController(super.value);

  String get path => value.path;

  bool get complete => value.complete;

  double? get progress => value.progress;

  String get tips => value.tips;

  XFile? get file => value.file;

  ImageCompressionModel? get imageCompressionModel => value.imageCompressionModel;

  set path(String newPath) {
    super.value.path = newPath;
    notifyListeners();
  }

  set complete(bool inProgress) {
    super.value.complete = inProgress;
    notifyListeners();
  }

  set progress(double? newProgress) {
    super.value.progress = newProgress;
    notifyListeners();
  }

  set tips(String newTips) {
    super.value.tips = newTips;
    notifyListeners();
  }

  set file(XFile? newFile) {
    super.value.file = newFile;
    notifyListeners();
  }

  set imageCompressionModel(ImageCompressionModel? value) {
    super.value.imageCompressionModel = value;
    notifyListeners();
  }
}
