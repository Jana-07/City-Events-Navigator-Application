import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/core/constant/cloudinary_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/data/repositories/user_repository.dart';
import 'package:navigator_app/core/utils/global_error_handler.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/data/services/cloudinary_service.dart'; // Import CloudinaryService

part 'user_controller.g.dart';

/// A provider for the current user with profile management capabilities
@riverpod
class UserController extends _$UserController {
  late final UserRepository _userRepository;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  Future<AppUser> build() async {
    final authState = ref.watch(authStateChangesProvider);
    _userRepository = ref.watch(userRepositoryProvider);

    if (authState.value == null) {
      return AppUser.guest();
    }

    try {
      // Get user
      final user = await _userRepository.getUser(authState.value!.uid);
      return user ?? AppUser.guest();
    } catch (e, st) {
      debugPrint('Failed to fetch user $e, $st');
      return AppUser.guest();
    }
  }

  /// Update user profile information (including phone number)
  Future<void> updateProfile({
    String? userName,
    String? email,
    String? phoneNumber, // Added phoneNumber
    String? preferredLanguage,
  }) async {
    // Get current state
    final currentUser = state.value;
    if (currentUser == null || currentUser.isGuest) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      // Create updated user
      final updatedUser = currentUser.copyWith(
        userName: userName,
        email: email,
        phoneNumber: phoneNumber, // Added phoneNumber
        preferredLanguage: preferredLanguage,
      );

      // Save to repository (saveUser should handle all fields in AppUser)
      await _userRepository.saveUser(updatedUser);

      // Refresh state
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update user profile photo
  Future<void> updateProfilePhoto(File imageFile) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.isGuest) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      final folder = CloudinaryConfig.profileImagePath(currentUser.uid);
      // Upload image and get URL
      final result = await _cloudinaryService.uploadImage(imageFile, folder);
      final imageUrl = result['secure_url'];

      if (imageUrl != null) {
        // Update photo URL in repository
        await _userRepository.updateUserProfilePhoto(currentUser.uid, imageUrl);

        // Update local state
        final updatedUser = currentUser.copyWith(profilePhotoURL: imageUrl);
        state = AsyncValue.data(updatedUser);
      } else {
        // Handle upload failure
        throw Exception('Failed to upload profile photo');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // Optionally rethrow or handle specific errors
    }
  }


  /// Update user preferences
  Future<void> updatePreferences(List<String> preferences) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.isGuest) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      // Update preferences in repository
      await _userRepository.updateUserPreferences(
        currentUser.uid,
        preferences,
      );

      // Update local state
      final updatedUser = currentUser.copyWith(
        preferences: preferences,
      );

      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update user role (admin function)
  Future<void> updateRole(String role) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.isGuest) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      // Update role in repository
      await _userRepository.updateUserRole(currentUser.uid, role);

      // Update local state
      final updatedUser = currentUser.copyWith(
        role: role,
      );

      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Note: updatePreferredLanguage is now handled within updateProfile
  // If separate update is still desired, it can remain, but updateProfile also covers it.
  // Future<void> updatePreferredLanguage(String language) async { ... }
}

/// A widget that displays user data with error handling
class UserControllerWidget extends ConsumerWidget {
  final Widget Function(AppUser) builder;

  const UserControllerWidget({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userControllerProvider);

    return AsyncErrorHandler.withAsyncValue<AppUser>(
      value: userAsync,
      data: builder,
      loadingWidget: const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (error, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load user profile: ${error.toString()}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }
}

