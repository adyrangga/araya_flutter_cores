library araya_core_prefs;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// static declaration for global use platform-specific persistent storage.
///
/// please initialize SharedPreferences on runApp function.
///
/// Wraps platform-specific persistent storage for simple data
/// (NSUserDefaults on iOS and macOS, SharedPreferences on Android, etc.).
class ArayaCorePrefs {
  static late SharedPreferences _prefs;

  /// for general purpose use.
  SharedPreferences get prefs => _prefs;

  /// please initialize SharedPreferences on runApp function.
  /// so app can used globally.
  static Future<SharedPreferences> getInstance() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  /// get boolean value by prefs key
  static bool getBool(String appPrefsKeys) {
    return _prefs.getBool(appPrefsKeys) ?? false;
  }

  /// set boolean value by prefs key
  static Future<bool> setBool(String appPrefsKeys, bool value) {
    return _prefs.setBool(appPrefsKeys, value);
  }

  /// get String value by prefs key
  static String? getString(String appPrefsKeys) {
    return _prefs.getString(appPrefsKeys);
  }

  /// set String value by prefs key
  static Future<bool> setString(String appPrefsKeys, String value) {
    return _prefs.setString(appPrefsKeys, value);
  }

  /// get int value by prefs key
  static int? getInt(String appPrefsKeys) {
    return _prefs.getInt(appPrefsKeys);
  }

  /// set int value by prefs key
  static Future<bool> setInt(String appPrefsKeys, int value) {
    return _prefs.setInt(appPrefsKeys, value);
  }

  /// get double value by prefs key
  static double? getDouble(String appPrefsKeys) {
    return _prefs.getDouble(appPrefsKeys);
  }

  /// set double value by prefs key
  static Future<bool> setDouble(String appPrefsKeys, double value) {
    return _prefs.setDouble(appPrefsKeys, value);
  }

  //
  // current apps ThemeMode sections.
  //
  static String get themeModeKey => 'themeModeKey';

  static ThemeMode _themeModeByCode() {
    int code = _prefs.getInt(themeModeKey) ?? 0;
    ThemeMode themeMode = ThemeMode.system;
    if (code == 1) themeMode = ThemeMode.light;
    if (code == 2) themeMode = ThemeMode.dark;
    return themeMode;
  }

  /// get current app ThemeMode:
  /// 0: ThemeMode.system. 1: ThemeMode.light. 2: ThemeMode.dark
  static ThemeMode get getThemeMode => _themeModeByCode();

  /// set selected themeMode value
  static Future<bool> setThemeMode(ThemeMode themeMode) {
    int themeModeCode = 0;
    if (themeMode == ThemeMode.light) themeModeCode = 1;
    if (themeMode == ThemeMode.dark) themeModeCode = 2;
    return _prefs.setInt(themeModeKey, themeModeCode);
  }
}

/// Application theme mode changes notifier.
///
/// current app theme store on localstorage too.
class ArayaCoreThemeNotifier with ChangeNotifier, DiagnosticableTreeMixin {
  ThemeMode _appThemeMode = ThemeMode.system;

  ThemeMode get appThemeMode {
    _appThemeMode = ArayaCorePrefs.getThemeMode;
    return _appThemeMode;
  }

  void toggleAppThemeMode(BuildContext context) async {
    ThemeMode themeMode = _appThemeMode;
    if (_appThemeMode == ThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    setAppThemeMode(themeMode);
  }

  void setAppThemeMode(ThemeMode themeMode) async {
    _appThemeMode = themeMode;
    await ArayaCorePrefs.setThemeMode(themeMode);
    notifyListeners();
  }

  /// Makes `AppViewModel` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('appThemeMode', appThemeMode));
  }
}
