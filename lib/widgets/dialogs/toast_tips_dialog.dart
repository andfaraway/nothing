//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-17 16:32:31
//

import '/public.dart';

class ToastTipsDialog extends StatelessWidget {
  const ToastTipsDialog(
      {Key? key,
        required this.title,
        this.cancelLabel,
        this.confirmLabel,
        this.onCancel,
        this.onConfirm,
        this.height})
      : super(key: key);

  final String title;
  final String? cancelLabel;
  final String? confirmLabel;

  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final double? height;

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
                      title,
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
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
                        onPressed: onCancel ??
                                () {
                              Navigator.pop(context);
                            },
                        child: Text(
                          cancelLabel ?? S.current.cancel,
                          style: TextStyle(
                              color: const Color(0xFF1578FE),
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
                          onConfirm?.call();
                        },
                        child: Text(
                          confirmLabel ?? S.current.confirm,
                          style: TextStyle(
                              color: themeColorRed,
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
          height: height ?? 294.h,
        ),
      ),
    );
  }
}
