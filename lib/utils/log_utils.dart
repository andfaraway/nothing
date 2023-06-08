import 'dart:convert';
import 'dart:developer' as dev;

import 'package:logging/logging.dart';
import 'package:nothing/constants/constants.dart' show DateFormat, currentTime, currentTimeStamp;

class Log {
  const Log._();

  static const String _TAG = 'LOG';

  static void i(dynamic message, {String tag = _TAG, StackTrace? stackTrace}) {
    _printLog(message, '$tag ❕', stackTrace, level: Level.CONFIG);
  }

  static void d(dynamic message, {String tag = _TAG, StackTrace? stackTrace}) {
    _printLog(message, '$tag 📣', stackTrace, level: Level.INFO);
  }

  static void n(dynamic message, {String tag = 'network', StackTrace? stackTrace}) {
    _printLog(message, '🌐 $tag', stackTrace, level: Level.INFO);
  }

  static void w(dynamic message, {String tag = _TAG, StackTrace? stackTrace}) {
    _printLog(message, '$tag ⚠️', stackTrace, level: Level.WARNING);
  }

  static void e(
    dynamic message, {
    String tag = _TAG,
    StackTrace? stackTrace,
    bool withStackTrace = true,
  }) {
    _printLog(
      message,
      '$tag ❌',
      stackTrace,
      isError: true,
      level: Level.SEVERE,
      withStackTrace: withStackTrace,
    );
  }

  static void _printLog(
    dynamic message,
    String? tag,
    StackTrace? stackTrace, {
    bool isError = false,
    Level level = Level.ALL,
    bool withStackTrace = true,
  }) {
    if (isError) {
      dev.log(
        '${DateFormat('[HH:mm:ss]').format(currentTime)} - An error occurred.',
        time: currentTime,
        name: tag ?? _TAG,
        level: level.value,
        error: message,
        stackTrace: stackTrace ?? (isError && withStackTrace ? StackTrace.current : null),
      );
    } else {
      dev.log(
        '${DateFormat('[HH:mm:ss]').format(currentTime)} - ${_messageFormat(message)}',
        time: currentTime,
        name: tag ?? _TAG,
        level: level.value,
        stackTrace: stackTrace ?? (isError && withStackTrace ? StackTrace.current : null),
      );
    }
  }

  /// 格式化输出 message
  static dynamic _messageFormat(dynamic message) {
    if (_isSerializable(message)) {
      return const JsonEncoder.withIndent(' ').convert(message);
    } else {
      try {
        return json.encode(message);
      } catch (e) {
        return message;
      }
    }
  }

  // 定义一个函数，接收一个对象作为参数，返回一个布尔值
  static bool _isSerializable(dynamic object) {
    // 如果对象是数字、布尔值、字符串、空值、列表或映射，那么返回true
    if (object is num || object is bool || object is String || object == null || object is List || object is Map) {
      return true;
    }
    try {
      object.tojson();
      return true;
    } on NoSuchMethodError {
      return false;
      // do nothing
    }
  }
}
