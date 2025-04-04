import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../reusable/theme_service/theme_service.dart';

class SettingsController extends GetxController {
  final themeService = ThemeService.instance;

  Future<void> setTheme(ThemeMode mode) async {
    themeService.setTheme(mode);
    update();
  }
}
