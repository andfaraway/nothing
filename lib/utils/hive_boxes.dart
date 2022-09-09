//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-26 15:25:56
//

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/models.dart';
import 'log_utils.dart';
import '../widgets/dialogs/confirmation_dialog.dart';

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
          settingsBox =
              await Hive.openBox<dynamic>('${boxPrefix}_app_settings');
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

  static Future<void> _clearCacheBoxes(BuildContext context) async {
    if (await ConfirmationDialog.show(
      context,
      title: '清除缓存数据',
      showConfirm: true,
      content: '即将清除包括课程信息、成绩和学期起始日等缓存数据。请确认操作',
    )) {
      if (await ConfirmationDialog.show(
        context,
        title: '确认清除缓存数据',
        showConfirm: true,
        content: '清除的数据无法恢复，请确认操作',
      )) {
        LogUtils.d('Clearing Hive Cache Boxes...');
        await clearData();
        LogUtils.d('Cache boxes cleared.');
        if (kReleaseMode) {
          SystemNavigator.pop();
        }
      }
    }
  }

  static Future<void> _clearAllBoxes(BuildContext context) async {
    if (await ConfirmationDialog.show(
      context,
      title: '重置应用',
      showConfirm: true,
      content: '即将清除所有应用内容（包括设置、应用信息），请确认操作',
    )) {
      if (await ConfirmationDialog.show(
        context,
        title: '确认重置应用',
        showConfirm: true,
        content: '清除的内容无法恢复，请确认操作',
      )) {
        LogUtils.d('Clearing Hive Boxes...');
        await clearData();
        LogUtils.d('Boxes cleared.');
        if (kReleaseMode) {
          SystemNavigator.pop();
        }
      }
    }
  }

  static Future<void> clearData()async {
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

  static const String photoSetting = "photoSetting";
  static const String photoShowIndex = "photoShowIndex";

  static const String userInfo = 'userInfo';
  static const String hiToUser = 'hiToUser';
  static const String pushAlias = 'pushAlias';
}
