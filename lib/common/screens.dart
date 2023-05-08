import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screens {
  const Screens._();

  static MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  static double fixedFontSize(double fontSize) => fontSize / textScaleFactor;

  static double get scale => mediaQuery.devicePixelRatio;

  static double get width => mediaQuery.size.width;

  static int get widthPixels => (width * scale).toInt();

  static double get height => mediaQuery.size.height;

  static int get heightPixels => (height * scale).toInt();

  static double get aspectRatio => width / height;

  static double get textScaleFactor => mediaQuery.textScaleFactor;

  static double get navigationBarHeight => mediaQuery.padding.top + kToolbarHeight;

  static double get topSafeHeight => mediaQuery.padding.top;

  static double get bottomSafeHeight => mediaQuery.padding.bottom;

  static double get safeHeight => height - topSafeHeight - bottomSafeHeight;

  static void updateStatusBarStyle({required bool dark}) {
    SystemChrome.setSystemUIOverlayStyle(dark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light);
  }
}

class AppScreenUtilInit extends ScreenUtilInit {
  const AppScreenUtilInit({Key? key, required ScreenUtilInitBuilder builder})
      : super(key: key, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: true, builder: builder);
}

/// Screen capability method.
double suSetSp(double size, {double? scale}) => _sizeCapable(
      (ScreenUtil().setSp(size) * 2).toDouble(),
      scale: scale,
    );

double suSetWidth(double size, {double? scale}) =>
    _sizeCapable((ScreenUtil().setWidth(size) * 2).toDouble(), scale: scale);

double suSetHeight(double size, {double? scale}) =>
    _sizeCapable((ScreenUtil().setHeight(size) * 2).toDouble(), scale: scale);

double _sizeCapable(num size, {double? scale}) => (size * (scale ?? 1)).toDouble();

extension AppSizeExtension on num {
  double get w => ScreenUtil().setWidth(this);

  double get h => ScreenUtil().setHeight(this);

  double get r => ScreenUtil().radius(this);

  double get sp => ScreenUtil().setHeight(this);

  double get ssp => ScreenUtil().setSp(this);

  //高度间隔
  Widget get hSizedBox => SizedBox(height: ScreenUtil().setHeight(this).toDouble());

  //宽度间隔
  Widget get wSizedBox => SizedBox(width: ScreenUtil().setWidth(this).toDouble());

  //高度间隔
  Widget get hDivider => Divider(height: toDouble(), thickness: toDouble());
}

