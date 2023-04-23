//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-18 15:41:28
//
import 'package:nothing/constants/constants.dart';

class Singleton {
  Singleton._internal();

  factory Singleton() => _instance;

  static final Singleton _instance = Singleton._internal();

  late UserInfoModel _currentUser;

  UserInfoModel get currentUser {
    _currentUser =
        HiveBoxes.get(HiveKey.userInfo, defaultValue: UserInfoModel());
    return _currentUser;
  }

  set currentUser(UserInfoModel? user) {
    if (user == null) {
      return;
    }
    _currentUser = user;
    HiveBoxes.put(HiveKey.userInfo, user);
  }

  /// 页面是否加载完成
  static Map<dynamic, dynamic>? welcomeLoadResult;

  static cleanData() async {
    HiveBoxes.clearData();
  }
}


class Handler {
  static String? get accessToken =>
      'Bearer ${Singleton().currentUser.token}';

  static bool get isUserLogin {
    String? accessToken = Singleton().currentUser.token;
    return accessToken != null && accessToken.isNotEmpty;
  }

  static void userLogin() {}

  static void userLogout() {
    HiveBoxes.clearData();
    Singleton().currentUser = null;
  }
}