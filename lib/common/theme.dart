import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//  页面背景颜色
Color get scaffoldBackgroundColor => const Color(0xffF5F5F5);
//  页面主标题大小
double get appBarTitleSize => 18.0.sp;
//  页面主标题颜色
Color get appBarTitleColor => const Color(0xff343434);

//  底部tab字体大小
double get tabBarTitleSize => 10.0.sp;
//  底部tab字体颜色
Color get tabBarTitleColor => const Color(0xffB2B2B2);
//  底部tab字体选中颜色
Color get tabBarTitleSelectedColor => const Color(0xff434343);

//  描述文字大小
double get descTitleSize => 12.0.sp;
//  描述文字颜色
Color get descTitleColor => const Color(0xff959595);

//  占位提示文字大小
double get placeholderSize => 14.0.sp;
//  占位提示文字颜色
Color get placeholderColor => const Color(0xffDCDCDC);

//  主文字颜色
Color get mainColor => const Color(0xff434343);
//  次文字颜色
Color get secondlyColor => const Color(0xffB2B2B2);
//  特殊颜色
Color get specialColor => const Color(0xff3476FE);

//  不可用颜色
Color get disabledColor => const Color(0xffDCDCDC);
//  分割线颜色
Color get dividerColor => const Color(0xffEEEEEE);
//  边框颜色
Color get borderColor => const Color(0xffEEEEEE);
//  滚动条颜色
Color get scrollBarColor => const Color(0xffD9D9D9);
//  输入框背景颜色
Color get searchBackgroundColor => const Color(0xffF8F8F8);
//  已完成颜色
Color get doneColor => const Color(0xffACD68E);
//  进行中颜色
Color get underwayColor => const Color(0xffF8CB7B);
//  错误颜色
Color get errorColor => const Color(0xffFF7575);

class AppTheme {
  static ThemeData defaultThemeData = ThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    primaryColor: specialColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: YBJFOverlayStyle.dark,
      color: Colors.white,
      elevation: 0.5,
      centerTitle: true,
      titleSpacing: 0.0,
      titleTextStyle: TextStyle(
        fontWeight: weightMedium,
        fontSize: appBarTitleSize,
        color: appBarTitleColor,
      ),
      iconTheme: IconThemeData(
        color: mainColor,
      ),
      actionsIconTheme: IconThemeData(
        size: 24.0.w,
        color: mainColor,
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: tabBarTitleSelectedColor,
      labelStyle: TextStyle(
        fontSize: 20.0.sp,
      ),
      unselectedLabelColor: tabBarTitleColor,
      unselectedLabelStyle: TextStyle(
        fontSize: 17.0.sp,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 4.0,
      selectedIconTheme: IconThemeData(
        size: 28.0.sp,
      ),
      unselectedIconTheme: IconThemeData(
        size: 28.0.sp,
      ),
      selectedItemColor: tabBarTitleSelectedColor,
      unselectedItemColor: tabBarTitleColor,
      selectedLabelStyle: TextStyle(
        fontSize: tabBarTitleSize,
        color: tabBarTitleSelectedColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: tabBarTitleSize,
        color: tabBarTitleColor,
      ),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: specialColor,
    ),
    dividerTheme: DividerThemeData(
      thickness: 1.0,
      color: dividerColor.withOpacity(0.7),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: specialColor,
    ),
    fontFamily: 'SourceHanSansCN',
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
  );
}

class YBJFOverlayStyle {
  static SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Platform.isAndroid ? null : Colors.black,
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness:
        Platform.isAndroid ? null : Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: Platform.isAndroid ? null : Colors.white,
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness:
        Platform.isAndroid ? null : Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
}

/*  theme textStyle */
FontWeight get weightRegular => FontWeight.w400;
FontWeight get weightMedium => FontWeight.w500;
FontWeight get weightBold => FontWeight.w700;

class TS {
  static TextStyle get m18c43 => TextStyle(
        fontSize: 18.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m17c43 => TextStyle(
        fontSize: 17.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m15c43 => TextStyle(
        fontSize: 15.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m15cb2 => TextStyle(
        fontSize: 15.sp,
        color: secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m14c43 => TextStyle(
        fontSize: 14.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m14cb2 => TextStyle(
        fontSize: 14.sp,
        color: secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get b13c43 => TextStyle(
        fontSize: 15.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m13cb2 => TextStyle(
        fontSize: 13.sp,
        color: secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m13c43 => TextStyle(
        fontSize: 13.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m13cdc => TextStyle(
        fontSize: 13.sp,
        color: disabledColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m11cb2 => TextStyle(
        fontSize: 11.sp,
        color: secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m11c43 => TextStyle(
        fontSize: 11.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m12c43 => TextStyle(
        fontSize: 12.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m11cdc => TextStyle(
        fontSize: 11.sp,
        color: placeholderColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m8c43 => TextStyle(
        fontSize: 8.sp,
        color: mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m8cb2 => TextStyle(
        fontSize: 8.sp,
        color: secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );
}
