//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-17 16:32:31
//
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/l10n.dart';

class ToastTipsDialog extends StatefulWidget {
  const ToastTipsDialog(
      {Key? key,
      required this.title,
      this.content,
      this.cancelLabel,
      this.confirmLabel,
      this.onCancel,
      this.onConfirm})
      : super(key: key);

  final String title;
  final String? content;
  final String? cancelLabel;
  final String? confirmLabel;

  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  _ToastTipsDialogState createState() => _ToastTipsDialogState();
}

class _ToastTipsDialogState extends State<ToastTipsDialog> {
  String? content;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.w)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 60.w, right: 60.w),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: const Color(0xFFE8E8E8),
                height: 1.h,
              ),
              SizedBox(
                height: 112.h,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: widget.onCancel ??
                            () {
                              Navigator.pop(context);
                            },
                        child: Text(
                          widget.cancelLabel ?? S.current.cancel,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 32.sp
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color(0xFFE8E8E8),
                      height: 60.h,
                      width: 1.w,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onConfirm?.call();
                        },
                        child: Text(
                          widget.confirmLabel ?? S.current.confirm,
                          style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 32.sp
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          width: 690.w,
          height: 294.h,
        ),
      ),
    );
  }
}
