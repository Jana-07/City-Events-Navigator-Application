import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole {
  guest,
  user,
  organizer,
}

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.preferences = const {},
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String name;
  final String role;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;

  // Create a guest user
  factory AppUser.guest() {
    return AppUser(
      uid: 'guest',
      name: 'Guest',
      email: '',
      role: 'guest',
      createdAt: DateTime.now(),
    );
  }

   // Create App User from Firestore document
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'guest',
      preferences: data['preferences'] ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory AppUser.fromUser(User firebaseUser, {String role = 'User'}) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'User',
      role: role,
      createdAt: DateTime.now(),
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'preferences': preferences,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a copy with updated fields
  AppUser copyWith({
    String? name,
    String? email,
    String? role,
    Map<String, dynamic>? preferences,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
    );
  }

}