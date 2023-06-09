import 'dart:convert';

import '../utils/log_utils.dart';

extension ObjectEx on Object {
  String? get toJsonString {
    try {
      return json.encode(this);
    } catch (e) {
      return null;
    }
  }
}

extension StringEx on String {
  Map<String, dynamic> get toJson {
    try {
      return json.decode(this);
    } catch (e) {
      Log.d('toJson error$e');
      return {};
    }
  }
}
