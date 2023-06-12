import 'dart:async';
import 'dart:io';

import 'package:nothing/common/prefix_header.dart';

import '../model/file_model.dart';

class DownloadButton extends StatefulWidget {
  final FileModel file;
  final bool isSelected;
  final VoidCallback? unSelectedOnTap;
  final VoidCallback? selectedOnTap;

  const DownloadButton(
      {Key? key, required this.file, this.isSelected = false, this.unSelectedOnTap, this.selectedOnTap})
      : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  DownloadButtonStatus _status = DownloadButtonStatus.initial;
  double _progress = 0;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    String savePath = '${PathUtils.fontPath}/${widget.file.name}';
    widget.file.savePath = savePath;
    if (File(savePath).existsSync()) {
      _status = widget.isSelected ? DownloadButtonStatus.selected : DownloadButtonStatus.unSelected;
    } else {
      if (widget.file.url.isEmpty) {
        _status = widget.isSelected ? DownloadButtonStatus.selected : DownloadButtonStatus.unSelected;
      } else {
        _status = DownloadButtonStatus.initial;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppMessage.addListener<DownloadTask>(
        (event) {
          if (event.url == widget.file.url) {
            _progress = event.progress;
            if (event.progress == 1) {
              _status = DownloadButtonStatus.unSelected;
            } else if (event.progress == -1) {
              _status = DownloadButtonStatus.initial;
            } else {
              _status = DownloadButtonStatus.downloading;
            }
          }

          if (mounted) {
            setState(() {});
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: IconButton(
          onPressed: () {
            if (_status == DownloadButtonStatus.initial) {
              DownloadProvider.addTask(url: widget.file.url, name: widget.file.name, savePath: widget.file.savePath);
            } else if (_status == DownloadButtonStatus.downloading) {
              DownloadTask? task = DownloadProvider.tasks.firstWhereOrNull((element) => element.url == widget.file.url);
              task?.cancel();
            } else if (_status == DownloadButtonStatus.unSelected) {
              widget.unSelectedOnTap?.call();
            } else if (_status == DownloadButtonStatus.selected) {
              widget.selectedOnTap?.call();
            }
          },
          icon: _iconWidget(_status, progress: _progress)),
    );
  }

  Widget _iconWidget(DownloadButtonStatus status, {double? progress}) {
    Widget icon = const SizedBox.shrink();
    switch (status) {
      case DownloadButtonStatus.initial:
        icon = AppImage.asset(R.iconsDownloadCloud, color: AppColor.specialColor, width: 28, height: 28);
        break;
      case DownloadButtonStatus.requesting:
        icon = CircularProgressIndicator(
          color: AppColor.placeholderColor,
          strokeWidth: 4,
        );
        break;
      case DownloadButtonStatus.downloading:
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
      case DownloadButtonStatus.unSelected:
        icon = AppImage.asset(R.iconsSquare, color: AppColor.placeholderColor);
        break;
      case DownloadButtonStatus.selected:
        icon = AppImage.asset(R.iconsCheckSquare, color: AppColor.doneColor);
        break;
      default:
    }
    return SizedBox(width: 44, height: 44, child: Center(child: icon));
  }
}

enum DownloadButtonStatus {
  initial,
  selected,
  unSelected,
  downloading,
  requesting,
}
