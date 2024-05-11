import 'dart:convert';
import 'dart:developer' as dev;

import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class Log {
  static DateTime get currentTime => DateTime.now();

  static bool apiLogOpen = true;

  const Log._();

  static const String _TAG = 'LOG';

  static void i(dynamic message, {String tag = _TAG, StackTrace? stackTrace}) {
    _printLog(message, '$tag ❕', stackTrace, level: Level.CONFIG);
  }

  static void d(dynamic message, {String tag = _TAG, StackTrace? stackTrace}) {
    _printLog(message, '$tag 📣', stackTrace, level: Level.INFO);
  }

  static void n(dynamic message, {String tag = 'network', StackTrace? stackTrace}) {
    if (apiLogOpen) {
      if (message != null) {
        try {
          if (message.isEmpty) {
            return;
          }
        } catch (_) {}
      } else {
        return;
      }
      _printLog(message, '🌐 $tag', stackTrace, level: Level.SHOUT, format: true);
    }
  }

  static void w(dynamic message, {String tag = _TAG, StackTrace? stackTrace}) {
    _printLog(message, '$tag ⚠️', stackTrace, level: Level.WARNING);
  }

  static void e(dynamic message, {
    String tag = _TAG,
    StackTrace? stackTrace,
    bool withStackTrace = true,
    bool isError = true,
  }) {
    _printLog(
      message,
      '$tag ❌',
      stackTrace,
      isError: isError,
      level: Level.SEVERE,
      withStackTrace: withStackTrace,
    );
  }

  static void _printLog(dynamic message,
      String? tag,
      StackTrace? stackTrace, {
        bool isError = false,
        bool format = true,
        Level level = Level.ALL,
        bool withStackTrace = true,
      }) {
    if (isError) {
      dev.log(
        '${DateFormat('[HH:mm:ss]').format(currentTime)} ${format ? _messageFormat(message) : message}',
        time: currentTime,
        name: tag ?? _TAG,
        level: level.value,
        stackTrace: stackTrace ?? (isError && withStackTrace ? StackTrace.current : null),
      );
    } else {
      dev.log(
        '${DateFormat('[HH:mm:ss]').format(currentTime)} ${format ? _messageFormat(message) : message}',
        time: currentTime,
        name: tag ?? _TAG,
        level: level.value,
        stackTrace: stackTrace ?? (isError && withStackTrace ? StackTrace.current : null),
      );
    }
  }

  /// 格式化输出 message
  static dynamic _messageFormat(dynamic message) {
    try {
      String text = jsonEncode(message);
      // return const JsonEncoder.withIndent(' ').convert(message);
      return text;
    } catch (e) {
      return message;
    }
  }
}
