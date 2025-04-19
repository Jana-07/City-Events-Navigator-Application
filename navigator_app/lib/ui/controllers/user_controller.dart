import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/data/models/favorite.dart';
import 'package:navigator_app/data/repositories/user_repository.dart';
import 'package:navigator_app/core/utils/global_error_handler.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

part 'user_controller.g.dart';

/// A provider for the current user with profile management capabilities
@riverpod
class UserController extends _$UserController {
  late final UserRepository _userRepository;

  @override
  AsyncValue<AppUser> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

//   @override
//   AsyncValue<AppUser> build() {
//   _userRepository = ref.watch(userRepositoryProvider);

//   // Get the current user ID from the auth state
//   final authState = ref.watch(authStateChangesProvider);

//   // Return guest user if not authenticated
//   if (authState == null) {
//     return AsyncValue.data(AppUser.guest());
//   }

//   try {
//     // Get the user from the repository
//     final user = _userRepository.getUser(authState.uid);

//     if (user == null) {
//       //throwExcpetioon
//       ;
//     }

//     return AsyncValue.data(user);
//   } catch (e, st) {
//     return AsyncValue.error(e, st);
//   }
// }

  /// Update user profile information
  Future<void> updateProfile({
    String? userName,
    String? email,
    String? preferredLanguage,
  }) async {
    // Get current state
    final currentUser = state.value;
    if (currentUser == null || currentUser.uid == 'guest') {
      return;
    }

    // Create updated user
    final updatedUser = currentUser.copyWith(
      userName: userName,
      email: email,
      preferredLanguage: preferredLanguage,
    );

    // Save to repository
    await _userRepository.saveUser(updatedUser);

    // Refresh state
    state = AsyncValue.data(updatedUser);
  }

  /// Update user preferences
  Future<void> updatePreferences(List<String> preferences) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.uid == 'guest') {
      return;
    }

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
  }

  // /// Update user profile photo
  // Future<void> updateProfilePhoto(File imageFile) async {
  //   final currentUser = state.value;
  //   if (currentUser == null || currentUser.uid == 'guest') {
  //     return;
  //   }

  //   // Set loading state
  //   state = const AsyncValue.loading();

  //   try {
  //     // Upload image to Cloudinary
  //     final result = await _cloudinaryService.uploadImage(
  //       imageFile,
  //       'user_profiles',
  //     );

  //     // Get secure URL from result
  //     final photoURL = result['secure_url'] as String;

  //     // Update user profile photo URL in repository
  //     await _userRepository.updateUserProfilePhoto(
  //       currentUser.uid,
  //       photoURL,
  //     );

  //     // Update local state
  //     final updatedUser = currentUser.copyWith(
  //       profilePhotoURL: photoURL,
  //     );

  //     state = AsyncValue.data(updatedUser);
  //   } catch (error, stackTrace) {
  //     // Handle error
  //     state = AsyncValue.error(error, stackTrace);
  //   }
  // }

  /// Add event to favorites
  Future<void> addFavorite(Favorite favorite) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.uid == 'guest') {
      return;
    }

    await _userRepository.addFavorite(currentUser.uid, favorite);
  }

  /// Remove event from favorites
  Future<void> removeFavorite(String favoriteId) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.uid == 'guest') {
      return;
    }

    await _userRepository.removeFavorite(currentUser.uid, favoriteId);
  }

  /// Check if an event is in favorites
  Future<bool> isEventFavorite(String eventId) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.uid == 'guest') {
      return false;
    }

    return _userRepository.isEventFavorite(currentUser.uid, eventId);
  }

  /// Get all favorites for current user
  Future<List<Favorite>> getFavorites() async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.uid == 'guest') {
      return [];
    }

    return _userRepository.getUserFavorites(currentUser.uid);
  }

  /// Update user role (admin function)
  Future<void> updateRole(String role) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.uid == 'guest') {
      return;
    }

    // Update role in repository
    await _userRepository.updateUserRole(currentUser.uid, role);

    // Update local state
    final updatedUser = currentUser.copyWith(
      role: role,
    );

    state = AsyncValue.data(updatedUser);
  }
}

/// Provider for streaming user data
@riverpod
Stream<AppUser?> userStream(UserStreamRef ref, String userId) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.streamUser(userId);
}

/// Provider for user favorites
@riverpod
Stream<List<Favorite>> userFavorites(UserFavoritesRef ref, String userId) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.streamUserFavorites(userId);
}

/// A widget that displays user data with error handling
class UserControllerWidget extends ConsumerWidget {
  final Widget Function(AppUser) builder;

  const UserControllerWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userControllerProvider);

    return AsyncErrorHandler.withAsyncValue<AppUser>(
      value: userAsync,
      data: builder,
      loadingWidget: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading user profile...'),
          ],
        ),
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
