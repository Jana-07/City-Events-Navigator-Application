import 'package:flutter/material.dart';

import 'package:navigator_app/screens/home.dart';
import 'package:navigator_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(context),
      home: HomeScreen(),
    );
  }
}
