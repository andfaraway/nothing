//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-17 16:32:31
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/public.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  VoidCallback? confirmOnPressed}
) {
  showDialog<bool>(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black38,
      barrierDismissible: true,
      builder: (_) => CupertinoAlertDialog(
              title: title == null ? null : Text(title),
              content: content == null ? null : Padding(
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
                    child: Text(confirmText ?? S.current.confirm,style: const
                    TextStyle
                      (color:themeColorRed),),
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
                        if (e.onTap != null) {
                          e.onTap();
                        }
                      },
                      child: Stack(
                        children: [
                          Align(
                            child: Padding(
                              padding: const EdgeInsets.only(left: MARGIN_MAIN),
                              child: e.icon,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Align(
                            child: Text(e.title,
                                style: e.textStyle ??
                                    themeTextStyle(fontSize: 16)),
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: colorBackground,
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
  final Function onTap;
  final TextStyle? textStyle;

  SheetButtonModel(
      {required this.title, required this.onTap, this.icon, this.textStyle});
}
