import 'package:nothing/common/prefix_header.dart';

import '../model/wedding_model.dart';

class WeddingDetailPage extends StatefulWidget {
  final WeddingModel model;

  const WeddingDetailPage({Key? key, required this.model}) : super(key: key);

  @override
  State<WeddingDetailPage> createState() => _WeddingDetailState();
}

class _WeddingDetailState extends State<WeddingDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHideOnTap(
      child: Scaffold(
        appBar: DefaultAppBar(
          title: 'Wedding Detail',
          actions: [
            AppButton.button(
              padding: AppPadding.main,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onTap: () {
                showConfirmToast(
                    context: context,
                    title: "${S.current.delete}?",
                    onConfirm: () async {
                      await deleteWedding(widget.model);
                      if (mounted) {
                        Navigator.of(context).pop('refresh');
                      }
                    });
              },
            ),
          ],
        ),
        body: Padding(
          padding: AppPadding.main,
          child: SafeArea(
            bottom: true,
            top: false,
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(text: widget.model.title),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none), hintText: '标题'),
                  style: AppTextStyle.titleMedium,
                  onChanged: (value) {
                    widget.model.title = value;
                  },
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: TextEditingController(
                        text: widget.model.content,
                      ),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: '详细信息',
                          hintStyle: AppTextStyle.bodyMedium.placeholderColor),
                      maxLines: 50,
                      style: AppTextStyle.bodyMedium,
                      onChanged: (value) {
                        widget.model.content = value;
                      },
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: MaterialButton(
                      onPressed: () async {
                        hideKeyboard(context);
                        await updateWedding(widget.model);
                      },
                      color: AppColor.red,
                      child: Text(
                        S.current.save,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addWedding() async {
    await API.insertWedding(title: '代办事项');
  }

  Future<void> insertWedding() async {
    await API.getWeddings();
  }

  Future<void> updateWedding(WeddingModel model) async {
    if (model.title == null || model.title == '') {
      showToast("标题不能为空");
      return;
    }
    await API.updateWedding(id: model.id, title: model.title, content: model.content, done: model.done);
    showToast(S.current.success);
  }

  Future<dynamic> deleteWedding(WeddingModel model) async {
    return API.deleteWedding(model.id);
  }
}
