import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/wedding_model.dart';
import 'package:nothing/page/wedding_detail.dart';

import 'wedding_about_vm.dart';

class WeddingAbout extends BasePage<_WeddingAboutState> {
  final dynamic arguments;

  const WeddingAbout({Key? key, this.arguments}) : super(key: key);

  @override
  _WeddingAboutState createBaseState() => _WeddingAboutState();
}

class _WeddingAboutState extends BaseState<WeddingAboutVM, WeddingAbout> {
  @override
  WeddingAboutVM createVM() => WeddingAboutVM(context);

  late final AppRefreshController _controller =
  AppRefreshController(autoRefresh: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageTitle = "💑 婚礼待办 💑";
    needHidKeyboard = true;
  }

  @override
  List<Widget>? appBarActions() {
    return [
      IconButton(
          onPressed: () async {
            await vm.addWedding();
          },
          icon: const Icon(Icons.add))
    ];
  }

  @override
  Widget? floatingActionButton() {
    return IconButton(
        onPressed: () {
          Routes.pushNamePage(context, Routes.feedback.name);
        },
        icon: const Icon(Icons.feedback_outlined));
  }

  @override
  Widget createContentWidget() {
    return AppRefresher(
      onRefresh: () async {
        await vm.loadWeddings();
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
                    WeddingModel model = vm.todoList[i];
                    return checkCell(model);
                  },
                  itemCount: vm.todoList.length,
                  onReorder: onReorder),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onReorder(int oldIndex, int newIndex) async {
    bool sortUp = true;
    if (oldIndex < newIndex) {
      newIndex -= 1;
      sortUp = false;
    }
    int markSort = vm.todoList[newIndex].sort;
    final WeddingModel element = vm.todoList.removeAt(oldIndex);
    setState(() {
      vm.todoList.insert(newIndex, element);
    });

    //请求服务器
    // 排序下降
    int sort = markSort - 1;
    if(sortUp){
      sort = markSort + 1;
    }
    element.sort = sort;
    await vm.updateWeddingSort(element, sort);
  }

  Widget checkCell(WeddingModel model) {
    ValueNotifier<bool> notifier = ValueNotifier(model.done == '1');
    TextEditingController controller =
    TextEditingController(text: model.title);
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
                    await vm.updateWedding(model);
                  }),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    var s = await Routes.pushPage(
                        context,
                        WeddingDetailPage(
                          model: model,
                        ));
                    if (s != null) {
                      setState(() {
                        vm.loadWeddings();
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
                        await vm.updateWedding(model);
                      }
                      if (mounted) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none
                      ),
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
}
