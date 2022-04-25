import 'package:fluttertoast/fluttertoast.dart';
import 'package:nothing/public.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../widgets/dialogs/toast_tips_dialog.dart';

void showToast(String text) {
  Fluttertoast.showToast(msg: text, gravity: ToastGravity.BOTTOM);
}

void showCenterToast(String text) {
  Fluttertoast.showToast(msg: text, gravity: ToastGravity.CENTER);
}

void showErrorToast(String text) {
  Fluttertoast.showToast(msg: text, backgroundColor: Colors.redAccent);
}

void showCenterErrorToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.redAccent);
}

void showTopToast(String text) {
  Fluttertoast.showToast(msg: text, gravity: ToastGravity.TOP);
}

void hideAllToast() {
  Fluttertoast.cancel();
}

void showConfirmToast(
    {required BuildContext context,
    required String title,
    required VoidCallback? onConfirm}) {
  showDialog<bool>(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black38,
      barrierDismissible: true,
      builder: (_) => ToastTipsDialog(
            title: title,
            onConfirm: onConfirm,
          ));
}

void showSheet(BuildContext context, List<SheetButtonModel> list) {
  showMaterialModalBottomSheet(
    expand: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => ModalFit(list: list),
  );
}

class ModalFit extends StatelessWidget {
  final List<SheetButtonModel> list;

  const ModalFit({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: list.map((e) {
            return Container(
              height: 44,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                        if (e.onTap != null) {
                          e.onTap();
                        }
                      },
                      child: Stack(
                        children: [
                          Align(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 32),
                              child: e.icon,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Align(
                            child: Text(e.title,
                                style: e.textStyle ?? const TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 16,
                                      )),
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: colorBackground,
                    indent: 32,
                    endIndent: 32,
                  )
                ],
              ),
            );
          }).toList()),
    ));
  }
}

class SheetButtonModel {
  final String title;
  final Widget? icon;
  final Function onTap;
  final TextStyle? textStyle;

  SheetButtonModel(
      {required this.title, required this.onTap, this.icon, this.textStyle});
}
