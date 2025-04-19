// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userStreamHash() => r'ab75fe95823ed31dfea17f9fc7e80b48d5636576';

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

/// Provider for streaming user data
///
/// Copied from [userStream].
@ProviderFor(userStream)
const userStreamProvider = UserStreamFamily();

/// Provider for streaming user data
///
/// Copied from [userStream].
class UserStreamFamily extends Family<AsyncValue<AppUser?>> {
  /// Provider for streaming user data
  ///
  /// Copied from [userStream].
  const UserStreamFamily();

  /// Provider for streaming user data
  ///
  /// Copied from [userStream].
  UserStreamProvider call(
    String userId,
  ) {
    return UserStreamProvider(
      userId,
    );
  }

  @override
  UserStreamProvider getProviderOverride(
    covariant UserStreamProvider provider,
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
  String? get name => r'userStreamProvider';
}

/// Provider for streaming user data
///
/// Copied from [userStream].
class UserStreamProvider extends AutoDisposeStreamProvider<AppUser?> {
  /// Provider for streaming user data
  ///
  /// Copied from [userStream].
  UserStreamProvider(
    String userId,
  ) : this._internal(
          (ref) => userStream(
            ref as UserStreamRef,
            userId,
          ),
          from: userStreamProvider,
          name: r'userStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userStreamHash,
          dependencies: UserStreamFamily._dependencies,
          allTransitiveDependencies:
              UserStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserStreamProvider._internal(
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
    Stream<AppUser?> Function(UserStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserStreamProvider._internal(
        (ref) => create(ref as UserStreamRef),
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
  AutoDisposeStreamProviderElement<AppUser?> createElement() {
    return _UserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStreamProvider && other.userId == userId;
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
mixin UserStreamRef on AutoDisposeStreamProviderRef<AppUser?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserStreamProviderElement
    extends AutoDisposeStreamProviderElement<AppUser?> with UserStreamRef {
  _UserStreamProviderElement(super.provider);

  @override
  String get userId => (origin as UserStreamProvider).userId;
}

String _$userFavoritesHash() => r'f6afb3d5ae0c044ee147b5cfe40f77b6c501c275';

/// Provider for user favorites
///
/// Copied from [userFavorites].
@ProviderFor(userFavorites)
const userFavoritesProvider = UserFavoritesFamily();

/// Provider for user favorites
///
/// Copied from [userFavorites].
class UserFavoritesFamily extends Family<AsyncValue<List<Favorite>>> {
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
class UserFavoritesProvider extends AutoDisposeStreamProvider<List<Favorite>> {
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
    Stream<List<Favorite>> Function(UserFavoritesRef provider) create,
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
  AutoDisposeStreamProviderElement<List<Favorite>> createElement() {
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
mixin UserFavoritesRef on AutoDisposeStreamProviderRef<List<Favorite>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserFavoritesProviderElement
    extends AutoDisposeStreamProviderElement<List<Favorite>>
    with UserFavoritesRef {
  _UserFavoritesProviderElement(super.provider);

  @override
  String get userId => (origin as UserFavoritesProvider).userId;
}

String _$userControllerHash() => r'bbc652ac0c726cc86c86dab818485ed5d282aa2d';

/// A provider for the current user with profile management capabilities
///
/// Copied from [UserController].
@ProviderFor(UserController)
final userControllerProvider =
    AutoDisposeNotifierProvider<UserController, AsyncValue<AppUser>>.internal(
  UserController.new,
  name: r'userControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserController = AutoDisposeNotifier<AsyncValue<AppUser>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
