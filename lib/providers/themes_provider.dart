part of 'providers.dart';

class ThemesProvider with ChangeNotifier {
  ThemesProvider() {
    initTheme();
  }

  /// 滤镜颜色
  Color _filterColor = Colors.transparent;

  Color get filterColor => _filterColor;

  set filterColor(Color value) {
    if (_filterColor == value) {
      return;
    }
    _filterColor = value;
    HiveBoxes.put(HiveKey.filterColor, value);
    notifyListeners();
  }

  ThemeGroup _currentThemeGroup = defaultThemeGroup;

  ThemeGroup get currentThemeGroup => _currentThemeGroup;

  set currentThemeGroup(ThemeGroup value) {
    if (_currentThemeGroup == value) {
      return;
    }
    _currentThemeGroup = value;
    notifyListeners();
  }

  String? _fontFamily;

  String? get fontFamily => _fontFamily;

  set fontFamily(String? value) {
    if (_fontFamily == value) {
      return;
    }
    _fontFamily = value;
    if (value == null) {
      HiveBoxes.delete(HiveKey.fontFamily);
    } else {
      HiveBoxes.put(HiveKey.fontFamily, value);
    }
    notifyListeners();
  }

  bool _dark = false;

  bool get dark => _dark;

  set dark(bool value) {
    if (_dark == value) {
      return;
    }
    // HiveFieldUtils.setBrightnessDark(value);
    _dark = value;
    notifyListeners();
  }

  Color _informationBgColor = Colors.white;

  Color get informationBgColor => _informationBgColor;

  set informationBgColor(Color value) {
    if (_informationBgColor == value) {
      return;
    }
    _informationBgColor = value;
    HiveFieldUtils.setInformationBgColor(value.value);
    notifyListeners();
  }

  Future<void> initTheme() async {
    int themeIndex = HiveBoxes.get(HiveKey.colorThemeIndex, defaultValue: 0);
    if (themeIndex >= supportThemeGroups.length) {
      HiveBoxes.put(HiveKey.colorThemeIndex, 0);
      themeIndex = 0;
    }
    _currentThemeGroup = supportThemeGroups[themeIndex];
    _dark = HiveFieldUtils.getBrightnessDark();

    _informationBgColor = Color(HiveFieldUtils.getInformationBgColor());
    _filterColor = HiveBoxes.get(HiveKey.filterColor, defaultValue: Colors.transparent);
    _fontFamily = HiveBoxes.get(HiveKey.fontFamily);

    if (await AppTextStyle.loadFont(name: _fontFamily) == false) {
      _fontFamily = null;
    }
  }

  void resetTheme() {}

  void updateThemeColor(int themeIndex) {
    HiveFieldUtils.setColorTheme(themeIndex);
    _currentThemeGroup = supportThemeGroups[themeIndex];
    notifyListeners();
    showToast('已更换主题色');
  }

  void setSystemUIDark(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  ThemeData get _lightThemeData {
    return defaultThemeData.copyWith(
        primaryColor: _currentThemeGroup.lightThemeColor,
        appBarTheme: defaultThemeData.appBarTheme.copyWith(backgroundColor: _currentThemeGroup.lightThemeColor));
  }

  ThemeData get _darkThemeData => defaultThemeData.copyWith(
        primaryColor: _currentThemeGroup.darkThemeColor,
        appBarTheme: defaultThemeData.appBarTheme.copyWith(backgroundColor: _currentThemeGroup.darkThemeColor),
      );

  ThemeData get currentThemeData => dark ? _darkThemeData : _lightThemeData;

  ThemeData get defaultThemeData => ThemeData(
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
              fontFamily: _fontFamily),
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
          cursorColor: AppColor.errorColor,
        ),
        textTheme: const TextTheme(),
        fontFamily: fontFamily,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      );
}

const List<ThemeGroup> supportThemeGroups = <ThemeGroup>[
  defaultThemeGroup,
  ThemeGroup(lightThemeColor: Color(0xfff06292), darkThemeColor: Color(0xffcc537c), name: '基佬粉'),
  ThemeGroup(lightThemeColor: Color(0xffba68c8), darkThemeColor: Color(0xff9e58aa), name: '魅力紫'),
  ThemeGroup(lightThemeColor: Color(0xff2196f3), darkThemeColor: Color(0xff1c7ece), name: '远峰蓝'),
  ThemeGroup(lightThemeColor: Color(0xff00bcd4), darkThemeColor: Color(0xff00a0b4), name: '铁青'),
  ThemeGroup(lightThemeColor: Color(0xFF4CAF50), darkThemeColor: Color(0xff208d83), name: '海藻绿'),
  ThemeGroup(lightThemeColor: Color(0xffffeb3b), darkThemeColor: Color(0xffd9c832), name: '香蕉黄'),
  ThemeGroup(lightThemeColor: Color(0xffff7043), darkThemeColor: Color(0xffd95f39), name: '活力橙'),
];
