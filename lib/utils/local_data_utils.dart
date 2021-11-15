//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-12 16:14:52
//
//   本地数据存储
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class LocalDataUtils {
  LocalDataUtils._();

  static Future<bool> setBool(String key, bool value) async =>
      (await _prefs).setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      (await _prefs).setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      (await _prefs).setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      (await _prefs).setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      (await _prefs).setStringList(key, value);

  static Future<bool> setMap(String key, Map value) async =>
      (await _prefs).setString(key, json.encode(value));

  static Future<Map?> getMap(String key) async =>
      (await _prefs).getString(key)?.toMap();

  static Future<dynamic> get(String key) async => (await _prefs).get(key);

  static Future<bool> cleanData(String? key) async {
    if (key != null) (await _prefs).remove(key);
    return (await _prefs).clear();
  }
}

extension LocalStringExtenSion on String {
  Map? toMap() => json.decode(this);
}
