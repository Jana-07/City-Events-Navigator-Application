import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:navigator_app/data/models/favorite.dart';
import 'package:navigator_app/data/repositories/user_repository.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

part 'favorite_controller.g.dart';

@riverpod
class EventFavoriteStatus extends _$EventFavoriteStatus {
  @override
  FutureOr<bool> build(String eventId) async {
    return ref
        .read(favoriteControllerProvider.notifier)
        .isEventFavorite(eventId);
  }

  // Update status
  void setStatus(bool isFavorite) {
    state = AsyncValue.data(isFavorite);
  }
}

/// A controller for managing favorite events
@Riverpod(keepAlive: true)
class FavoriteController extends _$FavoriteController {
  late final UserRepository _userRepository;
  // Cache for favorites to reduce database queries
  final Map<String, bool> _favoritesCache = {};

  @override
  FutureOr<void> build() {
    _userRepository = ref.watch(userRepositoryProvider);

    // Listen to auth changes to clear cache when user changes
    ref.listen(authStateChangesProvider, (_, __) {
      _favoritesCache.clear();
    });

    // Prefetch favorites for current user
    _prefetchFavorites();

    return Future.value();
  }

  // Get current user ID from auth state
  String? _getCurrentUserId() {
    final authState = ref.read(authStateChangesProvider);
    return authState.value?.uid;
  }

  // Check if user is logged in
  bool _isUserLoggedIn() {
    final userId = _getCurrentUserId();
    return userId != null && userId != 'guest';
  }

  // Prefetch favorites to populate cache
  Future<void> _prefetchFavorites() async {
    if (!_isUserLoggedIn()) return;

    final userId = _getCurrentUserId()!;
    try {
      final favorites = await _userRepository.getUserFavorites(userId);
      for (var fav in favorites) {
        _favoritesCache[fav.id] = true;
      }
    } catch (e) {
      debugPrint('Failed to prefetch favorites: $e');
    }
  }

  // Check if event is favorite using cache first
  Future<bool> isEventFavorite(String eventId) async {
    // First check cache
    if (_favoritesCache.containsKey(eventId)) {
      return _favoritesCache[eventId]!;
    }

    if (!_isUserLoggedIn()) return false;

    final userId = _getCurrentUserId()!;
    try {
      final isFavorite = await _userRepository.isEventFavorite(userId, eventId);
      // Update cache
      _favoritesCache[eventId] = isFavorite;
      return isFavorite;
    } catch (e) {
      debugPrint('Error checking favorite: $e');
      return false;
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite({
    required FavoriteEvent event,
    required BuildContext context,
  }) async {
    if (!_isUserLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login required to favorite events")),
      );
      return;
    }

    final userId = _getCurrentUserId()!;
    try {
      final isFav = await isEventFavorite(event.id);

      if (isFav) {
        await _userRepository.removeFavorite(userId, event.id);
        _favoritesCache[event.id] = false;
      } else {
        await _userRepository.addFavorite(userId, event);
        _favoritesCache[event.id] = true;
      }

      // Notify listeners that favorites have changed
      ref.invalidate(userFavoritesStreamProvider);
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Get all favorites
  Future<List<FavoriteEvent>> getFavorites() async {
    if (!_isUserLoggedIn()) return [];

    final userId = _getCurrentUserId()!;
    try {
      final favorites = await _userRepository.getUserFavorites(userId);
      // Update cache
      for (var fav in favorites) {
        _favoritesCache[fav.id] = true;
      }
      return favorites;
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  // Stream favorites
  Stream<List<FavoriteEvent>> streamFavorites({int? limit}) {
    if (!_isUserLoggedIn()) return Stream.value([]);

    final userId = _getCurrentUserId()!;
    if (limit != null) {
      return _userRepository.streamUserFavorites(userId, limit: limit);
    }
    return _userRepository.streamUserFavorites(userId);
  }
}

/// Provider to check if an event is favorited
@riverpod
Future<bool> isEventFavorite(Ref ref, String eventId) async {
  return ref.read(favoriteControllerProvider.notifier).isEventFavorite(eventId);
}

/// Provider for user favorites stream
@riverpod
Stream<List<FavoriteEvent>> userFavoritesStream(Ref ref, int? limit) {
  final favoriteController = ref.watch(favoriteControllerProvider.notifier);
  if (limit != null) {
    return favoriteController.streamFavorites(limit: limit);
  }

  return favoriteController.streamFavorites();
}
