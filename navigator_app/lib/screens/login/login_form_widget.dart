import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/constant/size.dart';
import 'package:navigator_app/constant/text.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/services/auth_controller.dart';
import 'package:navigator_app/services/first_launch_provider.dart';
import 'package:navigator_app/widgets/app_text_form_field.dart';
import 'package:navigator_app/widgets/login_button.dart';

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
    final theme = Theme.of(context);

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
            //_progressIndicatorContext!.mounted) {
              Navigator.of(context).canPop()) {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextFormField(
              controller: _emailController,
              labelText: tEmail,
              hintText: tEmail,
              icon: Icons.person_2_outlined,
            ),
            SizedBox(height: tFormHeight - 20),
            AppTextFormField(
              controller: _passwordController,
              labelText: tPassword,
              hintText: tPassword,
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "Forget Password?",
                  style: theme.textTheme.labelLarge,
                ),
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
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: tFormHeight),
                          Form(
                            child: Column(
                              children: [
                                AppTextFormField(
                                  controller: _emailController,
                                  labelText: tEmail,
                                  hintText: tEmail,
                                  icon: Icons.mail_outline_rounded,
                                ),
                                const SizedBox(height: 40),
                                LoginButton(
                                  text: 'Send Password Rest',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            LoginButton(
                text: 'Login',
                onPressed: () async {
                  _signIn();
                  await ref.read(markAppLaunchedProvider.future);
                }),
            
          ],
        ),
      ),
    );
  }
}
