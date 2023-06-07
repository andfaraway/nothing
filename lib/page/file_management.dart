import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/page/video_screen.dart';

import '../model/file_model.dart';
import '../widgets/picture_viewer.dart';

class FileManagement extends StatefulWidget {
  final dynamic arguments;

  const FileManagement({Key? key, this.arguments}) : super(key: key);

  @override
  State<FileManagement> createState() => _FileManagementState();
}

class _FileManagementState extends State<FileManagement> {
  List<FileModel> files = [];

  //当前目录
  String? currentCatalog;

  final AppRefreshController _refreshController = AppRefreshController(autoRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.appbar(
        titleWidget: Text(
          currentCatalog ?? 'File Management',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      body: AppRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await loadFiles(currentCatalog);
          _refreshController.refreshCompleted();
        },
        child: Padding(
          padding: AppPadding.main,
          child: ListView(
            children: files
                .asMap()
                .map((index, model) => MapEntry(
                    index,
                    InkWell(
                      onTap: () {
                        onTap(model);
                      },
                      onLongPress: () {
                        if (model.name == '...') return;
                        showSheet(
                          context,
                          [
                            SheetButtonModel(
                                icon: const Icon(Icons.open_in_new_outlined),
                                title: S.current.open,
                                onTap: () async {
                                  open(model, index);
                                }),
                            SheetButtonModel(
                                icon: const Icon(Icons.edit_outlined),
                                title: S.current.rename,
                                onTap: () async {
                                  showEdit(context, title: S.current.rename, text: model.name,
                                      commitPressed: (value) async {
                                    await changeFile(model, value);
                                  });
                                }),
                            SheetButtonModel(
                              icon: const Icon(Icons.delete_forever),
                              title: S.current.delete,
                              textStyle: const TextStyle(color: Colors.red),
                              onTap: () async {
                                showConfirmToast(
                                  context: context,
                                  title: '${S.current.delete} ${model.name} ?',
                                  onConfirm: () async {
                                    deleteFile(model);
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 44,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  model.isDir
                                      ? Image.asset(R.iconsFolder, width: 24, height: 24, color: Colors.orange)
                                      : Image.asset(R.iconsFile, width: 22, height: 22),
                                  10.wSizedBox,
                                  Text(model.name ?? '')
                                ],
                              ),
                            ),
                          ),
                          1.hDivider
                        ],
                      ),
                    )))
                .values
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> loadFiles(String? catalog) async {
    var s = await API.getFiles(catalog);
    if (s == null) return;
    currentCatalog = catalog;
    files.clear();
    for (Map<String, dynamic> map in s) {
      FileModel model = FileModel.fromJson(map);
      files.add(model);
    }
    setState(() {});
  }

  Future<void> onTap(FileModel model) async {
    if (model.isDir) {
      if (model.prefix == null) {
        String catalog = model.catalog!;
        //返回上层
        if (catalog.contains('/')) {
          //去除反斜杠
          catalog = catalog.replaceRange(catalog.length - 1, catalog.length, '');
          //去除上一层目录
          catalog = catalog.replaceAll(catalog.split('/').last, '');
        }
        await loadFiles(catalog);
      } else {
        await loadFiles('${model.catalog ?? ''}${model.name}/');
      }
    }
  }

  Future<void> changeFile(FileModel model, String newName) async {
    await API.changeFileName(model.catalog, model.name!, newName);
    await loadFiles(model.catalog);
    showToast(S.current.success);
  }

  Future<void> deleteFile(FileModel model) async {
    await API.deleteFile(model.catalog, model.name!);
    await loadFiles(model.catalog);
    showToast(S.current.success);
  }

  Future<void> open(FileModel model, int index) async {
    String url = "${model.prefix}${model.catalog ?? ''}${model.name}";
    if (Utils.isImage(model.type)) {
      PictureViewer pictureViewer = PictureViewer(
        imageUrl: url,
        originalImageSize: model.size,
        onTap: () {
          Navigator.pop(context);
        },
      );
      showCustomWidget(context: context, child: pictureViewer);
    } else if (Utils.isVideo(model.type)) {
      AppRoute.pushPage(
          context,
          VideoScreen(
            url: url,
            files: files,
            index: index,
          ));
    } else {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        showToast("unknown type");
      }
    }
  }
}
