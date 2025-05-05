// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsControllerHash() => r'593a6bc4cadc079c60284d2cd6bc19d21688153e';

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

abstract class _$EventsController
    extends BuildlessAutoDisposeAsyncNotifier<List<Event>> {
  late final String listId;

  FutureOr<List<Event>> build(
    String listId,
  );
}

/// See also [EventsController].
@ProviderFor(EventsController)
const eventsControllerProvider = EventsControllerFamily();

/// See also [EventsController].
class EventsControllerFamily extends Family<AsyncValue<List<Event>>> {
  /// See also [EventsController].
  const EventsControllerFamily();

  /// See also [EventsController].
  EventsControllerProvider call(
    String listId,
  ) {
    return EventsControllerProvider(
      listId,
    );
  }

  @override
  EventsControllerProvider getProviderOverride(
    covariant EventsControllerProvider provider,
  ) {
    return call(
      provider.listId,
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
  String? get name => r'eventsControllerProvider';
}

/// See also [EventsController].
class EventsControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EventsController, List<Event>> {
  /// See also [EventsController].
  EventsControllerProvider(
    String listId,
  ) : this._internal(
          () => EventsController()..listId = listId,
          from: eventsControllerProvider,
          name: r'eventsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventsControllerHash,
          dependencies: EventsControllerFamily._dependencies,
          allTransitiveDependencies:
              EventsControllerFamily._allTransitiveDependencies,
          listId: listId,
        );

  EventsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listId,
  }) : super.internal();

  final String listId;

  @override
  FutureOr<List<Event>> runNotifierBuild(
    covariant EventsController notifier,
  ) {
    return notifier.build(
      listId,
    );
  }

  @override
  Override overrideWith(EventsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventsControllerProvider._internal(
        () => create()..listId = listId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listId: listId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EventsController, List<Event>>
      createElement() {
    return _EventsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventsControllerProvider && other.listId == listId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventsControllerRef on AutoDisposeAsyncNotifierProviderRef<List<Event>> {
  /// The parameter `listId` of this provider.
  String get listId;
}

class _EventsControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventsController,
        List<Event>> with EventsControllerRef {
  _EventsControllerProviderElement(super.provider);

  @override
  String get listId => (origin as EventsControllerProvider).listId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
