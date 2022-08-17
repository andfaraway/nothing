//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-25 16:21:30
//
import 'package:nothing/public.dart';

class ThemeColor {
  static const Color black = Color(0xFF333333);

  static const Color blackLight = Color(0xFF989898);

  static const Color background = Color(0xFFF2F4F7);

  static const Color red = Color(0xFFE6333F);
}

Color colorDivider = const Color(0xFF010122).withOpacity(.06);

TextStyle themeTextStyle(
    {double? fontSize,
    Color? color = const Color(0xFF333333),
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
      fontWeight: FontWeight.normal, fontSize: fontSize ?? 32.sp, color: color);
}
