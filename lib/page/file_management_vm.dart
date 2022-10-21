import 'package:nothing/page/file_management.dart';
import 'package:nothing/public.dart';

import '../model/file_model.dart';

class FileManagementVM extends BaseVM {
  FileManagementVM(BuildContext context) : super(context);

  List<FileModel> files = [];

  //当前目录
  String path = '';

  @override
  void init() {
    loadFiles(null);
  }

  Future<void> loadFiles(String? catalog) async {
    var s = await API.getFiles(catalog);
    if(s == null) return;
    path = catalog ?? '';
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
          catalog = catalog.replaceRange(catalog.length-1, catalog.length, '');
          //去除上一层目录
          catalog = catalog.replaceAll(catalog.split('/').last, '');
        }
        await loadFiles(catalog);
      } else {
        await loadFiles('${model.catalog??''}${model.name}/');
      }
    }
  }

  Future<void> changeFile(FileModel model,String newName) async{
    await API.changeFileName(model.catalog, model.name!, newName);
    await loadFiles(model.catalog);
  }

  Future<void> deleteFile(FileModel model) async{
    await API.deleteFile(model.catalog, model.name!);
    print('object');
    await loadFiles(model.catalog);
  }
}
