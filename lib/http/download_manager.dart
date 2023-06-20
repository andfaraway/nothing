import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../common/constants.dart';

class DownloadModel {
  String path;
  bool inProgress;
  double? progress;
  String tips;
  XFile? file;

  DownloadModel({
    this.path = '',
    this.inProgress = false,
    this.progress,
    this.tips = '',
    this.file,
  });
}

class DownloadController extends ValueNotifier<DownloadModel> {
  DownloadController(super.value);

  String get path => value.path;

  bool get inProgress => value.inProgress;

  double? get progress => value.progress;

  String get tips => value.tips;

  XFile? get file => value.file;

  set path(String newPath) {
    super.value.path = newPath;
    notifyListeners();
  }

  set inProgress(bool inProgress) {
    super.value.inProgress = inProgress;
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
}
