part of 'providers.dart';

class SettingsProvider extends ChangeNotifier with DiagnosticableTreeMixin {
  SettingsProvider() {
    // init();
  }

  bool _launchFromSystemBrowser = false;

  bool get launchFromSystemBrowser => _launchFromSystemBrowser;

  set launchFromSystemBrowser(bool value) {
    if (_launchFromSystemBrowser == value) {
      return;
    }
    _launchFromSystemBrowser = value;
    notifyListeners();
  }
}

