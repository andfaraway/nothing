/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2019-12-01 19:34
///
import 'package:hive/hive.dart';

const String boxPrefix = 'openjmu';

class HiveBoxes {
  const HiveBoxes._();

  /// 应用消息表
  static Box<Map<dynamic, dynamic>>? appMessagesBox;

  /// 私聊消息表
  static Box<Map<dynamic, dynamic>>? personalMessagesBox;

  /// 课程缓存表
  static Box<Map<dynamic, dynamic>>? coursesBox;

  /// 课表备注表
  static Box<String>? courseRemarkBox;

  /// 学期开始日缓存表
  static Box<DateTime>? startWeekBox;

  /// 成绩缓存表
  static Box<Map<dynamic, dynamic>>? scoresBox;

  /// 应用中心应用缓存表
  static Box<List<dynamic>>? webAppsBox;

  /// 最近使用的应用缓存表
  static Box<List<dynamic>>? webAppsCommonBox;

  /// 举报去重池
  static Box<List<dynamic>>? reportRecordBox;

  /// 设置表
  static Box<dynamic>? settingsBox;

  /// 设置表
  static Box<bool>? firstOpenBox;

  /// 最近表情表
  static Box<List<dynamic>>? emojisBox;


}

class HiveAdapterTypeIds {
  const HiveAdapterTypeIds._();

  static const int appMessage = 0;
  static const int message = 1;
  static const int course = 2;
  static const int score = 3;
  static const int webapp = 4;
  static const int changelog = 5;
  static const int emoji = 6;
  static const int up = 7;
}
