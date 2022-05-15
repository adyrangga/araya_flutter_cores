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
class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  /// initialize SharedPreferences.
  /// call on main() before runApp.
  Future<SharedPreferences> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
    return _sharedPrefs!;
  }

  bool? getBool(String key) => _sharedPrefs?.getBool(key);

  double? getDouble(String key) => _sharedPrefs?.getDouble(key);

  int? getInt(String key) => _sharedPrefs?.getInt(key);

  String? getString(String key) => _sharedPrefs?.getString(key);

  List<String>? getStringList(String key) => _sharedPrefs?.getStringList(key);

  Future<bool> setBool(String key, bool value) =>
      _sharedPrefs!.setBool(key, value);

  Future<bool> setDouble(String key, double value) =>
      _sharedPrefs!.setDouble(key, value);

  Future<bool> setInt(String key, int value) =>
      _sharedPrefs!.setInt(key, value);

  Future<bool> setString(String key, String value) =>
      _sharedPrefs!.setString(key, value);

  Future<bool> setStringList(String key, List<String> value) =>
      _sharedPrefs!.setStringList(key, value);

  /// remove spesific value by key. if key null, clear all value.
  Future<bool> clear([String? key]) {
    if (key == null) return _sharedPrefs!.clear();
    return _sharedPrefs!.remove(key);
  }

  //
  // current apps ThemeMode sections.
  //
  String get themeModeKey => 'themeModeKey';

  /// get current app ThemeMode.
  /// 0: ThemeMode.system. 1: ThemeMode.light. 2: ThemeMode.dark.
  ///
  /// part of current apps ThemeMode sections.
  ThemeMode get getThemeMode {
    int code = _sharedPrefs?.getInt(themeModeKey) ?? 0;
    ThemeMode themeMode = ThemeMode.system;
    if (code == 1) themeMode = ThemeMode.light;
    if (code == 2) themeMode = ThemeMode.dark;
    return themeMode;
  }

  /// set selected themeMode value.
  ///
  /// part of current apps ThemeMode sections.
  Future<bool> setThemeMode(ThemeMode themeMode) async {
    int themeModeCode = 0;
    if (themeMode == ThemeMode.light) themeModeCode = 1;
    if (themeMode == ThemeMode.dark) themeModeCode = 2;
    return (await init()).setInt(themeModeKey, themeModeCode);
  }
}

/// Application theme mode changes notifier.
///
/// current app theme store on localStorage too.
class ArayaThemeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ThemeMode _appThemeMode = ThemeMode.system;

  ThemeMode get appThemeMode {
    _appThemeMode = SharedPrefs().getThemeMode;
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
    await SharedPrefs().setThemeMode(themeMode);
    notifyListeners();
  }

  /// Makes `AppViewModel` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('appThemeMode', appThemeMode));
  }
}
