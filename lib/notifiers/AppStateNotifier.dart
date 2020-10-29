import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {
  bool isDarkModeOn = false;

  void updateTheme(bool isDarkMode) {
    this.isDarkModeOn = isDarkMode;
    notifyListeners();
  }
}
