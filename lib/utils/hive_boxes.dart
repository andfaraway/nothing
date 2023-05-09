//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-26 15:25:56
//

import 'package:hive_flutter/adapters.dart';

import '../model/models.dart';

class HiveBoxes {
  const HiveBoxes._();

  static Future<void> init() async {
    await Hive.initFlutter();
    await openBoxes();
  }

  /// 启动页信息
  static late Box<dynamic> launchBox;

  /// 设置表
  static late Box<dynamic> settingsBox;

  /// 通用信息表(默认存储)
  static late Box<dynamic> _dataBox;

  static Future<void> openBoxes() async {
    Hive.registerAdapter(LaunchInfoAdapter());
    Hive.registerAdapter(UserInfoModelAdapter());

    const String boxPrefix = 'nothing';

    await Future.wait(
      <Future<void>>[
        () async {
          settingsBox = await Hive.openBox<dynamic>('${boxPrefix}_app_settings');
        }(),
        () async {
          launchBox = await Hive.openBox<dynamic>('${boxPrefix}_app_launch');
        }(),
        () async {
          _dataBox = await Hive.openBox<dynamic>('${boxPrefix}_data');
        }(),
      ],
    );
  }

  static Future<void> clearAll() async {
    await launchBox.clear();
    await settingsBox.clear();
    await _dataBox.clear();
  }

  static put(dynamic key, dynamic value) {
    _dataBox.put(key, value);
  }

  static dynamic get(dynamic key, {dynamic defaultValue}) {
    return _dataBox.get(key, defaultValue: defaultValue);
  }

  static delete(dynamic key) {
    _dataBox.delete(key);
  }

  static Future<int> clear() {
    return _dataBox.clear();
  }
}

class HiveAdapterTypeIds {
  const HiveAdapterTypeIds._();

  static const int launchInfo = 0;
  static const int userInfo = 1;
}

class HiveKey {
  const HiveKey._();

  static const String photoShowIndex = "photoShowIndex";

  static const String userInfo = 'userInfo';
  static const String hiToUser = 'hiToUser';
  static const String pushAlias = 'pushAlias';

  static const String filterColor = 'filterColor';

  /// 主题色
  static const String colorThemeIndex = 'colorThemeIndex';
}
