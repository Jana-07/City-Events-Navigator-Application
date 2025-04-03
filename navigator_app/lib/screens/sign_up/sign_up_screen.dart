import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/constant/text.dart';
import 'package:navigator_app/constant/size.dart';
import 'package:navigator_app/screens/sign_up/sign_up_form.dart';



class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe6f8ea),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage("assets/onbordicon.png"),
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
                Text(tSignUpTitle,
                    style: Theme.of(context).textTheme.headlineLarge),
                Text(tSignUpSubTitle,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SignUpForm(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: tFormHeight - 20,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => LoginScreen()),
                        // );
                        context.go(Routes.loginScreen);
                      },
                      child: Text.rich(
                        TextSpan(
                            text: tAlreadyHaveAnAccount,
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: const [
                              TextSpan(
                                text: tLogin,
                                style: TextStyle(color: Colors.green),
                              )
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: tFormHeight - 20,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.green, // Change icon color to green
                        size: 30, // Change icon size to 30 pixels
                      ),
                      onPressed: () {
                        // Add your onPressed logic here
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => SplashScreen(),
                        //     ));
                        context.go(Routes.splashScreen);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
