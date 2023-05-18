import 'dart:io';

import 'package:nothing/common/prefix_header.dart';

import '../model/file_model.dart';

class FontsSetting extends StatefulWidget {
  const FontsSetting({Key? key}) : super(key: key);

  @override
  State<FontsSetting> createState() => _FontsSettingState();
}

class _FontsSettingState extends State<FontsSetting> {
  final List<FileModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    print('font setting dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字体设置'),
      ),
      body: Consumer2<DownloadProvider, ThemesProvider>(
        builder: (context, downloadProvider, themesProvider, child) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              FileModel e = _dataList[index];
              return Container(
                decoration:
                    BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(AppSize.radiusMedium)),
                padding: AppPadding.main,
                margin: AppPadding.main,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      e.name ?? '',
                      style: AppTextStyle.titleMedium.copyWith(fontFamily: e.name),
                    )),
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
                                    Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () {
                                        e.status = DownloadStatus.downloading;
                                        downloadProvider.addTask(
                                            url: e.url, name: e.name ?? '', savePath: PathUtils.fontPath);
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: AppImage.asset(R.iconsDownloadCloud,
                                      color: AppColor.specialColor, width: 28, height: 28)),
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
                                  color: AppColor.placeholderColor,
                                  strokeWidth: 4,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Visibility(
                              visible: e.status == DownloadStatus.downloading,
                              child: ChangeNotifierProvider<DownloadTask>(
                                create: (context) =>
                                    downloadProvider.tasks.firstWhere((element) => element.name == e.name),
                                child: Consumer<DownloadTask>(
                                  builder: (context, task, child) {
                                    task.completedCallback = (isCompleted) {
                                      e.status = DownloadStatus.downloaded;
                                      downloadProvider.removeTask(task: task);
                                      setState(() {});
                                    };
                                    return InkWell(
                                      onTap: () {
                                        e.status = DownloadStatus.initial;
                                        task.cancel();
                                        downloadProvider.removeTask(task: task);
                                        setState(() {});
                                      },
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: task.progress,
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
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Visibility(
                              visible: e.status == DownloadStatus.downloaded,
                              child: themesProvider.fontFamily == e.name
                                  ? AppImage.asset(R.iconsCheckSquare, color: AppColor.doneColor)
                                  : InkWell(
                                      onTap: () async {
                                        await AppTextStyle.loadFont(name: e.name);
                                        themesProvider.fontFamily = e.name;
                                      },
                                      child: AppImage.asset(R.iconsSquare, color: AppColor.placeholderColor)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _dataList.length,
            // shrinkWrap: true,
          );
        },
      ),
    );
  }

  _loadData() async {
    List<dynamic>? s = await API.getFiles('src/fonts/') ?? [];

    _dataList.clear();
    _dataList.add(FileModel()
      ..name = 'default'
      ..status = DownloadStatus.downloaded);
    for (Map<String, dynamic> e in s) {
      FileModel model = FileModel.fromJson(e);
      if (model.name == '...') continue;
      String path = '${PathUtils.fontPath}/${model.name}';
      model.path = path;
      File file = File(path);
      model.status = file.existsSync() ? DownloadStatus.downloaded : DownloadStatus.initial;
      _dataList.add(model);
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
