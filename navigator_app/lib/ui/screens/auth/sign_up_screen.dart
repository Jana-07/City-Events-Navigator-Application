import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/core/constant/text.dart';
import 'package:navigator_app/core/constant/size.dart';
import 'package:navigator_app/ui/widgets/auth/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
            Text(tSignUpTitle, style: theme.textTheme.headlineLarge),
            const SizedBox(height: 18),
            Text(tSignUpSubTitle, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            const SignUpForm(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tAlreadyHaveAnAccount,
                  style: theme.textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () => context.go(Routes.login),
                  child: Text(tLogin),
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
              onPressed: () => context.go(Routes.splash),
            ),
          ],
        ),
      ),
    );
  }
}
