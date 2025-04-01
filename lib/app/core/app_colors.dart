import 'package:flutter/material.dart';

import '../reusable/theme_service/theme_service.dart';

Color appColors = Colors.transparent;

extension ColorExtension on Color {
  // Light Theme Colors
  Color get lightBackground => Colors.white;
  Color get lightPopBackground => Colors.white;
  Color get lightFieldBackground => Color(0xfff6f5f3);
  Color get lightFieldHint => Color(0xff7b7a78);
  Color get lightFieldPrefix => Color(0xff7b7a78);
  Color get lightTitle => Color(0xff1daa61);
  Color get lightIndicator => Color(0xffdbfed4);
  Color get lightIndicatorIcon => Color(0xff185E3C);
  Color get lightHeaderBg => Color(0xffdbfed4);
  Color get lightHeaderTitle => Color(0xff185E3C);
  Color get unfocusedLightHeaderBg => Color(0xfff6f5f3);
  Color get unfocusedLightHeaderTitle => Color(0xff7b7a78);
  Color get lightPrimarySlideBg => Color(0xffdbfed4);
  Color get lightPrimarySlideTitle => Color(0xff1DAB61);
  Color get lightSecondarySlideBg => Color(0xff1DAB61);
  Color get lightSecondarySlideTitle => Color(0xffffffff);
  Color get lightDialogBg => Color(0xffffffff);

  Color get lightSimmerBase => Color(0xfff6f5f3);
  Color get lightSimmerHighLight => Color(0xffffffff);

  Color get xffdbfed4 => const Color(0xffdbfed4);
  Color get xff185E3C => const Color(0xff185E3C);
  Color get xff7b7a78 => const Color(0xff7b7a78);
  Color get xff1DAB61 => const Color(0xff1DAB61);

  // Dark Theme Colors
  Color get darkBackground => Color(0xff0b1014);
  Color get darkPopBackground => Color(0xff13181c);
  Color get darkFieldBackground => Color(0xff24282c);
  Color get darkFieldHint => Color(0xff686e72);
  Color get darkFieldPrefix => Color(0xff686e72);
  Color get darkTitle => Colors.white;
  Color get darkIndicator => Color(0xff1a342a);
  Color get darkIndicatorIcon => Color(0xffe0fcd7);
  Color get darkHeaderBg => Color(0xff1a342a);
  Color get darkHeaderTitle => Color(0xff5cbd6d);
  Color get unfocusedDarkHeaderBg => Color(0xff24282c);
  Color get unfocusedDarkHeaderTitle => Color(0xff8e9599);
  Color get darkPrimarySlideBg => Color(0xff1a342a);
  Color get darkPrimarySlideTitle => Color(0xff5cbd6d);
  Color get darkSecondarySlideBg => Color(0xff3d7c49);
  Color get darkSecondarySlideTitle => Color(0xffe0fcd7);
  Color get darkDialogBg => Color(0xff2b2f33);

  Color get darkSimmerBase => Color(0xff24282c);
  Color get darkSimmerHighLight => Color(0xff2b2f33);

  // Common Theme Colors
  Color get trans => Colors.transparent;
  Color get black => Colors.black;
  Color get gray => Colors.grey;
  Color get white => Colors.white;

  /// Common function to get theme-based colors
  Color getThemeColor(Color light, Color dark) {
    return ThemeService.instance.isDarkMode ? dark : light;
  }

  /// Theme-based colors using the common function
  Color get title => getThemeColor(lightTitle, darkTitle);
  Color get indicatorIcon =>
      getThemeColor(lightIndicatorIcon, darkIndicatorIcon);
  Color get unfocusedIndicatorIcon => getThemeColor(black, white);
  Color get filterBg => getThemeColor(lightHeaderBg, darkHeaderBg);
  Color get filterTitle => getThemeColor(lightHeaderTitle, darkHeaderTitle);

  Color get dialogBG => getThemeColor(lightDialogBg, darkDialogBg);

  Color get unfocusedFilterBg =>
      getThemeColor(unfocusedLightHeaderBg, unfocusedDarkHeaderBg);
  Color get unfocusedFilterTitle =>
      getThemeColor(unfocusedLightHeaderTitle, unfocusedDarkHeaderTitle);

  Color get primarySlideBg =>
      getThemeColor(lightPrimarySlideBg, darkPrimarySlideBg);

  Color get primarySlideTitle =>
      getThemeColor(lightPrimarySlideTitle, darkPrimarySlideTitle);

  Color get secondarySlideBg =>
      getThemeColor(lightSecondarySlideBg, darkSecondarySlideBg);

  Color get secondarySlideTitle =>
      getThemeColor(lightSecondarySlideTitle, darkSecondarySlideTitle);
  Color get simmerBase => getThemeColor(lightSimmerBase, darkSimmerBase);
  Color get simmerHighLight =>
      getThemeColor(lightSimmerHighLight, darkSimmerHighLight);
  Color get background => getThemeColor(lightBackground, darkBackground);
}
