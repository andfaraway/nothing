import 'package:flutter/services.dart';

import 'package:nothing/common/prefix_header.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  DefaultAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.style,
    this.titleSize,
    this.titleColor,
    this.titleWeight,
    this.bottom,
    this.backgroundColor,
    this.shadowColor,
    this.leading,
    this.actions,
    double? elevation,
    this.statusIsLight,
    this.flexibleSpace,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.isTransparent = false,
    this.showElevation = false,
  }) {
    if (showElevation) {
      this.elevation = elevation ?? .5;
    } else {
      this.elevation = elevation;
    }
  }

  final String? title;
  final Widget? titleWidget;
  final TextStyle? style;
  final double? titleSize;
  final Color? titleColor;
  final FontWeight? titleWeight;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Widget? leading;
  final List<Widget>? actions;
  late final double? elevation;
  final bool? statusIsLight;
  final Widget? flexibleSpace;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final bool isTransparent;
  final bool showElevation;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    bool canPop = parentRoute?.canPop ?? false;

    Widget? backBtn = leading;

    if (automaticallyImplyLeading == false) {
      backBtn = null;
    }

    return AppBar(
      backgroundColor: backgroundColor ?? (isTransparent ? Colors.transparent : AppColor.white),
      title: titleWidget ??
          Text(
            title ?? '',
            style: style ??
                TextStyle(
                  fontWeight: titleWeight ?? FontWeight.w600,
                  fontSize: titleSize ?? 18.sp,
                  color: titleColor,
                ),
          ),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: backBtn,
      bottom: bottom,
      actions: actions,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: statusIsLight == true ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      flexibleSpace: flexibleSpace,
      shadowColor: shadowColor ?? (showElevation ? const Color(0xFFDCDCE0) : Colors.transparent),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(54.w.toInt() + (bottom?.preferredSize.height ?? 0));
}
