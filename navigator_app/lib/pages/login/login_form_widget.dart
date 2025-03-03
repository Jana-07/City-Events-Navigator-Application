import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigator_app/screens/home.dart';
import 'package:navigator_app/services/otp_screen.dart';
import 'package:navigator_app/constants/Text.dart';
import 'package:navigator_app/constants/size.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  // Function to handle login
  void _handleLogin(BuildContext context) async {
    try {
      // Simulate a login process (replace with your actual logic)
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay

      // Show "Login Successful" dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xffc3d9c9),
          title: Text("Login Successful"),
          content: Text("You have successfully logged in!"),
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
          content: Text("Failed to log in. Please try again."),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: tEmail,
                hintText: tEmail,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: tPassword,
                hintText: tPassword,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tResetViaEMail,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: tFormHeight),
                          Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    label: Text(tEmail),
                                    hintText: tEmail,
                                    prefixIcon: Icon(Icons.mail_outline_rounded),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => const OTPScreen());
                                    },
                                    child: Text("Will do it later"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleLogin(context), // Call the login function
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