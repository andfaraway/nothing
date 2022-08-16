import 'package:nothing/public.dart';

import '../model/wedding_model.dart';
import 'wedding_detail_vm.dart';

class WeddingDetailPage extends BasePage<_WeddingDetailState> {
  final WeddingModel model;

  const WeddingDetailPage({Key? key, required this.model}) : super(key: key);

  @override
  _WeddingDetailState createBaseState() => _WeddingDetailState();
}

class _WeddingDetailState
    extends BaseState<WeddingDetailVM, WeddingDetailPage> {
  @override
  WeddingDetailVM createVM() => WeddingDetailVM(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageTitle = "Wedding Detail";
  }

  @override
  List<Widget>? appBarActions() {
    // TODO: implement appBarActions
    return [
      defaultAppBarActions(
          text: S.current.save,
          onPressed: () async {
            Utils.hideKeyboard(context);
            await vm.updateWedding(widget.model);
          })
    ];
  }

  @override
  Widget createContentWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: widget.model.title),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: '标题'),
              style: TextStyle(color: colorBlackDefault, fontSize: 42.sp),
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
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: '详细信息'),
                  maxLines: 50,
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
                  onPressed: () {
                    showConfirmToast(context: context, title: "${S.current.delete}?", onConfirm: ()async{
                      await vm.deleteWedding(widget.model);
                      if(mounted){
                        Navigator.of(context).pop('refresh');
                      }
                    });
                  },
                  color: themeColorRed,
                  child: Text(
                    S.current.delete,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
