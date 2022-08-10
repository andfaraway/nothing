import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nothing/page/wedding_detail.dart';
import 'package:nothing/public.dart';
import 'package:nothing/model/wedding_model.dart';
import 'package:nothing/widgets/dialogs/toast_tips_dialog.dart';

class WeddingAbout extends StatefulWidget {
  const WeddingAbout({Key? key}) : super(key: key);

  @override
  State<WeddingAbout> createState() => _WeddingAboutState();
}

class _WeddingAboutState extends State<WeddingAbout> {
  late final RefreshController _controller;
  List<WeddingModel> weddings = [];

  @override
  void initState() {
    super.initState();
    _controller = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('💑'),
          actions: [
            IconButton(
                onPressed: () {
                  addWedding();
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: SmartRefresher(
          onRefresh: () async {
            await loadWeddings();
            _controller.refreshCompleted();
          },
          controller: _controller,
          child: ListView.builder(
            itemBuilder: (context, i) {
              WeddingModel model = weddings[i];
              return checkCell(model);
            },
            itemCount: weddings.length,
          ),
        ),
        floatingActionButton: IconButton(
            onPressed: () {
              AppRoutes.pushNamePage(context, feedbackRoute.routeName);
            },
            icon: Icon(Icons.feedback_outlined)),
      ),
    );
  }

  Widget checkCell(WeddingModel model) {
    ValueNotifier<bool> notifier = ValueNotifier(model.done == '1');
    TextEditingController _controller =
        TextEditingController(text: model.title);
    return Padding(
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
                    var s = await AppRoutes.pushPage(
                        context,
                        WeddingDetailPage(
                          model: model,
                        ));
                    if(s != null) loadWeddings();
                  },
                  child: TextField(
                    controller: _controller,
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () async {
                      if (model.title != _controller.text) {
                        model.title = _controller.text;
                        await updateWedding(model);
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
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
    weddings.clear();
    for (Map<String, dynamic> map in data) {
      WeddingModel model = WeddingModel.fromJson(map);
      weddings.add(model);
    }
    setState(() {});
    print(data.toString());
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

  Future<void> deleteWedding(WeddingModel model) async {
    EasyLoading.show();
    await API.deleteWedding(model.id);
  }
}
