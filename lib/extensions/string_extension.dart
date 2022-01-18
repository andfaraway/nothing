import 'dart:convert';

import 'package:nothing/constants/constants.dart';

extension StringExtension on String {
  String get notBreak => replaceAll('', '\u{200B}');

  double toDouble() => double.parse(this);

  int toInt() => int.parse(this);

  Map? toMap() => json.decode(this);

  /// 根据时间戳格式化时间
  ///
  /// [format] 格式化方式
  String dataFormat(String? format) {
    late DateTime date;
    try {
      date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    } catch (error) {
      return '';
    }
    //format 不为空 返回格式化字符串
    if (format == null) {
      return DateFormat(format).format(date);
    }

    //format 为空，返回距离当前时间
    DateTime now = DateTime.now();
    int nowInt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int dateInt = toInt();
    int secondsValue = nowInt - dateInt;
    if (secondsValue < 60) {
      //1分钟内显示为“刚刚”
      return "刚刚";
    } else if ((secondsValue >= 60) && (secondsValue < 3600)) {
      //大于1分钟小于1小时显示为“n分钟前”
      return "${(secondsValue / 60).truncate()}分钟前";
    } else if ((secondsValue >= 60 * 60) && (secondsValue < 60 * 60 * 24)) {
      //大于1小时小于一天显示为“n小时前”
      return "${(secondsValue / 3600).truncate()}小时前";
    } else if ((secondsValue >= 86400) &&
        (secondsValue < (60 * 60 * 24 * 30))) {
      //大于1天小于30天显示为“n天前”
      return "${(secondsValue / 86400).toStringAsFixed(0)}天前";
    } else {
      //大于1月显示具体日期
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }
}
