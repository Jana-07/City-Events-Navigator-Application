import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/constant/size.dart';
import 'package:navigator_app/constant/text.dart';
import 'package:navigator_app/router/routes.dart';
import 'login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
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
                Text(tLoginTitle,
                    style: Theme.of(context).textTheme.headlineLarge),
                Text(tLoginSubTitle,
                    style: Theme.of(context).textTheme.bodyLarge),
                const LoginForm(),
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
                        //   MaterialPageRoute(builder: (context) => SignUpScreen()),
                        // );
                        context.go(Routes.registerScreen);
                      },
                      child: Text.rich(
                        TextSpan(
                            text: tDontHaveAnAccount,
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: const [
                              TextSpan(
                                text: tSignup,
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
                        //   Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => SplashScreen(),
                        //       ));
                        // },
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
