import 'package:nothing/common/prefix_header.dart';

class AppButton {
  AppButton._();

  static Widget customButton({
    double? width,
    double? height,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    BorderSide? side,
    OutlinedBorder? shape,
    Color? shadowColor,
    Color? overlayColor,
    double? elevation,
    Widget? child,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            Size(0.0, height ?? 0.0),
          ),
          padding: MaterialStateProperty.all(
            padding ?? EdgeInsets.zero,
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(),
          ),
          backgroundColor: MaterialStateProperty.all(
            backgroundColor,
          ),
          overlayColor: MaterialStateProperty.all(
            overlayColor ?? Colors.transparent,
          ),
          side: MaterialStateProperty.all(
            side,
          ),
          shape: MaterialStateProperty.all(
            shape,
          ),
          shadowColor: MaterialStateProperty.all(
            shadowColor,
          ),
          elevation: MaterialStateProperty.all(
            elevation,
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onTap,
        child: child ?? Container(),
      ),
    );
  }

  static Widget button({
    double? width,
    double? height,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    Color? borderColor,
    double? borderWidth,
    bool isStadiumBorder = false,
    double? radius,
    Color? shadowColor,
    Color? overlayColor,
    double? elevation,
    Widget? child,
    VoidCallback? onTap,
  }) {
    return customButton(
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      padding: padding,
      side: borderColor != null
          ? BorderSide(
              color: borderColor,
              width: borderWidth ?? 1.0,
            )
          : null,
      shape: isStadiumBorder
          ? const StadiumBorder()
          : radius != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                )
              : null,
      shadowColor: shadowColor,
      overlayColor: overlayColor,
      elevation: elevation,
      child: child,
      onTap: onTap,
    );
  }

  static Widget closeButton({
    EdgeInsetsGeometry? padding,
    Color? color,
    VoidCallback? onTap,
  }) {
    return button(
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 12.0.w,
              vertical: 6.0.h,
            ),
        child: AppImage.asset(
          R.iconsClose,
          width: 24.0.w,
          height: 24.0.w,
          color: color,
        ),
      ),
      onTap: onTap ??
          () {
            Navigator.maybeOf(currentContext)?.maybePop();
          },
    );
  }

  static Widget backButton({
    EdgeInsetsGeometry? padding,
    Color? color,
    VoidCallback? onTap,
  }) {
    return button(
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 12.0.w,
              vertical: 6.0.h,
            ),
        child: AppImage.asset(
          R.iconsBtnBack,
          width: 24.0.w,
          height: 24.0.w,
          color: color,
        ),
      ),
      onTap: onTap ??
          () {
            Navigator.maybeOf(currentContext)?.maybePop();
          },
    );
  }
}
