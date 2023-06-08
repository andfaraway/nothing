//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-17 16:32:31
//

import '../../common/prefix_header.dart';

class ToastTipsDialog extends StatelessWidget {
  const ToastTipsDialog(
      {Key? key, required this.title, this.cancelLabel, this.confirmLabel, this.onCancel, this.onConfirm, this.height})
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
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.w)),
            // width: 690.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 25.w),
                  child: Text(
                    title,
                    style: AppTextStyle.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  color: const Color(0xFFE8E8E8),
                  height: 1.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: onCancel ??
                            () {
                              Navigator.pop(context);
                            },
                        child: Text(
                          cancelLabel ?? S.current.cancel,
                          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mainColor),
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
                          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.red),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.w)),
          // width: 690.w,
          // height: height ?? 294.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 60.w, right: 60.w),
                  child: Center(
                    child: Text(
                      title,
                      style: AppTextStyle.titleMedium,
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
                          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mainColor),
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
                          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.red),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
