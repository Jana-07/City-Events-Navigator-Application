import 'package:flutter/material.dart';
import 'package:navigator_app/pages/splash_Screen.dart';
import 'package:navigator_app/screens/home.dart';
import 'package:navigator_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAKWiK4yihcuxAeMOci_V3A8skCyrFqpC0",
          authDomain: "eventapp-a9d75.firebaseapp.com",
          projectId: "eventapp-a9d75",
          storageBucket: "eventapp-a9d75.firebasestorage.app",
          messagingSenderId: "116187862675",
          appId: "1:116187862675:web:c8b8bab7ba0a53c6459f66",
          measurementId: "G-KV56YTVZ97"
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      home: SplashScreen(),
    );
  }
}
