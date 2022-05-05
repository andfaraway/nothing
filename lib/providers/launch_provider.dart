//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-26 18:35:11
//
part of 'providers.dart';

class LaunchProvider extends ChangeNotifier {
  final String launchKey = 'launchKey';

  LaunchProvider() {
    if (HiveBoxes.launchBox.containsKey(launchKey)) {
      _launchInfo = HiveBoxes.launchBox.get(launchKey);
    }
  }

  LaunchInfo? _launchInfo;

  LaunchInfo? get launchInfo => _launchInfo;

  set launchInfo(LaunchInfo? value) {
    if (_launchInfo == value) {
      return;
    }
    _launchInfo = value;
    notifyListeners();
  }

  update() {
    notifyListeners();
  }

  Future<void> updateHives() async {
    await HiveBoxes.launchBox.put(launchKey, _launchInfo);
  }
}
