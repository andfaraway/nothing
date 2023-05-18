import 'dart:async';
import 'dart:io';

import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/utils/string_extension.dart';

import '../model/file_model.dart';

class DownloadButton extends StatefulWidget {
  final FileModel file;

  const DownloadButton({Key? key, required this.file}) : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  int _status = DownloadStatus.initial;
  double _progress = 0;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    String savePath = '${PathUtils.fontPath}/${widget.file.name}';
    widget.file.savePath = savePath;
    _status = File(savePath).existsSync() ? DownloadStatus.downloaded : DownloadStatus.initial;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppMessage.addListener<DownloadTask>((event) {
        if (event.url == widget.file.url) {
          _progress = event.progress;
          if (event.progress == 1) {
            _status = DownloadStatus.downloaded;
          } else if (event.progress == -1) {
            _status = DownloadStatus.initial;
          } else {
            _status = DownloadStatus.downloading;
          }
        }

        print('progress=$_progress,state=$_status');
        if (mounted) {
          print('mounted = $mounted');
          setState(() {});
        } else {
          print('mounted = $mounted');
        }
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build: progress=$_progress,state=$_status');

    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: IconButton(
          onPressed: () {
            if (_status == DownloadStatus.initial) {
              DownloadProvider.addTask(url: widget.file.url, name: widget.file.name, savePath: widget.file.savePath);
            } else if (_status == DownloadStatus.downloading) {
              DownloadTask? task = DownloadProvider.tasks.firstWhereOrNull((element) => element.url == widget.file.url);
              task?.cancel();
              print('DownloadProvider.list = ${DownloadProvider.tasks}');
            }
          },
          icon: _iconWidget(_status, progress: _progress)),
    );
  }

  Widget _iconWidget(int status, {double? progress}) {
    Widget icon = const SizedBox.shrink();
    switch (status) {
      case DownloadStatus.initial:
        icon = AppImage.asset(R.iconsDownloadCloud, color: AppColor.specialColor, width: 28, height: 28);
        break;
      case DownloadStatus.requesting:
        icon = CircularProgressIndicator(
          color: AppColor.placeholderColor,
          strokeWidth: 4,
        );
        break;
      case DownloadStatus.downloading:
        icon = Stack(
          children: [
            CircularProgressIndicator(
              value: progress,
              color: AppColor.specialColor,
              backgroundColor: AppColor.scaffoldBackgroundColor,
            ),
            Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: AppColor.specialColor, borderRadius: BorderRadius.circular(2)),
              ),
            )
          ],
        );
        break;
      case DownloadStatus.downloaded:
      case DownloadStatus.unSelected:
        icon = AppImage.asset(R.iconsSquare, color: AppColor.placeholderColor);
        break;
      case DownloadStatus.selected:
        icon = AppImage.asset(R.iconsCheckSquare, color: AppColor.doneColor);
        break;
      default:
    }
    return SizedBox(width: 44, height: 44, child: Center(child: icon));
  }
}

class DownloadStatus {
  DownloadStatus._();

  static const int initial = 0;
  static const int downloading = 1;
  static const int requesting = 2;
  static const int failed = -1;
  static const int downloaded = 99;
  static const int selected = 98;
  static const int unSelected = 97;
  static const int success = 99;
}
