import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:navigator_app/constants/Text.dart';
import 'package:navigator_app/constants/size.dart';
import 'package:navigator_app/pages/Sign up/signup_controller.dart';
import 'package:navigator_app/screens/home.dart';

class SigninForm extends StatelessWidget {
  const SigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formkey = GlobalKey<FormState>();

    // Function to handle sign-up
    void _handleSignUp() async {
      if (_formkey.currentState!.validate()) {
        try {
          // Call the registration method
          await SignUpController.instance.registeteruser(
            controller.email.text.trim(),
            controller.Password.text.trim(),
          );

          // Show "Sign Up Successful" dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Color(0xffc3d9c9),
              title: Text("Sign Up Successful"),
              content: Text("Your account has been created successfully!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    // Navigate to Events Home Page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),

                    );

                  },
                  child: Text("OK",style:TextStyle(color: Colors.black)),
                ),
              ],
            ),
          );
        } catch (e) {
          // Handle errors (e.g., show an error dialog)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text("Failed to sign up. Please try again."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    }

    return Form(
      key: _formkey, // Add the key to the Form widget
      child: Container(
        padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullname,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
                label: Text(tFullName),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.email,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: tEmail,
                hintText: "**********@gmail.com",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.PhoneNo,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.numbers_rounded),
                labelText: tPhoneNo,
                hintText: "05********",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.Password,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: tPassword,
                hintText: "********",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSignUp, // Call the sign-up function
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
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for EventsHomePage (replace with your actual Events Home Page)
class EventsHomePage extends StatelessWidget {
  const EventsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events Home"),
      ),
      body: Center(
        child: Text("Welcome to the Events Home Page!"),
      ),
    );
  }
}