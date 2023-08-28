import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:nothing/common/prefix_header.dart';

class AppColor {
  const AppColor._();

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF333333);

  static const Color blackLight = Color(0xFF989898);

  static const Color background = Color(0xFFF2F4F7);

  static const Color red = Color(0xFFE6333F);

  //  页面背景颜色
  static Color get scaffoldBackgroundColor => const Color(0xffF5F5F5);

//  页面主标题大小
  static double get appBarTitleSize => 18.0.sp;

//  页面主标题颜色
  static Color get appBarTitleColor => const Color(0xff343434);

//  底部tab字体大小
  static double get tabBarTitleSize => 10.0.sp;

//  底部tab字体颜色
  static Color get tabBarTitleColor => const Color(0xffB2B2B2);

//  底部tab字体选中颜色
  static Color get tabBarTitleSelectedColor => const Color(0xff434343);

//  描述文字大小
  static double get descTitleSize => 12.0.sp;

//  描述文字颜色
  static Color get descTitleColor => const Color(0xff959595);

//  占位提示文字颜色
  static Color get placeholderColor => const Color(0xffDCDCDC);

//  主文字颜色
  static Color get mainColor => const Color(0xff434343);

//  次文字颜色
  static Color get secondlyColor => const Color(0xffB2B2B2);

//  特殊颜色
  static Color get specialColor => const Color(0xff3476FE);

//  不可用颜色
  static Color get disabledColor => const Color(0xffDCDCDC);

//  分割线颜色
  static Color get dividerColor => const Color(0xffEEEEEE);

//  边框颜色
  static Color get borderColor => const Color(0xffEEEEEE);

//  滚动条颜色
  static Color get scrollBarColor => const Color(0xffD9D9D9);

//  输入框背景颜色
  static Color get searchBackgroundColor => const Color(0xffF8F8F8);

//  已完成颜色
  static Color get doneColor => const Color(0xffACD68E);

//  进行中颜色
  static Color get underwayColor => const Color(0xffF8CB7B);

//  错误颜色
  static Color get errorColor => const Color(0xffFF7575);

  static Color get tabColor => const Color(0xffeaffd0);

  static List<Color> get randomColors => const [
        Color(0xff95e1d3),
        Color(0xffeaffd0),
        Color(0xfffce38a),
        Color(0xfff38181),
      ];
}

/*  theme textStyle */
FontWeight get weightRegular => FontWeight.w400;

FontWeight get weightMedium => FontWeight.w500;

FontWeight get weightBold => FontWeight.w700;

class AppTextStyle {
  const AppTextStyle._();

  static const fontFamilyNameDefault = 'Default';

  static Future<bool> loadFont({
    required name,
  }) async {
    if (PathUtils.fontPath.objectIsEmpty()) return false;
    String path = '${PathUtils.fontPath}/$name';
    File file = File(path);
    if (!file.existsSync()) return false;
    Uint8List bytes = file.readAsBytesSync();
    loadFontFromList(bytes, fontFamily: name);
    return true;
  }

  static TextStyle get displayLarge => TextStyle(
        fontSize: 28.sp,
        color: AppColor.white,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get displayMedium => TextStyle(
        fontSize: 22.sp,
        color: AppColor.white,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get headLineMedium => TextStyle(
        fontSize: 18.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get titleMedium => TextStyle(
        fontSize: 15.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: 14.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 13.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get labelLarge => TextStyle(
        fontSize: 9.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );
}

extension TextStyleExtension on TextStyle {
  TextStyle get placeholderColor => copyWith(color: AppColor.placeholderColor);
}

class AppSize {
  const AppSize._();

  static double get screenWidth => Screens.width;

  static double get screenHeight => Screens.height;

  static double get cellHeight => 44.h;

  static double get radiusLarge => 10.r;

  static double get radiusMedium => 7.r;
}

class AppPadding {
  AppPadding._();

  static EdgeInsets get main => EdgeInsets.symmetric(horizontal: 17.w, vertical: 17.h);

  static EdgeInsets get cell => EdgeInsets.symmetric(horizontal: 17.w, vertical: 12.h);

  static double get horizontal => 17;

  static double get vertical => 17;
}

class AppOverlayStyle {
  static SystemUiOverlayStyle light = Constants.isWeb
      ? const SystemUiOverlayStyle()
      : SystemUiOverlayStyle(
    systemNavigationBarColor: Constants.isIOS ? Colors.black : null,
          systemNavigationBarDividerColor: null,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Constants.isIOS ? Brightness.dark : null,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        );

  static SystemUiOverlayStyle dark = Constants.isWeb
      ? const SystemUiOverlayStyle()
      : SystemUiOverlayStyle(
    systemNavigationBarColor: Constants.isIOS ? Colors.white : null,
          systemNavigationBarDividerColor: null,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Constants.isIOS ? Brightness.light : null,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        );
}
