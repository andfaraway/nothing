//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-25 16:21:30
//
import 'package:nothing/public.dart';

const Color colorBlackDefault = Color(0xFF333333);

const Color colorBlackDefaultLight = Color(0xFF989898);

const Color colorBackground = Color(0xFFF2F4F7);

const Color themeColorRed = Color(0xFFE6333F);

Color colorDivider = const Color(0xFF010122).withOpacity(.06);

TextStyle themeTextStyle(
    {required double fontSize,
    Color? color = const Color(0xFF333333),
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
      fontWeight: FontWeight.normal, fontSize: fontSize, color: color);
}

TextStyle textStyleTitle(){
  return TextStyle(
    color: colorBlackDefault,
    fontSize: 32.sp
  );
}
