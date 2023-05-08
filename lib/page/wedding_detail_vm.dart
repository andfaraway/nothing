import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/wedding_model.dart';

class WeddingDetailVM extends BaseVM {
  WeddingDetailVM(BuildContext context) : super(context);

  @override
  void init() {}

  Future<void> addWedding() async {
    EasyLoading.show();
    await API.insertWedding(title: '代办事项');
  }

  Future<void> insertWedding() async {
    EasyLoading.show();
    var a = await API.getWeddings();
    print(a.toString());
  }

  Future<void> updateWedding(WeddingModel model) async {
    if (model.title == null || model.title == '') {
      showToast("标题不能为空");
      return;
    }
    EasyLoading.show();
    await API.updateWedding(
        id: model.id,
        title: model.title,
        content: model.content,
        done: model.done);
    showToast(S.current.success);
  }

  Future<dynamic> deleteWedding(WeddingModel model) async {
    EasyLoading.show();
    return API.deleteWedding(model.id);
  }
}
