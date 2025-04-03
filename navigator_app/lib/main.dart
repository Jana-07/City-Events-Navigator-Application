import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/firebase_options.dart';
import 'package:navigator_app/flex_theme.dart';
import 'package:navigator_app/router/go_router_provider.dart';
import 'package:navigator_app/screens/navigation.dart';
import 'package:navigator_app/screens/profile_navigation.dart';
import 'package:navigator_app/theme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget  {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      //themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      //home: MainScreen(),
      //home: NavigationScreen(),
    );
  }
}
