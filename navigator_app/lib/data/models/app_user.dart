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
    required this.userName,
    required this.role,
    this.eventsHosted = const [],
    this.preferences = const [],
    this.preferredLanguage = 'en',
    this.profilePhotoURL = '',
    required this.createdAt,
    required this.phoneNumber,
  });

  final String uid;
  final String email;
  final String userName;
  final String role;
  final List<String> eventsHosted;
  final List<String> preferences;
  final String preferredLanguage;
  final String profilePhotoURL;
  final DateTime createdAt;
  final String phoneNumber;

  // Create a guest user
  factory AppUser.guest() {
    return AppUser(
      uid: 'guest',
      userName: 'Guest',
      email: '',
      role: 'guest',
      createdAt: DateTime.now(),
      phoneNumber: '',
    );
  }
  
  bool get isGuest => uid == 'guest';

   // Create App User from Firestore document
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Handle eventsHosted field - could be missing, list, or empty
    List<String> eventsHosted = [];
    if (data['eventsHosted'] != null) {
      if (data['eventsHosted'] is List) {
        eventsHosted = List<String>.from(data['eventsHosted']);
      } else if (data['eventsHosted'] is Map) {
        // If it's a map, extract values
        eventsHosted = (data['eventsHosted'] as Map).values.map((v) => v.toString()).toList();
      }
    }
    
    // Handle preferences field - could be missing, list, or map
    List<String> preferences = [];
    if (data['preferences'] != null) {
      if (data['preferences'] is List) {
        preferences = List<String>.from(data['preferences']);
      } else if (data['preferences'] is Map) {
        // If it's a map, extract values
        preferences = (data['preferences'] as Map).values.map((v) => v.toString()).toList();
      }
    }
    
    return AppUser(
      uid: doc.id,
      userName: data['userName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'guest',
      eventsHosted: eventsHosted,
      preferences: preferences,
      preferredLanguage: data['preferredLanguage'] ?? 'en',
      profilePhotoURL: data['profilePhotoURL'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  factory AppUser.fromUser(User firebaseUser, {String role = 'user'}) {
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      userName: firebaseUser.displayName ?? 'User',
      role: role,
      profilePhotoURL: firebaseUser.photoURL ?? '',
      createdAt: DateTime.now(),
      phoneNumber: firebaseUser.phoneNumber ?? '',
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'role': role,
      'eventsHosted': eventsHosted,
      'preferences': preferences,
      'preferredLanguage': preferredLanguage,
      'profilePhotoURL': profilePhotoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'phoneNumber' : phoneNumber,
    };
  }

  // Create a copy with updated fields
  AppUser copyWith({
    String? userName,
    String? email,
    String? role,
    List<String>? eventsHosted,
    List<String>? preferences,
    String? preferredLanguage,
    String? profilePhotoURL,
    String? phoneNumber,
  }) {
    return AppUser(
      uid: uid,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      role: role ?? this.role,
      eventsHosted: eventsHosted ?? this.eventsHosted,
      preferences: preferences ?? this.preferences,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      profilePhotoURL: profilePhotoURL ?? this.profilePhotoURL,
      createdAt: createdAt,
      phoneNumber: phoneNumber?? this.phoneNumber,
    );
  }
}
