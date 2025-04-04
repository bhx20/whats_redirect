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
      iconTheme: IconThemeData(color: appColors.lightIcon),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.lightButtonBackground,
        foregroundColor: appColors.lightButtonForeground,
        elevation: 0.0,
        textStyle: typo.bold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: appColors.lightBackground,
      indicatorColor: appColors.lightIndicator,
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(color: appColors.lightIndicatorIcon, size: 22.h);
        }
        return IconThemeData(color: appColors.lightIcon, size: 22.h);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return typo.w600.get11;
          }
          return typo.w500.get11;
        },
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: typo.lightText,
      bodyMedium: typo.lightText,
      bodySmall: typo.lightText,
      displayLarge: typo.lightText.get30,
      displayMedium: typo.lightText.get26,
      displaySmall: typo.lightText.get22,
      titleLarge: typo.lightTitle.get20.bold,
      titleMedium: typo.lightTitle.get18.bold,
      titleSmall: typo.lightTitle.get16.bold,
      labelLarge: typo.lightText.get14,
      labelMedium: typo.lightText.get12,
      labelSmall: typo.lightText.get10,
      headlineLarge: typo.lightText.get32.bold,
      headlineMedium: typo.lightText.get28.bold,
      headlineSmall: typo.lightText.get24.bold,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: TextFontFamily.roboto,
    scaffoldBackgroundColor: appColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: appColors.darkIcon),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.darkButtonBackground,
        foregroundColor: appColors.darkButtonForeground,
        elevation: 0.0,
        textStyle: typo.bold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: appColors.darkBackground,
      indicatorColor: appColors.darkIndicator,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: appColors.darkIndicatorIcon, size: 22.h);
        }
        return IconThemeData(color: appColors.darkIcon, size: 22.h);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return typo.w600.get11;
          }
          return typo.w500.get11;
        },
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: typo.darkText,
      bodyMedium: typo.darkText,
      bodySmall: typo.darkText,
      displayLarge: typo.darkText.get30,
      displayMedium: typo.darkText.get26,
      displaySmall: typo.darkText.get22,
      titleLarge: typo.darkTitle.get20.bold,
      titleMedium: typo.darkTitle.get18.bold,
      titleSmall: typo.darkTitle.get16.bold,
      labelLarge: typo.darkText.get14,
      labelMedium: typo.darkText.get12,
      labelSmall: typo.darkText.get10,
      headlineLarge: typo.darkText.get32.bold,
      headlineMedium: typo.darkText.get28.bold,
      headlineSmall: typo.darkText.get24.bold,
    ),
  );
}
