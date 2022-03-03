import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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


