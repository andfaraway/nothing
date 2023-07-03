//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-24 18:05:31
//
part of 'providers.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();

  int _pageIndex = 0;

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
}
