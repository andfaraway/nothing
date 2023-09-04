import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../utils/log_utils.dart';

extension ObjectEx on dynamic {
  String? toJsonString() {
    try {
      return json.encode(this);
    } catch (e) {
      return null;
    }
  }

  bool objectIsEmpty() {
    if (this == null) {
      return true;
    }

    if (this is String || this is Map || this is Set || this is List) {
      return this.isEmpty;
    }

    return false;
  }
}

extension StringEx on String {
  Map<String, dynamic> toMap() {
    try {
      return json.decode(this);
    } catch (e) {
      Log.d('toJson error:$e');
      return {};
    }
  }

  double toDouble() => double.parse(this);

  int toInt() => int.parse(this);

  String getMd5() {
    Uint8List content = const Utf8Encoder().convert(this);
    Digest digest = md5.convert(content);
    return digest.toString();
  }

  Color? toColor() {
    RegExp exp = RegExp(r'^#([0-9A-Fa-f]{6})$');
    bool isValid = exp.hasMatch(this); // true
    if (!isValid) return null;
    return Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
  }

  /// 根据时间戳格式化时间
  ///
  /// [format] 不为空 返回格式化字符串; null，返回距离当前时间
  String dateFormat({String? format}) {
    late DateTime date;
    try {
      date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    } catch (error) {
      return '';
    }
    //format 不为空 返回格式化字符串
    if (format != null) {
      return DateFormat(format).format(date);
    }

    //format 为空，返回距离当前时间
    int nowInt = DateTime.now().millisecondsSinceEpoch;
    int dateInt = toInt();
    int secondsValue = nowInt - dateInt;
    //转换为秒计算
    secondsValue = secondsValue ~/ 1000;
    if (secondsValue < 60) {
      //1分钟内显示为“刚刚”
      return "刚刚";
    } else if ((secondsValue >= 60) && (secondsValue < 3600)) {
      //大于1分钟小于1小时显示为“n分钟前”
      return "${(secondsValue / 60).truncate()}分钟前";
    } else if ((secondsValue >= 60 * 60) && (secondsValue < 60 * 60 * 24)) {
      //大于1小时小于一天显示为“n小时前”
      return "${(secondsValue / 3600).truncate()}小时前";
    } else if ((secondsValue >= 86400) && (secondsValue < (60 * 60 * 24 * 30))) {
      //大于1天小于30天显示为“n天前”
      return "${(secondsValue / 86400).toStringAsFixed(0)}天前";
    } else {
      //大于1月显示具体日期
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }
}

extension DateTimeEx on DateTime {
  String format(String? format) {
    return DateFormat(format).format(this);
  }
}

extension MapExt<E, V> on Map<E, V> {
  Map<E, V> removeEmptyValue() =>
      this..removeWhere((key, value) => value == null || value == '' || value == [] || value == {});
}

extension IteratorExt<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test, {E Function()? orElse}) {
    for (E element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    return null;
  }
}
