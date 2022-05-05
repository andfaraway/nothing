//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-25 16:21:30
//
import 'package:flutter/material.dart';

const Color colorRedSelect = Color(0xFFE6333F);

const Color colorBackground = Color(0xFFF2F4F7);

Color colorDivider = const Color(0xFF010122).withOpacity(.06);

TextStyle themeTextStyle(
    {required double fontSize,
    Color? color = const Color(0xFF333333),
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
      fontWeight: FontWeight.normal, fontSize: fontSize, color: color);
}
