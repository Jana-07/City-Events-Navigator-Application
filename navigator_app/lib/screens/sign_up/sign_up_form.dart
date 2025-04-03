import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/constant/size.dart';
import 'package:navigator_app/constant/text.dart';
import 'package:navigator_app/services/auth_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});
  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  BuildContext? _progressIndicatorContext;

  @override
  void dispose() {
    // dispose controllers
    _emailController.dispose();
    _passwordController.dispose();

    // close loading dialog when closing page
    if (_progressIndicatorContext != null &&
        _progressIndicatorContext!.mounted) {
      Navigator.of(_progressIndicatorContext!).pop();
      _progressIndicatorContext = null;
    }
    super.dispose();
  }

  Future<void> _signup() async {
    final auth = ref.read(authControllerProvider.notifier);
    await auth.createUserWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

    ref.listen(authControllerProvider, (prev, state) async {
      if (state.isLoading) {
        await showDialog(
          context: context,
          builder: (ctx) {
            _progressIndicatorContext = ctx;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        return;
      }

      // close circular progress indicator after rebuild
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_progressIndicatorContext != null &&
            _progressIndicatorContext!.mounted) {
          Navigator.of(_progressIndicatorContext!).pop();
          _progressIndicatorContext = null;
        }
      });

      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Error: ${state.error}'),
          ),
        );
      }
    });

    return Form(
      key: formkey, // Add the key to the Form widget
      child: Container(
        padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              //controller: controller.fullname,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
                label: Text(tFullName),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: tEmail,
                hintText: "**********@gmail.com",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              //controller: controller.phoneNo,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.numbers_rounded),
                labelText: tPhoneNo,
                hintText: "05********",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _passwordController,
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
                onPressed: _signup, // Call the sign-up function
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
