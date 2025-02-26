import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 60, 109, 94),
      ),
      textTheme: GoogleFonts.merriweatherTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 60, 109, 94),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }
}
