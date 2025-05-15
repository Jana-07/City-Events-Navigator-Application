import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/widgets/common/login_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryFixedDim,
              colorScheme.primaryFixed,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/onbordicon.png",
                width: 220,
                height: 220,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Unlock the future of",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Events navigator app",
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "Discover and experience unforgettable moments effortlessly",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onPrimaryFixed,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 50.0),
            LoginButton(
              text: 'Sign In',
              onPressed: () => context.go(Routes.login),
            ),
            SizedBox(height: 20.0),
            LoginButton(
              text: 'Sign Up',
              onPressed: () => context.go(Routes.register),
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(270, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 10,
                shadowColor: Colors.black.withAlpha(150),
              ),
              icon: Image.asset(
                'assets/google_logo.jpg',
                height: 24,
              ),
              label: const Text("Sign in with Google"),
              //TODO:Google signIn
              onPressed: () {},
            ),
            Spacer(),
            TextButton.icon(
                  onPressed: () => context.go(Routes.home),
                  label: Text('Join as a Guest'),
                  icon: Icon(Icons.keyboard_arrow_right_rounded),
                  iconAlignment: IconAlignment.end,
                ),
                const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
