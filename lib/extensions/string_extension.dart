import 'dart:convert';

extension StringExtension on String {
  String get notBreak => replaceAll('', '\u{200B}');

  double toDouble() => double.parse(this);

  int toInt() => int.parse(this);

  Map? toMap() => json.decode(this);
}

