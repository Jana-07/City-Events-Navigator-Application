import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigator_app/data/models/favorite.dart';
import 'package:navigator_app/data/services/firestore_service.dart';
import 'package:navigator_app/data/models/app_user.dart';

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
    List<String> preferences,
  ) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.updateDocument(
      'users/$userId',
      {'preferences': preferences},
    );
  }

  // Update user preferred language
  Future<void> updateUserPreferredLanguage(
    String userId,
    String language,
  ) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.updateDocument(
      'users/$userId',
      {'preferredLanguage': language},
    );
  }

  // Update user profile photo URL
  Future<void> updateUserProfilePhoto(
    String userId,
    String photoURL,
  ) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.updateDocument(
      'users/$userId',
      {'profilePhotoURL': photoURL},
    );
  }

  // Add event to user's hosted events
  Future<void> addHostedEvent(
    String userId,
    String eventId,
  ) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.updateDocument(
      'users/$userId',
      {
        'eventsHosted': FieldValue.arrayUnion([eventId]),
      },
    );
  }

  // Remove event from user's hosted events
  Future<void> removeHostedEvent(
    String userId,
    String eventId,
  ) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.updateDocument(
      'users/$userId',
      {
        'eventsHosted': FieldValue.arrayRemove([eventId]),
      },
    );
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.deleteDocument('users/$userId');
  }

  // FAVORITES SUBCOLLECTION METHODS

  // Get all favorites for a user
  Future<List<FavoriteEvent>> getUserFavorites(String userId) async {
    if (userId == 'guest') {
      return [];
    }

    final snapshot = await _firestoreService.getCollection(
      'users/$userId/favorites',
      queryBuilder: (query) => query.orderBy('addedAt', descending: true),
    );

    return snapshot.docs.map((doc) => FavoriteEvent.fromDocument(doc)).toList();
  }

  // Stream all favorites for a user
  Stream<List<FavoriteEvent>> streamUserFavorites(String userId, {int? limit}) {
    if (userId == 'guest') {
      return Stream.value([]);
    }

    return _firestoreService.streamCollection(
      'users/$userId/favorites',
      queryBuilder: (query) {
        var q = query.orderBy('addedAt', descending: true);
        if (limit != null) {
          q = q.limit(limit);
        }
        return q;
      },
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) => FavoriteEvent.fromDocument(doc))
          .toList();
    });
  }

  // Add event to favorites
  Future<void> addFavorite(String userId, FavoriteEvent favorite) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.setDocument(
      'users/$userId/favorites/${favorite.id}',
      favorite.toMap(),
    );
  }

  // Remove event from favorites
  Future<void> removeFavorite(String userId, String favoriteId) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService
        .deleteDocument('users/$userId/favorites/$favoriteId');
  }

  // Update favorite notification settings
  Future<void> updateFavoriteNotification(
    String userId,
    String favoriteId,
    bool notify,
    int reminderTime,
  ) async {
    if (userId == 'guest') {
      return;
    }

    await _firestoreService.updateDocument(
      'users/$userId/favorites/$favoriteId',
      {
        'notify': notify,
        'reminderTime': reminderTime,
      },
    );
  }

  // Check if an event is in favorites
  Future<bool> isEventFavorite(String userId, String eventId) async {
    if (userId == 'guest') {
      return false;
    }

    final snapshot = await _firestoreService.getCollection(
      'users/$userId/favorites',
      queryBuilder: (query) => query.where('eventRef',
          isEqualTo: FirebaseFirestore.instance.doc('events/$eventId')),
      limit: 1,
    );

    return snapshot.docs.isNotEmpty;
  }
}
