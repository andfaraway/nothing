import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:lpinyin/lpinyin.dart';
import '../../http/api.dart';

extension StringExt on String {
  String get spy => PinyinHelper.getShortPinyin(this);
  String get fpy => PinyinHelper.getPinyin(this, separator: '');

  String? get parenthesesText {
    RegExpMatch? regExpMatch =
        RegExp('(?:(?<=\\().+?(?=\\)))').firstMatch(this);
    return regExpMatch?[0];
  }

  String get md5 => crypto.md5.convert(utf8.encode(this)).toString();
  bool get isYBJFUrl => false;
}
