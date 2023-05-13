import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nothing/common/prefix_header.dart';

import '../model/file_model.dart';

class FontsSetting extends StatefulWidget {
  const FontsSetting({Key? key}) : super(key: key);

  @override
  State<FontsSetting> createState() => _FontsSettingState();
}

class _FontsSettingState extends State<FontsSetting> {
  final List<FileModel> _dataList = [];

  final List<ValueNotifier<double>> _notifierList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('字体'),
          ),
      body: Column(
          children: List.generate(_dataList.length, (index) {
        FileModel e = _dataList[index];
        ValueNotifier<double> notifier = _notifierList[index];
        return Container(
          color: AppColor.white,
          height: AppSize.cellHeight,
          margin: AppPadding.main,
          // padding: AppPadding.main,
          child: Row(
            children: [
              Expanded(child: Text(e.name ?? '')),
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  children: [
                    Center(
                      child: Visibility(
                        visible: e.status == DownloadStatus.initial,
                        child: InkWell(
                            onTap: () {
                              e.status = DownloadStatus.requesting;
                              setState(() {});
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                e.status = DownloadStatus.downloading;
                                setState(() {});
                                API.downloadFile(
                                    url: '${e.prefix}/${e.catalog}/${e.name}',
                                    savePath: '${PathUtils.documentPath}/${e.name}',
                                    onReceiveProgress: (d1, d2, process) {
                                      e.process = process;
                                      notifier.value = process;
                                      print('${e.name}->$process');
                                    },
                                    cancelToken: CancelToken());
                              });
                            },
                            child: AppImage.asset(R.iconsDownloadCloud, color: AppColor.specialColor)),
                      ),
                    ),
                    Center(
                      child: Visibility(
                        visible: e.status == DownloadStatus.requesting,
                        child: InkWell(
                          onTap: () {
                            e.status = DownloadStatus.initial;
                            setState(() {});
                          },
                          child: CircularProgressIndicator(
                            color: AppColor.specialColor,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Visibility(
                          visible: e.status == DownloadStatus.downloading,
                          child: ValueListenableBuilder(
                            valueListenable: notifier,
                            builder: (context, progress, child) {
                              return InkWell(
                                onTap: () {
                                  e.status = DownloadStatus.initial;
                                  setState(() {});
                                },
                                child: Stack(
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        value: e.process,
                                        color: AppColor.specialColor,
                                        backgroundColor: AppColor.scaffoldBackgroundColor,
                                      ),
                                    ),
                                    child!
                                  ],
                                ),
                              );
                            },
                            child: Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                color: AppColor.specialColor,
                              ),
                            ),
                          )),
                    ),
                    Center(
                      child: Visibility(
                        visible: e.status == DownloadStatus.downloaded,
                        child: AppImage.asset(R.iconsCheckCircle, color: AppColor.placeholderColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      })),
    );
  }

  _loadData() async {
    List<dynamic>? s = await API.getFiles('src/fonts/') ?? [];

    _dataList.clear();
    for (var element in _notifierList) {
      element.dispose();
    }
    _notifierList.clear();

    for (Map<String, dynamic> e in s) {
      FileModel model = FileModel.fromJson(e);
      if (model.name == '...') continue;
      File file = File('${PathUtils.documentPath}/${model.name}');
      model.status = await file.exists() ? DownloadStatus.downloaded : DownloadStatus.initial;
      print('${model.status}->${file.path}');
      _dataList.add(model);
      _notifierList.add(ValueNotifier(0));
    }
    setState(() {});
  }
}

class DownloadStatus {
  DownloadStatus._();

  static const int initial = 0;
  static const int downloading = 1;
  static const int requesting = 2;
  static const int failed = -1;
  static const int downloaded = 99;
  static const int success = 99;
}
