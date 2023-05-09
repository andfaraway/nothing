///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2/17/21 7:24 PM
///
import 'dart:async';

import 'package:flutter/foundation.dart';

/// 而下面的两个方法没有这种顾虑。

/// 防抖
VoidCallback debounce(
  VoidCallback callback, [
  Duration duration = const Duration(seconds: 1),
]) {
  assert(duration > Duration.zero);
  Timer? debounce;
  return () {
    // 还在时间之内，抛弃上一次
    // 执行最后一次
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
    debounce = Timer(duration, () {
      callback.call();
    });
  };
}

/// 节流
VoidCallback throttle(
  VoidCallback callback, [
  Duration duration = const Duration(seconds: 1),
]) {
  assert(duration > Duration.zero);
  Timer? throttle;
  return () {
    // 执行第一次
    if (throttle?.isActive ?? false) {
      return;
    }
    callback.call();
    throttle = Timer(duration, () {});
  };
}
