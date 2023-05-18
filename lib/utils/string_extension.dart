import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:lpinyin/lpinyin.dart';

extension StringExt on String {
  String get spy => PinyinHelper.getShortPinyin(this);

  String get fpy => PinyinHelper.getPinyin(this, separator: '');

  String? get parenthesesText {
    RegExpMatch? regExpMatch = RegExp('(?:(?<=\\().+?(?=\\)))').firstMatch(this);
    return regExpMatch?[0];
  }

  String get md5 => crypto.md5.convert(utf8.encode(this)).toString();

  bool get isYBJFUrl => false;
}

extension IteratorExt<E> on Iterable<E> {
  E? get firstOrNull {
    Iterator it = iterator;
    if (!it.moveNext()) {
      null;
    }
    return it.current;
  }

  E? get lastOrNull {
    Iterator it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    E result;
    do {
      result = it.current;
    } while (it.moveNext());
    return result;
  }

  E? firstWhereOrNull(bool Function(E element) test, {E Function()? orElse}) {
    for (E element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    return null;
  }
}