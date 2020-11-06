import 'package:cvflutter/managers/preferences_manager.dart';
import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {
  bool isDarkModeOn = false;

  void updateTheme(bool isDarkMode) {
    this.isDarkModeOn = isDarkMode;
    PreferenceManager().setDarkTheme(isDarkMode);
    notifyListeners();
  }
}
