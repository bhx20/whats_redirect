import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxController with WidgetsBindingObserver {
  static final ThemeService instance = ThemeService._internal();

  factory ThemeService() => instance;
  ThemeService._internal();

  static const String _themeKey = "theme_mode";
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadTheme();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// Detect system theme changes
  @override
  void didChangePlatformBrightness() {
    if (themeMode.value == ThemeMode.system) {
      updateSystemUI(ThemeMode.system);
    }
  }

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
    updateSystemUI(themeMode.value);
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
    updateSystemUI(mode);
  }

  /// Boolean Getter to Check if Dark Mode is Active
  bool get isDarkMode {
    Brightness platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return themeMode.value == ThemeMode.dark ||
        (themeMode.value == ThemeMode.system &&
            platformBrightness == Brightness.dark);
  }

  /// Update Status Bar and System Navigation Bar Colors
  void updateSystemUI(ThemeMode mode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          isDarkMode ? appColors.darkBackground : appColors.lightBackground,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          isDarkMode ? appColors.darkBackground : appColors.lightBackground,
      systemNavigationBarIconBrightness:
          isDarkMode ? Brightness.light : Brightness.dark,
    ));
  }
}
