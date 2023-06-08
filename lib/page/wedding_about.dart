import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/wedding_model.dart';
import 'package:nothing/page/wedding_detail.dart';

class WeddingAbout extends StatefulWidget {
  final dynamic arguments;

  const WeddingAbout({Key? key, this.arguments}) : super(key: key);

  @override
  State<WeddingAbout> createState() => _WeddingAboutState();
}

class _WeddingAboutState extends State<WeddingAbout> {
  late final AppRefreshController _controller = AppRefreshController(autoRefresh: true);

  List<WeddingModel> todoList = [];

  @override
  void initState() {
    super.initState();
    loadWeddings();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.appbar(
        title: '💑 婚礼待办 💑',
        actions: [
          IconButton(
            onPressed: () async {
              await addWedding();
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: AppRefresher(
        onRefresh: () async {
          await loadWeddings();
          _controller.completed();
        },
        controller: _controller,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ReorderableListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      WeddingModel model = todoList[i];
                      return checkCell(model);
                    },
                    itemCount: todoList.length,
                    onReorder: onReorder),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          AppRoute.pushNamePage(context, AppRoute.feedback.name);
        },
        icon: const Icon(Icons.feedback_outlined),
      ),
    );
  }

  Future<void> onReorder(int oldIndex, int newIndex) async {
    bool sortUp = true;
    if (oldIndex < newIndex) {
      newIndex -= 1;
      sortUp = false;
    }
    int markSort = todoList[newIndex].sort;
    final WeddingModel element = todoList.removeAt(oldIndex);
    setState(() {
      todoList.insert(newIndex, element);
    });

    //请求服务器
    // 排序下降
    int sort = markSort - 1;
    if (sortUp) {
      sort = markSort + 1;
    }
    element.sort = sort;
    await updateWeddingSort(element, sort);
  }

  Widget checkCell(WeddingModel model) {
    ValueNotifier<bool> notifier = ValueNotifier(model.done == '1');
    TextEditingController controller = TextEditingController(text: model.title);
    return Padding(
      key: ValueKey(model.id),
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        builder: (context, bool value, child) {
          return Row(
            children: [
              Checkbox(
                  value: notifier.value,
                  onChanged: (value) async {
                    notifier.value = !notifier.value;
                    if (notifier.value) {
                      model.done = '1';
                    } else {
                      model.done = '0';
                    }
                    await updateWedding(model);
                  }),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    var s = await AppRoute.pushPage(
                        context,
                        WeddingDetailPage(
                          model: model,
                        ));
                    if (s != null) {
                      setState(() {
                        loadWeddings();
                      });
                    }
                  },
                  child: TextField(
                    controller: controller,
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () async {
                      if (model.title != controller.text) {
                        model.title = controller.text;
                        await updateWedding(model);
                      }
                      if (mounted) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        valueListenable: notifier,
      ),
    );
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
    setState(() {});
  }

  Future<void> insertWedding() async {
    EasyLoading.show();
    var a = await API.getWeddings();
    print(a.toString());
  }

  Future<void> updateWedding(WeddingModel model) async {
    EasyLoading.show();
    await API.updateWedding(id: model.id, title: model.title, content: model.content, done: model.done);
  }

  Future<void> updateWeddingSort(WeddingModel model, int sort) async {
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
