import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/services/firestore_service.dart';
import '../models/app_user.dart';

class UserRepository {
  UserRepository(this._firestoreService);
  
  final FirestoreService _firestoreService;
  
  // Get user by ID
  Future<AppUser?> getUser(String userId) async {
    if (userId == 'guest') {
      return AppUser.guest();
    }
    
    final doc = await _firestoreService.getDocument('users/$userId');
    if (!doc.exists) {
      return null;
    }
    
    return AppUser.fromDocument(doc);
  }
  
  // Stream user by ID
  Stream<AppUser?> streamUser(String userId) {
    if (userId == 'guest') {
      return Stream.value(AppUser.guest());
    }
    
    return _firestoreService.streamDocument('users/$userId').map((doc) {
      if (!doc.exists) {
        return null;
      }
      
      return AppUser.fromDocument(doc);
    });
  }
  
  // Create or update user
  Future<void> saveUser(AppUser user) async {
    if (user.uid == 'guest') {
      return;
    }
    
    await _firestoreService.setDocument(
      'users/${user.uid}',
      user.toMap(),
    );
  }
  
  // Update user role
  Future<void> updateUserRole(String userId, String role) async {
    if (userId == 'guest') {
      return;
    }
    
    await _firestoreService.updateDocument(
      'users/$userId',
      {'role': role},
    );
  }
  
  // Update user preferences
  Future<void> updateUserPreferences(
    String userId, 
    Map<String, dynamic> preferences,
  ) async {
    if (userId == 'guest') {
      return;
    }
    
    await _firestoreService.updateDocument(
      'users/$userId',
      {'preferences': preferences},
    );
  }
  
  // Delete user
  Future<void> deleteUser(String userId) async {
    if (userId == 'guest') {
      return;
    }
    
    await _firestoreService.deleteDocument('users/$userId');
  }
}