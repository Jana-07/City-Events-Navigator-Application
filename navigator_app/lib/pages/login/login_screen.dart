import 'package:flutter/material.dart';
import 'package:navigator_app/pages/Sign%20up/signup_screen.dart';
import 'package:navigator_app/constants/Text.dart';
import 'package:navigator_app/constants/size.dart';
import 'package:navigator_app/pages/splash_Screen.dart';
import 'login_form_widget.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({Key? key}) :super(key: key);

  @override

  Widget build(BuildContext context) {
    // TODO: implement build
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
               height: 200,),
                    ],
              ),
              Text(tLoginTitle, style: Theme.of(context).textTheme.headlineLarge),
              Text(tLoginSubTitle, style: Theme.of(context).textTheme.bodyLarge),

              const LoginForm(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: tFormHeight - 20,),
                  TextButton( onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                      child: Text.rich
                        (TextSpan(
                          text:tDontHaveAnAccount,
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: const [
                            TextSpan(
                              text: tSignup ,
                              style: TextStyle(color:Colors.green),
                            )
                          ]
                           ),
                      ),
                  ),
                  const SizedBox(height: tFormHeight - 20,),
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.green, // Change icon color to green
                      size: 30, // Change icon size to 30 pixels
                    ),
                    onPressed: () {
                      // Add your onPressed logic here
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),));

                    },
                  )
                ],

              )
           ],
          ),
        ),
      ),
    ),
    ) ; }

}

