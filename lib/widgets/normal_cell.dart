//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-17 16:32:31
//

import 'package:nothing/common/prefix_header.dart';

class NormalCell extends StatelessWidget {
  const NormalCell(
      {Key? key,
      required this.title,
      this.height,
      this.suffixTitle,
      this.showSuffixIcon = true,
      this.suffixWidget,
      this.onTap,
      this.onLongPress,
      this.showDivider = true})
      : super(key: key);

  final String? title;
  final String? suffixTitle;
  final bool showSuffixIcon;
  final Widget? suffixWidget;
  final double? height;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.main.left),
      child: Column(
        children: [
          10.hSizedBox,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            onLongPress: onLongPress,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(title ?? '', style: AppTextStyle.titleMedium),
                ),
                ...getSuffixWidget()
              ],
            ),
          ),
          10.hSizedBox,
          if (showDivider)
            const Align(
                alignment: Alignment.bottomCenter,
                child: Divider(
                  height: 1,
                )),
        ],
      ),
    );
  }

  List<Widget> getSuffixWidget() {
    if (suffixWidget != null) {
      return [suffixWidget!];
    } else {
      return [
        if (suffixTitle != null)
          Text(
            suffixTitle!,
            style: TextStyle(
              color: const Color(0xFF999999),
              fontSize: 29.sp,
            ),
          ),
        if (showSuffixIcon)
          const Icon(
            Icons.keyboard_arrow_right,
            color: Color(0xFFC8C8C8),
          )
      ];
    }
  }
}
