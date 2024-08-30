import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Key? sKey;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Color? statusBarColor;
  final Color? backGroundColor;

  const AppScaffold(
      {super.key,
      this.sKey,
      this.appBar,
      this.body,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.statusBarColor,
      this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: statusBarColor ?? AppColors.white,
      ),
      child: SafeArea(
        child: Scaffold(
          key: key,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          backgroundColor: backgroundColor ?? AppColors.white,
        ),
      ),
    );
  }
}
