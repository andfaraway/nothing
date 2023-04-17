import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens.dart';

Color get scaffoldBackgroundColor => const Color(0xffF5F5F5);

double get appBarTitleSize => 18.0.sp;

Color get appBarTitleColor => const Color(0xff343434);

double get tabBarTitleSize => 10.0.sp;

Color get tabBarTitleColor => const Color(0xffB2B2B2);

Color get tabBarTitleSelectedColor => const Color(0xff434343);

double get descTitleSize => 12.0.sp;

Color get descTitleColor => const Color(0xff959595);

double get placeholderSize => 14.0.sp;

Color get placeholderColor => const Color(0xffDCDCDC);

Color get mainColor => const Color(0xff434343);

Color get secondlyColor => const Color(0xffB2B2B2);

Color get specialColor => const Color(0xff5459FA);

Color get disabledColor => const Color(0xffDCDCDC);

Color get borderColor => const Color(0xffEEEEEE);

Color get scrollBarColor => const Color(0xffD9D9D9);

Color get searchBackgroundColor => const Color(0xffF8F8F8);

Color get buttonColorBlue => const Color(0xff5459FA);

Color get activateColor => const Color(0xffACD68E);

class AppTheme {
  static ThemeData defaultThemeData = ThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: OverlayStyle.dark,
      color: Colors.white,
      elevation: 0.5,
      centerTitle: true,
      titleSpacing: 0.0,
      iconTheme: IconThemeData(
        color: mainColor,
      ),
      actionsIconTheme: IconThemeData(
        size: 24.0.r,
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
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
  );
}

class OverlayStyle {
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

FontWeight get weightBold => FontWeight.bold;

class TS {
  static TextStyle get m18c43 => TextStyle(
        fontSize: 18.sp,
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


