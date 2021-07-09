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
    _themeColorKey = 'blue';
    return _themeColorKey;
  }

  /// 主题颜色map
  Map<String, Map<String, Color>> themeColorMap = {
    'teal': {
      'primaryColor': Colors.teal,
      'cardColor': Colors.white,
    },
    'gray': {
      'primaryColor': Colors.grey,
      'cardColor': Colors.white,
    },
    'blue': {
      'primaryColor': Colors.blue,
      'cardColor': Colors.white,
    },
    'blueAccent': {
      'primaryColor': Colors.blueAccent,
      'cardColor': Colors.white,
    },
    'cyan': {
      'primaryColor': Colors.cyan,
      'cardColor': Colors.white,
    },
    'deepPurple': {
      'primaryColor': Colors.deepPurple,
      'cardColor': Colors.white,
    },
    'deepPurpleAccent': {
      'primaryColor': Colors.deepPurpleAccent,
      'cardColor': Colors.white,
    },
    'deepOrange': {
      'primaryColor': Colors.deepOrange,
      'cardColor': Colors.white,
    },
    'green': {
      'primaryColor': Colors.green,
      'cardColor': Colors.white,
    },
    'indigo': {
      'primaryColor': Colors.indigo,
      'cardColor': Colors.white,
    },
    'indigoAccent': {
      'primaryColor': Colors.indigoAccent,
      'cardColor': Colors.white,
    },
    'orange': {
      'primaryColor': Colors.orange,
      'cardColor': Colors.white,
    },
    'purple': {
      'primaryColor': Colors.purple,
      'cardColor': Colors.white,
    },
    'pink': {
      'primaryColor': Colors.pink,
      'cardColor': Colors.white,
    },
    'red': {
      'primaryColor': Colors.red,
      'cardColor': Colors.white,
    },
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
