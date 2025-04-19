import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/data/repositories/event_repository.dart';
import 'package:navigator_app/data/repositories/firebase_auth_repository.dart';
import 'package:navigator_app/data/repositories/user_repository.dart';
import 'package:navigator_app/data/services/cloudinary_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:navigator_app/data/models/app_user.dart';

import '../data/services/firestore_service.dart';

part 'firebase_rivrpod_provider.g.dart';


@Riverpod(keepAlive: true)
FirebaseAuthRepository authRepository(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(auth);
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(Ref ref) {
  final auth = ref.watch(authRepositoryProvider);
  return auth.authStateChanges();
}

/// Provider for Firebase Firestore instance
@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

/// Provider for FirestoreService
@Riverpod(keepAlive: true)
FirestoreService firestoreService(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirestoreService(firestore: firestore);
}


// /// Provider for FirestoreService
// @Riverpod(keepAlive: true)
// CloudinaryService cloudinaryService(Ref ref) {
//   return cloudinaryService(ref);
// }

/// Provider for UserRepository
@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserRepository(firestoreService);
}

/// Provider for EventRepository
@Riverpod(keepAlive: true)
EventRepository eventRepository(Ref ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return EventRepository(firestoreService, CloudinaryService());
}


/// Stream provider for current user data
@riverpod
Stream<AppUser?> currentUser(Ref ref) {
  final authStateChanges = ref.watch(authStateChangesProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  
  return authStateChanges.when(
    data: (user) {
      if (user == null) {
        return Stream.value(AppUser.guest());
      }
      return userRepository.streamUser(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(AppUser.guest()),
  );
}

/// Provider for current user role
@riverpod
Stream<String> userRole(Ref ref) {
  final currentUser = ref.watch(currentUserProvider);
  
  return currentUser.when(
    data: (user) {
      if (user == null) {
        return Stream.value('guest');
      }
      return Stream.value(user.role);
    },
    loading: () => Stream.value('guest'),
    error: (_, __) => Stream.value('guest'),
  );
}

@riverpod
Stream<List<Event>> events(Ref ref) {
  final eventRepository = ref.watch(eventRepositoryProvider);
  return eventRepository.streamEvents();
}
