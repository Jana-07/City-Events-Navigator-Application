import 'package:flutter/material.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';
import 'package:navigator_app/ui/screens/profile/user_profile.dart';
import 'package:navigator_app/ui/screens/profile/admin_profile.dart';
import 'package:navigator_app/ui/screens/profile/guest_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserControllerWidget(
      builder: (user) {
        // Check user role and render appropriate profile
        if (user.isGuest == true) {
          return GuestProfile(user: user);
        } else if (user.role == 'organizer') {
          return AdminProfile(user: user);
        } else {
          // Default user profile
          return UserProfile(user: user);
        }
      },
    );
  }
}
