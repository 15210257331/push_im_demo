import 'package:flutter/material.dart';
import 'package:push_im_demo/config.dart';
import 'package:push_im_demo/utils/storage.dart';

class AppProvider with ChangeNotifier {

  String _themeColorKey = '';

  String get themeColorKey {
    String data = StorageUtil().getJSON(THEME_KEY);
    if(data != null) {
      return data;
    }
    return _themeColorKey;
  }

  /// 主题颜色map
  Map<String, Color> themeColorMap = {
    'gray': Colors.grey,
    'blue': Colors.blue,
    'blueAccent': Colors.blueAccent,
    'cyan': Colors.cyan,
    'deepPurple': Colors.purple,
    'deepPurpleAccent': Colors.deepPurpleAccent,
    'deepOrange': Colors.orange,
    'green': Colors.green,
    'indigo': Colors.indigo,
    'indigoAccent': Colors.indigoAccent,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'red': Colors.red,
    'teal': Colors.teal,
    'black': Colors.black,
  };


  /// 设置主题颜色
  setTheme(String themeColorKey) async {
    _themeColorKey = themeColorKey;
    notifyListeners();
    await saveThemeColorKey(themeColorKey);
  }

  /// 持久化用户设置的主题颜色
  static Future<bool> saveThemeColorKey(String themeColorKey) {
    return StorageUtil().setJSON(THEME_KEY, themeColorKey);
  }
}
