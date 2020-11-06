import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String keyMode = "settings.Mode";

  static final PreferenceManager _preferenceManager =
      PreferenceManager._build();
  PreferenceManager._build();

  factory PreferenceManager() {
    return _preferenceManager;
  }

  SharedPreferences _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  bool isDarkThemeOn() {
    bool boolValue = _sharedPrefs.getBool(keyMode);
    if (boolValue == null) {
      // if the key is not present, creates it
      this.setDarkTheme(true);
      boolValue = _sharedPrefs.getBool(keyMode);
    }
    return boolValue;
  }

  setDarkTheme(bool on) {
    _sharedPrefs.setBool(keyMode, on);
  }
}
