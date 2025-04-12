import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/core/constant/size.dart';
import 'package:navigator_app/core/constant/text.dart';
import 'package:navigator_app/router/routes.dart';
import '../../widgets/auth/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.05),
                Image(
                  image: AssetImage("assets/onbordicon.png"),
                  width: 200,
                  height: 200,
                ),
              ],
            ),
            Text(tLoginTitle, style: theme.textTheme.headlineLarge),
            const SizedBox(height: 10),
            Text(tLoginSubTitle, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 15),
            const LoginForm(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tDontHaveAnAccount,
                  style: theme.textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () => context.go(Routes.registerScreen),
                  child: Text(tSignup),
                ),
              ],
            ),
            const SizedBox(height: tFormHeight - 20),
            IconButton(
              icon: Icon(
                Icons.home,
                color: colorScheme.primary,
                size: 30,
              ),
              onPressed: () => context.go(Routes.splashScreen),
            ),
          ],
        ),
      ),
    );
  }
}
