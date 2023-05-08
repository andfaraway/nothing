import 'package:nothing/common/prefix_header.dart';

import '../model/wedding_model.dart';

class WeddingAboutVM extends BaseVM {

  WeddingAboutVM(BuildContext context) : super(context);

  List<WeddingModel> todoList = [];

  @override
  void init() {
    loadWeddings();
  }

  Future<void> addWedding() async {
    EasyLoading.show();
    await API.insertWedding(title: '代办事项');
    await loadWeddings();
  }

  Future<void> loadWeddings() async {
    List<dynamic> data = await API.getWeddings();
    todoList.clear();
    for (Map<String, dynamic> map in data) {
      WeddingModel model = WeddingModel.fromJson(map);
      todoList.add(model);
    }
    widgetSetState();
  }

  Future<void> insertWedding() async {
    EasyLoading.show();
    var a = await API.getWeddings();
    print(a.toString());
  }

  Future<void> updateWedding(WeddingModel model) async {
    EasyLoading.show();
    await API.updateWedding(
        id: model.id,
        title: model.title,
        content: model.content,
        done: model.done);
  }

  Future<void> updateWeddingSort(WeddingModel model,int sort) async {
    await API.updateWeddingSort(
        id: model.id,
        sort: sort,
       );
  }

  Future<void> deleteWedding(WeddingModel model) async {
    EasyLoading.show();
    await API.deleteWedding(model.id);
  }
}


