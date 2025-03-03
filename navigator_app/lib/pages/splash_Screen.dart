import 'package:flutter/material.dart';
import 'package:navigator_app/pages/Sign%20up/signup_screen.dart';
import 'package:navigator_app/pages/login/login_screen.dart';

import '../services/auth.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SplashScreen> {
  @override



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc3d9c9),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50), // Add space at the top
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset("assets/onbordicon.png"),
            ),
            SizedBox(height: 10), // Add space between image and text
           Text("Unlock the future of",
           style: TextStyle(
             color: Colors.black,
             fontSize: 30.0,
             fontWeight: FontWeight.bold,
           ),),
           Text ("Events navigator app",
           style: TextStyle(
             color: Colors.green,
             fontSize: 30.0,
             fontWeight: FontWeight.bold,
           ),),
            SizedBox(height: 30.0,),
            Text ("Discover and experience unforgettable moments effortlessly",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),),
            // Add this after your existing GestureDetector widget
            SizedBox(height: 20.0), // Spacing between buttons

// Login Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(MediaQuery.of(context).size.width - 40, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 15.0), // Spacing between buttons

// Sign Up Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );         },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(MediaQuery.of(context).size.width - 40, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50.0,),
            GestureDetector(
              onTap: (){
                AuthMethod().singInWithGoogle(context);
              },
              child: Container(
                height: 70,
                margin: EdgeInsets.only(left: 20.0,right: 20.0),
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img1.png",height: 50,width: 50, fit: BoxFit.cover,),
                    SizedBox(height: 20.0,),
                    Text("   Sign in with google",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                    ),
                    )


                  ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}