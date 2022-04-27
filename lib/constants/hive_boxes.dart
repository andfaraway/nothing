//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-26 15:25:56
//

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/models.dart';
import '../utils/log_utils.dart';
import '../widgets/dialogs/confirmation_dialog.dart';

const String boxPrefix = 'nothing';

class HiveBoxes {
  const HiveBoxes._();

  static Future<void> init() async {
    await Hive.initFlutter();

    // if (!Hi.containsKey(currentUser.uid)) {
    //   await appBox.put(currentUser.uid, <int, List<AppMessage>>{});
    // }

    await openBoxes();
  }

  /// 启动页信息
  static late Box<dynamic> launchBox;

  /// 设置表
  static late Box<dynamic> settingsBox;

  static Future<void> openBoxes() async {
    Hive.registerAdapter(LaunchInfoAdapter());

    await Future.wait(
      <Future<void>>[
        () async {
          settingsBox =
              await Hive.openBox<dynamic>('${boxPrefix}_app_settings');
        }(),
        () async {
          launchBox = await Hive.openBox<dynamic>('${boxPrefix}_app_launch');
        }(),
      ],
    );
  }

  static Future<void> clearCacheBoxes(BuildContext context) async {
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
        await Future.wait<void>(<Future<dynamic>>[
          // coursesBox.clear(),
          // courseRemarkBox.clear(),
          // scoresBox.clear(),
          // startWeekBox.clear(),
        ]);
        LogUtils.d('Cache boxes cleared.');
        if (kReleaseMode) {
          SystemNavigator.pop();
        }
      }
    }
  }

  static Future<void> clearAllBoxes(BuildContext context) async {
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
        await Future.wait<void>(<Future<dynamic>>[
          launchBox.clear(),
          settingsBox.clear(),
        ]);
        LogUtils.d('Boxes cleared.');
        if (kReleaseMode) {
          SystemNavigator.pop();
        }
      }
    }
  }
}

class HiveAdapterTypeIds {
  const HiveAdapterTypeIds._();

  static const int launchInfo = 0;
  static const int message = 1;
  static const int course = 2;
  static const int score = 3;
  static const int webapp = 4;
  static const int changelog = 5;
  static const int emoji = 6;
  static const int up = 7;
}
