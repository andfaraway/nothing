///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/8/21 16:29
///

part of 'models.dart';


class ThemeGroup {
  const ThemeGroup({
    this.lightThemeColor = Colors.white,
    this.lightPrimaryColor = Colors.white,
    this.lightBackgroundColor = const Color(0xfff7f7f7),
    this.lightTabBarIconColor = const Color(0xffc4c4c4),
    this.lightTabBarIconSelectedColor = const Color(0xffc4c4c4),
    this.lightDividerColor = const Color(0xffeaeaea),
    this.lightPrimaryTextColor = const Color(0xff212121),
    this.lightSecondaryTextColor = const Color(0xff757575),
    this.lightButtonTextColor = Colors.white,
    this.darkThemeColor = Colors.black,
    this.darkPrimaryColor = const Color(0xff212121),
    this.darkBackgroundColor = const Color(0xff151515),
    this.darkTabBarIconColor = const Color(0xffc4c4c4),
    this.darkTabBarIconSelectedColor = const Color(0xffc4c4c4),
    this.darkDividerColor = const Color(0xff313131),
    this.darkPrimaryTextColor = const Color(0xffb4b4b6),
    this.darkSecondaryTextColor = const Color(0xff878787),
    this.darkButtonTextColor = Colors.white,
    this.name = '纯白',
  });

  final Color lightThemeColor;
  final Color lightPrimaryColor;
  final Color lightBackgroundColor;
  final Color lightTabBarIconColor;
  final Color lightTabBarIconSelectedColor;
  final Color lightDividerColor;
  final Color lightPrimaryTextColor;
  final Color lightSecondaryTextColor;
  final Color? lightButtonTextColor;

  final Color darkThemeColor;
  final Color darkPrimaryColor;
  final Color darkBackgroundColor;
  final Color darkTabBarIconColor;
  final Color darkTabBarIconSelectedColor;
  final Color darkDividerColor;
  final Color darkPrimaryTextColor;
  final Color darkSecondaryTextColor;
  final Color darkButtonTextColor;

  final String name;

  Color get themeColor => Constants.isDark ? darkThemeColor : lightThemeColor;
}

const ThemeGroup defaultThemeGroup = ThemeGroup();
