// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppTheme {
//   // Common Colors
//   static const Color primaryColor = Color(0xFF3D6A3C);
//   static const Color accentYellow = Color(0xFFF4A000);
//   static const Color accentRed = Color(0xFFD04D43);
//   static const Color accentBlue = Color(0xFF3A7AC7);
//   static const Color accentPurple = Color(0xFF69328D);
//   static const Color textLightGray = Color(0xFF777777);

//   // Light Theme Colors
//   static const Color lightBackground = Color(0xFFF5F5F5);
//   static const Color lightCardBackground = Color(0xFFFFFFFF);
//   static const Color lightText = Color(0xFF333333);

//   // Dark Theme Colors
//   static const Color darkBackground = Color(0xFF1C1C1C);
//   static const Color darkCardBackground = Color(0xFF2A2A2A);
//   static const Color darkText = Color(0xFFF5F5F5);

//   static TextTheme textTheme = TextTheme(
//     titleLarge:
//         GoogleFonts.nunitoSans(fontSize: 20, fontWeight: FontWeight.bold),
//     titleMedium:
//         GoogleFonts.nunitoSans(fontSize: 16, fontWeight: FontWeight.w600),
//     bodyLarge:
//         GoogleFonts.nunitoSans(fontSize: 14, fontWeight: FontWeight.normal),
//     bodyMedium:
//         GoogleFonts.nunitoSans(fontSize: 12, fontWeight: FontWeight.normal),
//     labelLarge: GoogleFonts.nunitoSans(
//         fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
//   );

//   static ThemeData lightTheme(BuildContext context) {
//     return ThemeData().copyWith(
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: const Color.fromARGB(255, 60, 129, 107),
//         surface: const Color.fromARGB(255, 60, 109, 74),
//       ),
//       textTheme: GoogleFonts.merriweatherTextTheme(
//         Theme.of(context).textTheme,
//       ),
//     );
//   }

//   static ThemeData darkTheme(BuildContext context) {
//     return ThemeData(
//       brightness: Brightness.dark,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: const Color.fromARGB(255, 60, 109, 94),
//         brightness: Brightness.dark,
//       ),
//       textTheme: GoogleFonts.nunitoSansTextTheme(
//         Theme.of(context).textTheme,
//       ),
//     );
//   }
// }
