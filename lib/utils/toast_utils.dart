//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-17 16:32:31
//

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../prefix_header.dart';
import '../widgets/dialogs/toast_tips_dialog.dart';

void showToast(String text, {int timeInSecForIosWeb = 1}) {
  Fluttertoast.showToast(
      msg: text,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb);
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

void showHttpLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom

    ///背景颜色
    ..backgroundColor = Color(0xfff4f7fb)

    ///进度颜色
    ..indicatorColor = Color(0xff0082CD)
    ..textColor = Color(0xff0082CD)
    ..textStyle = TextStyle(fontSize: 12)
    ..indicatorType = EasyLoadingIndicatorType.wave;
  EasyLoading.show();
}

void hideHttpLoading() {
  EasyLoading.dismiss();
}

void showIOSAlert(
    {required BuildContext context,
    String? title,
    String? content,
    String? confirmText,
    VoidCallback? cancelOnPressed,
    VoidCallback? confirmOnPressed}) {
  showDialog<bool>(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black38,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
              title: title == null ? null : Text(title),
              content: content == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(content),
                    ),
              actions: <Widget>[
                if (cancelOnPressed != null)
                  CupertinoDialogAction(
                    onPressed: cancelOnPressed,
                    child: Text(S.current.cancel),
                  ),
                if (confirmOnPressed != null)
                  CupertinoDialogAction(
                    onPressed: confirmOnPressed,
                    child: Text(
                      confirmText ?? S.current.confirm,
                      style: const TextStyle(color: ThemeColor.red),
                    ),
                  )
              ]));
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
    required VoidCallback? onConfirm,
    double? height}) {
  showDialog<bool>(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black38,
      barrierDismissible: true,
      builder: (_) => ToastTipsDialog(
            title: title,
            onConfirm: onConfirm,
            height: height,
          ));
}

void showCustomWidget({
  required BuildContext context,
  required Widget child,
}) {
  showDialog<bool>(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black38,
      barrierDismissible: true,
      builder: (_) => child);
}

showEdit(BuildContext context,
    {required String title,
    required ValueChanged? commitPressed,
    VoidCallback? cancelPressed,
    String? text}) {
  showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CupertinoTextField(
              controller: TextEditingController(text: text),
              onChanged: (value) {
                text = value;
              },
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                cancelPressed?.call();
                Navigator.pop(context);
              },
              child: Text(
                '取消',
                style: TextStyle(color: ThemeColor.blackLight),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                commitPressed?.call(text);
                Navigator.pop(context);
              },
              child: Text('确定'),
            ),
          ],
        );
      });
}

showSheet(BuildContext context, List<SheetButtonModel> list) {
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
                        e.onTap?.call();
                      },
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: MARGIN_MAIN),
                              child: e.icon,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(e.title,
                                style: e.textStyle ??
                                    themeTextStyle(fontSize: 16)),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (e.bottomLine)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: ThemeColor.background,
                      indent: MARGIN_MAIN,
                      endIndent: MARGIN_MAIN,
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
  final Function? onTap;
  final TextStyle? textStyle;
  final bool bottomLine;

  SheetButtonModel(
      {required this.title,
      this.onTap,
      this.icon,
      this.textStyle,
      this.bottomLine = true});
}
