import 'dart:async';

import 'package:flutter/foundation.dart';

/// 防抖和节流
///
/// 需要注意的是，在方法里进行 [setState] 后，防抖节流都会失效，函数会重新生成新实例。
extension DebounceThrottlingExtension on Function {
  /// 防抖 (debounce)
  VoidCallback debounce([Duration duration = const Duration(seconds: 1)]) {
    assert(duration > Duration.zero);
    Timer? debounce;
    return () {
      // 还在时间之内，抛弃上一次
      // 执行最后一次
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      debounce = Timer(duration, () {
        this.call();
      });
    };
  }

  /// 节流 (throttle)
  VoidCallback throttle([Duration duration = const Duration(seconds: 1)]) {
    assert(duration > Duration.zero);
    Timer? throttle;
    return () {
      // 执行第一次
      if (throttle?.isActive ?? false) {
        return;
      }
      this.call();
      throttle = Timer(duration, () {});
    };
  }
}

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

/// 节流
ValueChanged throttle1<T>(
  T callback, [
  Duration duration = const Duration(seconds: 1),
]) {
  assert(duration > Duration.zero);
  Timer? throttle;
  return (callback) {
    // 执行第一次
    if (throttle?.isActive ?? false) {
      return;
    }
    callback.call();
    throttle = Timer(duration, () {});
  };
}
