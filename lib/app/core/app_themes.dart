import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: TextFontFamily.roboto,
    scaffoldBackgroundColor: appColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: appColors.black),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: appColors.lightPopBackground,
      elevation: 0.5,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: appColors.lightDialogBg,
      elevation: 0.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      prefixIconColor: appColors.lightFieldPrefix,
      fillColor: appColors.lightFieldBackground,
      hintStyle: typo.darkHint,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.trans),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.trans),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.trans),
          borderRadius: BorderRadius.all(Radius.circular(100))),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: appColors.lightBackground,
      indicatorColor: appColors.lightIndicator,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return typo.w700.get11;
          }
          return typo.w500.get11;
        },
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: typo.black,
      bodyMedium: typo.black,
      bodySmall: typo.black,
      displayLarge: typo.black.get30,
      displayMedium: typo.black.get26,
      displaySmall: typo.black.get22,
      titleLarge: typo.lightTitle.get20.bold,
      titleMedium: typo.lightTitle.get18.bold,
      titleSmall: typo.lightTitle.get16.bold,
      labelLarge: typo.black.get14,
      labelMedium: typo.black.get12,
      labelSmall: typo.black.get10,
      headlineLarge: typo.black.get32.bold,
      headlineMedium: typo.black.get28.bold,
      headlineSmall: typo.black.get24.bold,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: TextFontFamily.roboto,
    scaffoldBackgroundColor: appColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: appColors.white),
    ),
    popupMenuTheme:
        PopupMenuThemeData(color: appColors.darkPopBackground, elevation: 0.5),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      prefixIconColor: appColors.darkFieldPrefix,
      fillColor: appColors.darkFieldBackground,
      hintStyle: typo.darkHint,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.trans),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.trans),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: appColors.trans),
          borderRadius: BorderRadius.all(Radius.circular(100))),
    ),
    dialogTheme: DialogThemeData(
        backgroundColor: appColors.darkDialogBg, elevation: 0.0),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: appColors.darkBackground,
      indicatorColor: appColors.darkIndicator,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return typo.w700.get11;
          }
          return typo.w500.get11;
        },
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: typo.white,
      bodyMedium: typo.white,
      bodySmall: typo.white,
      displayLarge: typo.white.get30,
      displayMedium: typo.white.get26,
      displaySmall: typo.white.get22,
      titleLarge: typo.darkTitle.get20.bold,
      titleMedium: typo.darkTitle.get18.bold,
      titleSmall: typo.darkTitle.get16.bold,
      labelLarge: typo.white.get14,
      labelMedium: typo.white.get12,
      labelSmall: typo.white.get10,
      headlineLarge: typo.white.get32.bold,
      headlineMedium: typo.white.get28.bold,
      headlineSmall: typo.white.get24.bold,
    ),
  );
}
