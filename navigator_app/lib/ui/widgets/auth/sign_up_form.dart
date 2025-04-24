import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/core/constant/size.dart';
import 'package:navigator_app/core/constant/text.dart';
import 'package:navigator_app/data/category_data.dart';
import 'package:navigator_app/data/models/categoy.dart';
import 'package:navigator_app/ui/controllers/auth_controller.dart';
import 'package:navigator_app/ui/widgets/common/app_text_form_field.dart';
import 'package:navigator_app/ui/widgets/common/login_button.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});
  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final List<String> _selectedCategories = [];
  BuildContext? _progressIndicatorContext;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _preferencesController.dispose();
    _phoneController.dispose();

    // close loading dialog when closing page
    if (_progressIndicatorContext != null &&
        _progressIndicatorContext!.mounted) {
      //Navigator.of(_progressIndicatorContext!).pop();
      _progressIndicatorContext = null;
    }
    super.dispose();
  }

  Future<void> _signup() async {
    final auth = ref.read(authControllerProvider.notifier);
    //final authRepo = ref.watch(authRepositoryProvider);
    await auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      userName: _usernameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      preferences: _selectedCategories,
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
          //Navigator.of(_progressIndicatorContext!).pop();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextFormField(
              controller: _usernameController,
              labelText: tFullName,
              hintText: tFullName,
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: tFormHeight - 20),
            AppTextFormField(
              controller: _emailController,
              labelText: tEmail,
              hintText: 'example@gmail.com',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: tFormHeight - 20),
            AppTextFormField(
              controller: _phoneController,
              labelText: tPhoneNo,
              hintText: '05********',
              icon: Icons.phone_iphone_rounded,
            ),
            const SizedBox(height: tFormHeight - 20),
            AppTextFormField(
              controller: _passwordController,
              labelText: tPassword,
              hintText: tPassword,
              icon: Icons.lock_outline_rounded,
              isPassword: true,
            ),
            const SizedBox(height: tFormHeight - 20),
            AppTextFormField(
              controller: _confirmPasswordController,
              labelText: tPassword,
              hintText: tPassword,
              icon: Icons.lock_outline_rounded,
              isPassword: true,
            ),
            const SizedBox(height: tFormHeight),
            Text(
              'Choose your categoires preferences:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: tFormHeight - 20),
            Wrap(
              spacing: 8,
              children: categories.map((category) {
                final isSelected = _selectedCategories.contains(category.name);
                return ChoiceChip(
                  label: Text(category.name),
                  selected: isSelected,
                  selectedColor: Theme.of(context).colorScheme.primary.withAlpha(125),
                  onSelected: (selected) {
                    setState(() {
                      isSelected
                          ? _selectedCategories.remove(category.name)
                          : _selectedCategories.add(category.name);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: tFormHeight),
            LoginButton(text: 'Sign Up', onPressed: _signup),
          ],
        ),
      ),
    );
  }
}
