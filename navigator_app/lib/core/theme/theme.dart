import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.1.1.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  static const Color primary = Color.fromARGB(255, 60, 109, 74);
  static const Color grey = Color.fromARGB(255, 84, 87, 84);
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    textTheme: GoogleFonts.merriweatherTextTheme().copyWith(
      headlineSmall: GoogleFonts.merriweather().copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.merriweather().copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      titleMedium: GoogleFonts.merriweather().copyWith(
        color: Colors.white,
      ),
      titleSmall: GoogleFonts.merriweather().copyWith(
        color: grey.withAlpha(200),
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle().copyWith(
        color: primary.withAlpha(200),
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    ),
    secondaryContainer: const Color.fromARGB(255, 199, 225, 207),
    colors: FlexSchemeColor.from(
      primary: primary,
      primaryContainer: const Color.fromARGB(255, 101, 149, 116),
    ),
    scheme: FlexScheme.jungle,
    subThemesData: FlexSubThemesData(
      inputDecoratorFillColor: Colors.grey[100],
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.jungle,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
