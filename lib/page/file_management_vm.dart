import 'package:nothing/page/video_screen.dart';
import 'package:nothing/public.dart';
import 'package:nothing/widgets/picture_viewer.dart';

import '../model/file_model.dart';

class FileManagementVM extends BaseVM {
  FileManagementVM(BuildContext context) : super(context);

  List<FileModel> files = [];

  //当前目录
  String? currentCatalog;

  @override
  void init() {
    loadFiles(null);
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
    widgetSetState();
  }

  Future<void> onTap(FileModel model) async {
    if (model.isDir ?? false) {
      if (model.prefix == null) {
        String catalog = model.catalog!;
        //返回上层
        if (catalog.contains('/')) {
          //去除反斜杠
          catalog =
              catalog.replaceRange(catalog.length - 1, catalog.length, '');
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

  Future<void> open(FileModel model) async {
    String url = "${model.prefix}${model.catalog ?? ''}${model.name}";
    print(url);
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
      AppRoutes.pushPage(context, VideoScreen(url: url));
    } else{
      showToast("unknown type");
    }
  }
}
