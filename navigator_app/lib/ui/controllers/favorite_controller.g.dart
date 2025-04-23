// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isEventFavoriteHash() => r'dc92a9cfcb3fa029416dd38c6e0df9b1a77daa94';

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

/// Provider to check if an event is favorited
///
/// Copied from [isEventFavorite].
@ProviderFor(isEventFavorite)
const isEventFavoriteProvider = IsEventFavoriteFamily();

/// Provider to check if an event is favorited
///
/// Copied from [isEventFavorite].
class IsEventFavoriteFamily extends Family<AsyncValue<bool>> {
  /// Provider to check if an event is favorited
  ///
  /// Copied from [isEventFavorite].
  const IsEventFavoriteFamily();

  /// Provider to check if an event is favorited
  ///
  /// Copied from [isEventFavorite].
  IsEventFavoriteProvider call(
    String eventId,
  ) {
    return IsEventFavoriteProvider(
      eventId,
    );
  }

  @override
  IsEventFavoriteProvider getProviderOverride(
    covariant IsEventFavoriteProvider provider,
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
  String? get name => r'isEventFavoriteProvider';
}

/// Provider to check if an event is favorited
///
/// Copied from [isEventFavorite].
class IsEventFavoriteProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider to check if an event is favorited
  ///
  /// Copied from [isEventFavorite].
  IsEventFavoriteProvider(
    String eventId,
  ) : this._internal(
          (ref) => isEventFavorite(
            ref as IsEventFavoriteRef,
            eventId,
          ),
          from: isEventFavoriteProvider,
          name: r'isEventFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isEventFavoriteHash,
          dependencies: IsEventFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsEventFavoriteFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  IsEventFavoriteProvider._internal(
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
    FutureOr<bool> Function(IsEventFavoriteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsEventFavoriteProvider._internal(
        (ref) => create(ref as IsEventFavoriteRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsEventFavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsEventFavoriteProvider && other.eventId == eventId;
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
mixin IsEventFavoriteRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _IsEventFavoriteProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsEventFavoriteRef {
  _IsEventFavoriteProviderElement(super.provider);

  @override
  String get eventId => (origin as IsEventFavoriteProvider).eventId;
}

String _$userFavoritesStreamHash() =>
    r'10d1cc236c6002ced1cd4429b03c031a8f004f14';

/// Provider for user favorites stream
///
/// Copied from [userFavoritesStream].
@ProviderFor(userFavoritesStream)
final userFavoritesStreamProvider =
    AutoDisposeStreamProvider<List<FavoriteEvent>>.internal(
  userFavoritesStream,
  name: r'userFavoritesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userFavoritesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserFavoritesStreamRef
    = AutoDisposeStreamProviderRef<List<FavoriteEvent>>;
String _$eventFavoriteStatusHash() =>
    r'ae9772518d6106c0f11f2ec61721ae26c858a15e';

abstract class _$EventFavoriteStatus
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String eventId;

  FutureOr<bool> build(
    String eventId,
  );
}

/// See also [EventFavoriteStatus].
@ProviderFor(EventFavoriteStatus)
const eventFavoriteStatusProvider = EventFavoriteStatusFamily();

/// See also [EventFavoriteStatus].
class EventFavoriteStatusFamily extends Family<AsyncValue<bool>> {
  /// See also [EventFavoriteStatus].
  const EventFavoriteStatusFamily();

  /// See also [EventFavoriteStatus].
  EventFavoriteStatusProvider call(
    String eventId,
  ) {
    return EventFavoriteStatusProvider(
      eventId,
    );
  }

  @override
  EventFavoriteStatusProvider getProviderOverride(
    covariant EventFavoriteStatusProvider provider,
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
  String? get name => r'eventFavoriteStatusProvider';
}

/// See also [EventFavoriteStatus].
class EventFavoriteStatusProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EventFavoriteStatus, bool> {
  /// See also [EventFavoriteStatus].
  EventFavoriteStatusProvider(
    String eventId,
  ) : this._internal(
          () => EventFavoriteStatus()..eventId = eventId,
          from: eventFavoriteStatusProvider,
          name: r'eventFavoriteStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventFavoriteStatusHash,
          dependencies: EventFavoriteStatusFamily._dependencies,
          allTransitiveDependencies:
              EventFavoriteStatusFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventFavoriteStatusProvider._internal(
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
  FutureOr<bool> runNotifierBuild(
    covariant EventFavoriteStatus notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventFavoriteStatus Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventFavoriteStatusProvider._internal(
        () => create()..eventId = eventId,
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
  AutoDisposeAsyncNotifierProviderElement<EventFavoriteStatus, bool>
      createElement() {
    return _EventFavoriteStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventFavoriteStatusProvider && other.eventId == eventId;
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
mixin EventFavoriteStatusRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventFavoriteStatusProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventFavoriteStatus, bool>
    with EventFavoriteStatusRef {
  _EventFavoriteStatusProviderElement(super.provider);

  @override
  String get eventId => (origin as EventFavoriteStatusProvider).eventId;
}

String _$favoriteControllerHash() =>
    r'e86f749f6760bfa54676604dad3dcf7b439e7dfb';

/// A controller for managing favorite events
///
/// Copied from [FavoriteController].
@ProviderFor(FavoriteController)
final favoriteControllerProvider =
    AsyncNotifierProvider<FavoriteController, void>.internal(
  FavoriteController.new,
  name: r'favoriteControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FavoriteController = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
