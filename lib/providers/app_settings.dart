import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _profileName = 'Scientist';
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  String get profileName => _profileName;

  void setDarkMode(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setProfileName(String name) {
    final cleanName = name.trim();
    if (cleanName.isNotEmpty && cleanName != _profileName) {
      _profileName = cleanName;
      notifyListeners();
    }
  }
}
