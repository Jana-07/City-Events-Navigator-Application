// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_rivrpod_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'9d3a38240e59bad3c1a3a8d2c9e63221e7edbcaa';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<FirebaseAuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<FirebaseAuthRepository>;
String _$firebaseAuthHash() => r'cb440927c3ab863427fd4b052a8ccba4c024c863';

/// See also [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = Provider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = ProviderRef<FirebaseAuth>;
String _$authStateChangesHash() => r'a1b9482faf4fc283120e39f74633d06aaebdcff3';

/// See also [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider = StreamProvider<AppUser?>.internal(
  authStateChanges,
  name: r'authStateChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateChangesRef = StreamProviderRef<AppUser?>;
String _$firebaseFirestoreHash() => r'da44e0544482927855093596d84cb41842b27214';

/// Provider for Firebase Firestore instance
///
/// Copied from [firebaseFirestore].
@ProviderFor(firebaseFirestore)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>.internal(
  firebaseFirestore,
  name: r'firebaseFirestoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseFirestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseFirestoreRef = ProviderRef<FirebaseFirestore>;
String _$firestoreServiceHash() => r'78edf1649a8138d2799ca25181d24514f89e69ac';

/// Provider for FirestoreService
///
/// Copied from [firestoreService].
@ProviderFor(firestoreService)
final firestoreServiceProvider = Provider<FirestoreService>.internal(
  firestoreService,
  name: r'firestoreServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firestoreServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirestoreServiceRef = ProviderRef<FirestoreService>;
String _$userFavoritesHash() => r'c9082ae9f9c839a937a00f440331e3b10eabd589';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for user favorites
///
/// Copied from [userFavorites].
@ProviderFor(userFavorites)
const userFavoritesProvider = UserFavoritesFamily();

/// Provider for user favorites
///
/// Copied from [userFavorites].
class UserFavoritesFamily extends Family<AsyncValue<List<FavoriteEvent>>> {
  /// Provider for user favorites
  ///
  /// Copied from [userFavorites].
  const UserFavoritesFamily();

  /// Provider for user favorites
  ///
  /// Copied from [userFavorites].
  UserFavoritesProvider call(
    String userId,
  ) {
    return UserFavoritesProvider(
      userId,
    );
  }

  @override
  UserFavoritesProvider getProviderOverride(
    covariant UserFavoritesProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userFavoritesProvider';
}

/// Provider for user favorites
///
/// Copied from [userFavorites].
class UserFavoritesProvider
    extends AutoDisposeStreamProvider<List<FavoriteEvent>> {
  /// Provider for user favorites
  ///
  /// Copied from [userFavorites].
  UserFavoritesProvider(
    String userId,
  ) : this._internal(
          (ref) => userFavorites(
            ref as UserFavoritesRef,
            userId,
          ),
          from: userFavoritesProvider,
          name: r'userFavoritesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userFavoritesHash,
          dependencies: UserFavoritesFamily._dependencies,
          allTransitiveDependencies:
              UserFavoritesFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserFavoritesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<FavoriteEvent>> Function(UserFavoritesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserFavoritesProvider._internal(
        (ref) => create(ref as UserFavoritesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<FavoriteEvent>> createElement() {
    return _UserFavoritesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserFavoritesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserFavoritesRef on AutoDisposeStreamProviderRef<List<FavoriteEvent>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserFavoritesProviderElement
    extends AutoDisposeStreamProviderElement<List<FavoriteEvent>>
    with UserFavoritesRef {
  _UserFavoritesProviderElement(super.provider);

  @override
  String get userId => (origin as UserFavoritesProvider).userId;
}

String _$userRepositoryHash() => r'496e56d7758f17e88e1607c43cff9b58dbeb2d4d';

/// Provider for UserRepository
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$eventRepositoryHash() => r'5e6df19e4818627b59818e4f311fd2cd92b53da4';

/// Provider for EventRepository
///
/// Copied from [eventRepository].
@ProviderFor(eventRepository)
final eventRepositoryProvider = Provider<EventRepository>.internal(
  eventRepository,
  name: r'eventRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventRepositoryRef = ProviderRef<EventRepository>;
String _$currentUserHash() => r'67a7c2b913cfea28be75f59019f597b9fa1a01d8';

/// Stream provider for current user data
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeStreamProvider<AppUser?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeStreamProviderRef<AppUser?>;
String _$userRoleHash() => r'96d1f6275833691510957de327a491bc49342a23';

/// Provider for current user role
///
/// Copied from [userRole].
@ProviderFor(userRole)
final userRoleProvider = AutoDisposeStreamProvider<String>.internal(
  userRole,
  name: r'userRoleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userRoleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRoleRef = AutoDisposeStreamProviderRef<String>;
String _$eventsHash() => r'ee84d35b2989fad2ad87e4968201e86ce91578f9';

/// See also [events].
@ProviderFor(events)
final eventsProvider = AutoDisposeStreamProvider<List<Event>>.internal(
  events,
  name: r'eventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsRef = AutoDisposeStreamProviderRef<List<Event>>;
String _$getEventByIdHash() => r'b8866f2e6844f5fc34b8eaa93bc4b2ff10bb74ed';

/// See also [getEventById].
@ProviderFor(getEventById)
const getEventByIdProvider = GetEventByIdFamily();

/// See also [getEventById].
class GetEventByIdFamily extends Family<AsyncValue<Event?>> {
  /// See also [getEventById].
  const GetEventByIdFamily();

  /// See also [getEventById].
  GetEventByIdProvider call(
    String eventId,
  ) {
    return GetEventByIdProvider(
      eventId,
    );
  }

  @override
  GetEventByIdProvider getProviderOverride(
    covariant GetEventByIdProvider provider,
  ) {
    return call(
      provider.eventId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getEventByIdProvider';
}

/// See also [getEventById].
class GetEventByIdProvider extends AutoDisposeFutureProvider<Event?> {
  /// See also [getEventById].
  GetEventByIdProvider(
    String eventId,
  ) : this._internal(
          (ref) => getEventById(
            ref as GetEventByIdRef,
            eventId,
          ),
          from: getEventByIdProvider,
          name: r'getEventByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getEventByIdHash,
          dependencies: GetEventByIdFamily._dependencies,
          allTransitiveDependencies:
              GetEventByIdFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  GetEventByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<Event?> Function(GetEventByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetEventByIdProvider._internal(
        (ref) => create(ref as GetEventByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Event?> createElement() {
    return _GetEventByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetEventByIdProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetEventByIdRef on AutoDisposeFutureProviderRef<Event?> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _GetEventByIdProviderElement
    extends AutoDisposeFutureProviderElement<Event?> with GetEventByIdRef {
  _GetEventByIdProviderElement(super.provider);

  @override
  String get eventId => (origin as GetEventByIdProvider).eventId;
}

String _$getUserByIdHash() => r'85ef9ea865769ea1bace5e2858cd424ebd6d4a5b';

/// See also [getUserById].
@ProviderFor(getUserById)
const getUserByIdProvider = GetUserByIdFamily();

/// See also [getUserById].
class GetUserByIdFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [getUserById].
  const GetUserByIdFamily();

  /// See also [getUserById].
  GetUserByIdProvider call(
    String userId,
  ) {
    return GetUserByIdProvider(
      userId,
    );
  }

  @override
  GetUserByIdProvider getProviderOverride(
    covariant GetUserByIdProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getUserByIdProvider';
}

/// See also [getUserById].
class GetUserByIdProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [getUserById].
  GetUserByIdProvider(
    String userId,
  ) : this._internal(
          (ref) => getUserById(
            ref as GetUserByIdRef,
            userId,
          ),
          from: getUserByIdProvider,
          name: r'getUserByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserByIdHash,
          dependencies: GetUserByIdFamily._dependencies,
          allTransitiveDependencies:
              GetUserByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  GetUserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(GetUserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserByIdProvider._internal(
        (ref) => create(ref as GetUserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _GetUserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetUserByIdRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _GetUserByIdProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?> with GetUserByIdRef {
  _GetUserByIdProviderElement(super.provider);

  @override
  String get userId => (origin as GetUserByIdProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
