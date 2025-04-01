import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ThemeService instance = ThemeService._internal();

  factory ThemeService() => instance;
  ThemeService._internal();

  static const String _themeKey = "theme_mode";
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  /// Load theme from SharedPreferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString(_themeKey);

    if (theme == "light") {
      themeMode.value = ThemeMode.light;
    } else if (theme == "dark") {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }

    Get.changeThemeMode(themeMode.value);
  }

  /// Save and Apply Theme
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    themeMode.value = mode;

    await prefs.setString(
        _themeKey,
        mode == ThemeMode.light
            ? "light"
            : mode == ThemeMode.dark
                ? "dark"
                : "system");

    Get.changeThemeMode(mode);
  }

  /// Boolean Getter to Check if Dark Mode is Active
  bool get isDarkMode {
    return themeMode.value == ThemeMode.dark ||
        (themeMode.value == ThemeMode.system && Get.isPlatformDarkMode);
  }
}
