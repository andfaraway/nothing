import 'package:nothing/common/prefix_header.dart';

TextStyle get defaultTextStyle => TextStyle(
  fontSize: 28.sp,
      color: AppColor.errorColor,
      fontWeight: weightMedium,
      letterSpacing: 1.sp,
    );

class AppTheme {
  static ThemeData defaultThemeData = ThemeData(
    scaffoldBackgroundColor: AppColor.scaffoldBackgroundColor,
    primaryColor: AppColor.mainColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: AppOverlayStyle.dark,
      color: Colors.white,
      elevation: 3,
      centerTitle: true,
      titleSpacing: 0.0,
      shadowColor: AppColor.mainColor.withOpacity(.2),
      titleTextStyle: TextStyle(
          fontWeight: weightMedium,
          fontSize: AppColor.appBarTitleSize,
          color: AppColor.appBarTitleColor,
          fontFamily: AppTextStyle.fontFamily),
      iconTheme: IconThemeData(
        color: AppColor.mainColor,
      ),
      actionsIconTheme: IconThemeData(
        size: 24.0.w,
        color: AppColor.mainColor,
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: AppColor.tabBarTitleSelectedColor,
      labelStyle: TextStyle(
        fontSize: 20.0.sp,
      ),
      unselectedLabelColor: AppColor.tabBarTitleColor,
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
      selectedItemColor: AppColor.tabBarTitleSelectedColor,
      unselectedItemColor: AppColor.tabBarTitleColor,
      selectedLabelStyle: TextStyle(
        fontSize: AppColor.tabBarTitleSize,
        color: AppColor.tabBarTitleSelectedColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: AppColor.tabBarTitleSize,
        color: AppColor.tabBarTitleColor,
      ),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColor.mainColor,
    ),
    dividerTheme: DividerThemeData(
      thickness: 1.0,
      color: AppColor.dividerColor.withOpacity(0.7),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.mainColor,
    ),
    textTheme: const TextTheme(
            displayLarge: TextStyle(),
            displayMedium: TextStyle(),
            displaySmall: TextStyle(),
            headlineMedium: TextStyle(),
            headlineSmall: TextStyle(),
            titleLarge: TextStyle(),
            titleMedium: TextStyle(),
            titleSmall: TextStyle(),
            bodyLarge: TextStyle(),
            bodyMedium: TextStyle(),
            bodySmall: TextStyle(),
            labelLarge: TextStyle(),
            labelSmall: TextStyle())
        .apply(
      bodyColor: AppColor.mainColor,
      displayColor: AppColor.mainColor,
    ),
    fontFamily: AppTextStyle.fontFamily,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
  );
}

/*  theme textStyle */
FontWeight get weightRegular => FontWeight.w400;
FontWeight get weightMedium => FontWeight.w500;
FontWeight get weightBold => FontWeight.w700;

class TS {
  static TextStyle get m18c43 => TextStyle(
    fontSize: 18.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m17c43 => TextStyle(
    fontSize: 17.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m15c43 => TextStyle(
    fontSize: 15.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m15cb2 => TextStyle(
    fontSize: 15.sp,
        color: AppColor.secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m14c43 => TextStyle(
    fontSize: 14.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m14cb2 => TextStyle(
    fontSize: 14.sp,
        color: AppColor.secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get b13c43 => TextStyle(
    fontSize: 15.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m13cb2 => TextStyle(
    fontSize: 13.sp,
        color: AppColor.secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m13c43 => TextStyle(
    fontSize: 13.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m13cdc => TextStyle(
    fontSize: 13.sp,
        color: AppColor.disabledColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m11cb2 => TextStyle(
    fontSize: 11.sp,
        color: AppColor.secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m11c43 => TextStyle(
    fontSize: 11.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m12c43 => TextStyle(
    fontSize: 12.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m11cdc => TextStyle(
    fontSize: 11.sp,
        color: AppColor.placeholderColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m8c43 => TextStyle(
    fontSize: 8.sp,
        color: AppColor.mainColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );

  static TextStyle get m8cb2 => TextStyle(
    fontSize: 8.sp,
        color: AppColor.secondlyColor,
        fontWeight: weightMedium,
        letterSpacing: 1.sp,
      );
}
