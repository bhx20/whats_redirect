import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redirect/app/reusable/theme_service/theme_service.dart';

import '../core/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Key? sKey;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.sKey,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ThemeService.instance.isDarkMode;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor:
            isDarkMode ? appColors.darkBackground : appColors.lightBackground,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDarkMode ? appColors.darkBackground : appColors.lightBackground,
        systemNavigationBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        key: key,
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
