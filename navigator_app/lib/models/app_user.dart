import 'package:firebase_auth/firebase_auth.dart';

enum UserRole {
  guest,
  user,
  organizer,
}

class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.displayName,
    required this.role,
  });

  final String uid;
  final String? email;
  final bool emailVerified;
  final String? displayName;
  final UserRole role;

  factory AppUser.fromUser(User firebaseUser, {UserRole role = UserRole.user}) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      role: role,
    );
  }
}
