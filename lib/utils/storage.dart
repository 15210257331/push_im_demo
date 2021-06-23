import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储 单例模式
class StorageUtil {
  static StorageUtil _instance = new StorageUtil._internal();
  factory StorageUtil() => _instance;
  static SharedPreferences sharedPreferences;

  StorageUtil._internal();

  static Future<void> init() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return sharedPreferences.setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String jsonString = sharedPreferences.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future<bool> setBool(String key, bool val) {
    return sharedPreferences.setBool(key, val);
  }

  bool getBool(String key) {
    bool val = sharedPreferences.getBool(key);
    return val == null ? false : val;
  }

  Future<bool> remove(String key) {
    return sharedPreferences.remove(key);
  }
}
