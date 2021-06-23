import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  String _themeColor = '';
  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}
