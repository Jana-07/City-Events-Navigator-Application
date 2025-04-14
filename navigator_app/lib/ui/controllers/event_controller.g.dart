// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsControllerHash() => r'c0edad45b909fbe8d7cda107846417ec6d24eed6';

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
    extends BuildlessAutoDisposeNotifier<AsyncValue<List<Event>>> {
  late final String filter;
  late final String sortBy;

  AsyncValue<List<Event>> build({
    String filter = 'all',
    String sortBy = 'date',
  });
}

/// A provider for events with filtering and sorting capabilities
///
/// Copied from [EventsController].
@ProviderFor(EventsController)
const eventsControllerProvider = EventsControllerFamily();

/// A provider for events with filtering and sorting capabilities
///
/// Copied from [EventsController].
class EventsControllerFamily extends Family<AsyncValue<List<Event>>> {
  /// A provider for events with filtering and sorting capabilities
  ///
  /// Copied from [EventsController].
  const EventsControllerFamily();

  /// A provider for events with filtering and sorting capabilities
  ///
  /// Copied from [EventsController].
  EventsControllerProvider call({
    String filter = 'all',
    String sortBy = 'date',
  }) {
    return EventsControllerProvider(
      filter: filter,
      sortBy: sortBy,
    );
  }

  @override
  EventsControllerProvider getProviderOverride(
    covariant EventsControllerProvider provider,
  ) {
    return call(
      filter: provider.filter,
      sortBy: provider.sortBy,
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

/// A provider for events with filtering and sorting capabilities
///
/// Copied from [EventsController].
class EventsControllerProvider extends AutoDisposeNotifierProviderImpl<
    EventsController, AsyncValue<List<Event>>> {
  /// A provider for events with filtering and sorting capabilities
  ///
  /// Copied from [EventsController].
  EventsControllerProvider({
    String filter = 'all',
    String sortBy = 'date',
  }) : this._internal(
          () => EventsController()
            ..filter = filter
            ..sortBy = sortBy,
          from: eventsControllerProvider,
          name: r'eventsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventsControllerHash,
          dependencies: EventsControllerFamily._dependencies,
          allTransitiveDependencies:
              EventsControllerFamily._allTransitiveDependencies,
          filter: filter,
          sortBy: sortBy,
        );

  EventsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
    required this.sortBy,
  }) : super.internal();

  final String filter;
  final String sortBy;

  @override
  AsyncValue<List<Event>> runNotifierBuild(
    covariant EventsController notifier,
  ) {
    return notifier.build(
      filter: filter,
      sortBy: sortBy,
    );
  }

  @override
  Override overrideWith(EventsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventsControllerProvider._internal(
        () => create()
          ..filter = filter
          ..sortBy = sortBy,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
        sortBy: sortBy,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<EventsController, AsyncValue<List<Event>>>
      createElement() {
    return _EventsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventsControllerProvider &&
        other.filter == filter &&
        other.sortBy == sortBy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);
    hash = _SystemHash.combine(hash, sortBy.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventsControllerRef
    on AutoDisposeNotifierProviderRef<AsyncValue<List<Event>>> {
  /// The parameter `filter` of this provider.
  String get filter;

  /// The parameter `sortBy` of this provider.
  String get sortBy;
}

class _EventsControllerProviderElement
    extends AutoDisposeNotifierProviderElement<EventsController,
        AsyncValue<List<Event>>> with EventsControllerRef {
  _EventsControllerProviderElement(super.provider);

  @override
  String get filter => (origin as EventsControllerProvider).filter;
  @override
  String get sortBy => (origin as EventsControllerProvider).sortBy;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
