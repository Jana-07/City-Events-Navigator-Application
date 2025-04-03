import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/constant/size.dart';
import 'package:navigator_app/constant/text.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/services/auth_controller.dart';
import 'package:navigator_app/services/first_launch_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  BuildContext? _progressIndicatorContext;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    if (_progressIndicatorContext != null &&
        _progressIndicatorContext!.mounted) {
      Navigator.of(_progressIndicatorContext!).pop();
      _progressIndicatorContext = null;
    }
    super.dispose();
  }

  Future<void> _signIn() async {
    final auth = ref.watch(authControllerProvider.notifier);

    await auth.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: tEmail,
                hintText: tEmail,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _passwordController,
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
                                    prefixIcon:
                                        Icon(Icons.mail_outline_rounded),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //Get.to(() => const OTPScreen());
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
                onPressed: () async {
                  _signIn();
                  await ref.read(markAppLaunchedProvider.future);
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
            ),
          ],
        ),
      ),
    );
  }
}
