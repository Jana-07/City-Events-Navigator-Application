import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/core/utils/global_error_handler.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_controller.g.dart';

/// A provider for events with filtering and sorting capabilities
@riverpod
class EventsController extends _$EventsController {
  static const int _limit = 10;

  List<Event> _allEvents = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  AsyncValue<List<Event>> build(
      {String filter = 'all', String sortBy = 'date'}) {
    final eventsStream = ref.watch(eventsProvider);

    return eventsStream.when(
      data: (events) {
        _allEvents = events;
        _lastDocument = events.isNotEmpty
            ? events.last.snapshot
            : null;
        _hasMore = true;

        final filtered = _filterEvents(events, filter);
        _sortEvents(filtered, sortBy);
        return AsyncValue.data(filtered);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    );
  }

   Future<void> fetchMore({String filter = 'all', String sortBy = 'date'}) async {
    if (_isLoadingMore || !_hasMore || _lastDocument == null) return;

    _isLoadingMore = true;

    try {
      final repo = ref.read(eventRepositoryProvider);
      final (newEvents, newLastDoc) = await repo.fetchMoreEvents(
        limit: _limit,
        startAfterDocument: _lastDocument,
      );

      if (newEvents.isEmpty) {
        _hasMore = false;
      } else {
        _allEvents.addAll(newEvents);
        _lastDocument = newLastDoc;
      }

      final filtered = _filterEvents(_allEvents, filter);
      _sortEvents(filtered, sortBy);
      state = AsyncValue.data(filtered);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }

    _isLoadingMore = false;
  }

  // Filter events based on criteria
  List<Event> _filterEvents(List<Event> events, String filter) {
    switch (filter) {
      case 'upcoming':
        return events
            .where((event) => event.startDate.isAfter(DateTime.now()))
            .toList();
      case 'past':
        return events
            .where((event) => event.startDate.isBefore(DateTime.now()))
            .toList();
      //case 'featured':
      //return events.where((event) => event.isFeatured).toList();
      case 'popular':
        return events.where((event) => event.averageRating >= 4.0).toList();
      case 'all':
      default:
        return events;
    }
  }

  // Sort events based on criteria
  void _sortEvents(List<Event> events, String sortBy) {
    switch (sortBy) {
      case 'date':
        events.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case 'rating':
        events.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
      case 'name':
        events.sort((a, b) => a.title.compareTo(b.title));
        break;
      default:
        events.sort((a, b) => a.startDate.compareTo(b.startDate));
    }
  }

  // Add a new event
  Future<void> addEvent(Event event) async {
    state = const AsyncValue.loading();

    try {
      final eventRepository = ref.read(eventRepositoryProvider);
      await eventRepository.saveEvent(event);

      // Refresh the events list
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Update an existing event
  Future<void> updateEvent(String eventId, Map<String, dynamic> updates) async {
    state = const AsyncValue.loading();

    try {
      final eventRepository = ref.read(eventRepositoryProvider);
      //await eventRepository.saveEvent(eventId, updates);

      // Refresh the events list
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    state = const AsyncValue.loading();

    try {
      final eventRepository = ref.read(eventRepositoryProvider);
      await eventRepository.deleteEvent(eventId);

      // Refresh the events list
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// A widget that displays events with filtering and error handling
class EventsControllerWidget extends ConsumerWidget {
  final String filter;
  final String sortBy;
  final Widget Function(List<Event>) builder;

  const EventsControllerWidget({
    Key? key,
    this.filter = 'all',
    this.sortBy = 'date',
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync =
        ref.watch(eventsControllerProvider(filter: filter, sortBy: sortBy));

    return AsyncErrorHandler.withAsyncValue<List<Event>>(
      value: eventsAsync,
      data: builder,
      loadingWidget: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading events...'),
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
                'Failed to load events: ${error.toString()}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(eventsControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }
}
