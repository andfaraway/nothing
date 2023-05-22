//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-24 18:05:31
//
part of 'providers.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();

  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  set pageIndex(int index) {
    if (_pageIndex == index) {
      return;
    }
    _pageIndex = index;
    notifyListeners();
  }
}
