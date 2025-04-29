import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigator_app/data/category_data.dart';
import 'dart:io';

import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  String? _selectedLanguage;
  List<String> _selectedPreferences = [];
  File? _profileImageFile;
  bool _isLoading = false;

  // Define available languages and preferences
  final List<String> _availableLanguages = ['English', 'Spanish', 'French'];
  final List<String> _availablePreferences =
      categories.map((category) => category.name).toList();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProfile(AppUser currentUser) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        final userController = ref.read(userControllerProvider.notifier);

        // Update basic profile information
        await userController.updateProfile(
          userName: _userNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          preferredLanguage: _selectedLanguage,
        );

        // Update preferences if changed
        if (!_areListsEqual(currentUser.preferences, _selectedPreferences)) {
          await userController.updatePreferences(_selectedPreferences);
        }

        // Update profile photo if changed
        if (_profileImageFile != null) {
          await userController.updateProfilePhoto(_profileImageFile!);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update profile: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  bool _areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          userAsync.when(
            data: (user) => user == null || user.isGuest
                ? const SizedBox.shrink()
                : _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : TextButton(
                        onPressed: () => _saveProfile(user),
                        child: const Text('Save'),
                      ),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null || user.isGuest) {
            return const Center(
                child: Text('Please log in to edit your profile.'));
          }

          // Initialize controllers and state only once when data is first loaded
          if (_userNameController.text.isEmpty && user.userName.isNotEmpty) {
            _userNameController.text = user.userName;
          }
          if (_emailController.text.isEmpty && user.email != null) {
            _emailController.text = user.email!;
          }
          if (_phoneNumberController.text.isEmpty && user.phoneNumber != null) {
            _phoneNumberController.text = user.phoneNumber!;
          }
          if (_selectedLanguage == null && user.preferredLanguage != null) {
            _selectedLanguage = user.preferredLanguage;
          }
          if (_selectedPreferences.isEmpty && user.preferences.isNotEmpty) {
            _selectedPreferences = List.from(user.preferences);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImageFile != null
                              ? FileImage(_profileImageFile!) as ImageProvider
                              : user.profilePhotoURL.isNotEmpty
                                  ? NetworkImage(user.profilePhotoURL)
                                  : const AssetImage('assets/person.jpg')
                                      as ImageProvider,
                          backgroundColor: Colors.grey[200],
                        ),
                        Material(
                          color: colorScheme.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: _pickImage,
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      // Basic phone validation - can be enhanced
                      if (value != null &&
                          value.isNotEmpty &&
                          !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  // const SizedBox(height: 16),
                  // DropdownButtonFormField<String>(
                  //   value: _selectedLanguage,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Preferred Language',
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   items: _availableLanguages.map((String language) {
                  //     return DropdownMenuItem<String>(
                  //       value: language,
                  //       child: Text(language),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       _selectedLanguage = newValue;
                  //     });
                  //   },
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please select a language';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 24),
                  const Text('Preferences',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _availablePreferences.map((preference) {
                      final isSelected =
                          _selectedPreferences.contains(preference);
                      return FilterChip(
                        label: Text(
                          preference,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedPreferences.add(preference);
                            } else {
                              _selectedPreferences.remove(preference);
                            }
                          });
                        },
                        selectedColor: colorScheme.primaryContainer,
                        checkmarkColor: colorScheme.onPrimaryContainer,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Failed to load user data: $error'),
        ),
      ),
    );
  }
}
