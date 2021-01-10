import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = true;
  final box = Hive.box("settings");

  MyTheme() {
    if (box.containsKey("theme")) {
      _isDark = box.get("theme");
    } else
      box.put("theme", true);
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    box.put("theme", _isDark);
    notifyListeners();
  }
}

MyTheme theme = MyTheme();
