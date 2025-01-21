//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-24 18:05:31
//
part of 'providers.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();

  List<BarItem> get rootBars => [
        BarItem(
          icon: const Icon(Icons.home),
          activeIcon: const Icon(Icons.home),
          label: '资讯',
          page: AppRoute.home.page.call(),
          selectedColor: Colors.purple,
        ),
        // if (Singleton().currentUser.showLove)
        //   BarItem(
        //     icon: const Icon(Icons.mail_outline),
        //     activeIcon: AppImage.asset(R.tabMail, color: AppColor.errorColor, fit: BoxFit.contain),
        //     label: '信息',
        //     page: AppRoute.message.page.call(),
        //     selectedColor: Colors.pinkAccent,
        //   ),
        BarItem(
          icon: const Icon(Icons.music_note),
          activeIcon: const Icon(Icons.music_note),
          label: 'music',
          page: AppRoute.musicPage.page.call(),
          selectedColor: Colors.cyan,
        ),
        BarItem(
            icon: const Icon(Icons.person),
            activeIcon: const Icon(Icons.person),
            label: '我的',
            page: AppRoute.profile.page.call(),
            selectedColor: Colors.teal),
      ];

  int _pageIndex = 0;

  bool _showFunny = true;

  bool get showFunny => _showFunny;

  set showFunny(bool value) {
    if (_showFunny == value) {
      return;
    }
    _showFunny = value;
    notifyListeners();
  }

  int get pageIndex => _pageIndex;

  set pageIndex(int value) {
    if (_pageIndex == value) {
      return;
    }
    _pageIndex = value;
    notifyListeners();
  }

  String _drawerTitle = '';

  String get drawerTitle => _drawerTitle;

  set drawerTitle(String value) {
    if (_drawerTitle == value) {
      return;
    }
    _drawerTitle = value;
    notifyListeners();
  }

  Map<String, dynamic> _drawerContent = {};

  Map<String, dynamic> get drawerContent => _drawerContent;

  set drawerContent(Map<String, dynamic> value) {
    if (_drawerContent == value) {
      return;
    }
    _drawerContent = value;
    notifyListeners();
  }

  List<SettingConfigModel> _drawerSettings = [];

  List<SettingConfigModel> get drawerSettings => _drawerSettings;

  set drawerSettings(List<SettingConfigModel> value) {
    if (_drawerSettings == value) {
      return;
    }
    _drawerSettings = value;
    notifyListeners();
  }

  ActionType? actionType;
}
