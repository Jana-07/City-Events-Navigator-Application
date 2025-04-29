import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/core/utils/global_error_handler.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/data/repositories/event_repository.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart'; 
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_controller.g.dart'; // Assuming generated part file

/// A provider for events with filtering, sorting, and pagination capabilities
@riverpod
class EventsController extends _$EventsController {
  static const int _limit = 10;

  // Internal state for pagination cursor and status
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  late String _currentFilter;
  late String _currentSortBy;

  EventRepository get _repository => ref.read(eventRepositoryProvider);

  String? get _currentUserId => ref.watch(authStateChangesProvider).value?.uid;

  @override
  Future<List<Event>> build({String filter = 'all', String sortBy = 'date'}) async {
    _currentFilter = filter;
    _currentSortBy = sortBy;

    // Reset pagination state when filter/sort changes (or on initial build)
    _lastDocument = null;
    _hasMore = true;
    _isLoadingMore = false;

     String? creatorIdFilter;
    if (_currentFilter == 'organizer') {
      creatorIdFilter = _currentUserId;
      if (creatorIdFilter == null) {
        _hasMore = false;
        return [];
      }
    }

    final (initialEvents, initialLastDoc) = await _repository.fetchEvents(
      limit: _limit,
      sortBy: _currentSortBy,
      creatorId: creatorIdFilter,
    );

    _lastDocument = initialLastDoc;
    _hasMore = initialEvents.length == _limit;

    // Apply filtering locally after fetching
    final filteredEvents = _filterEventsLocally(initialEvents, _currentFilter);
    _sortEvents(filteredEvents, _currentSortBy);

    return filteredEvents;
  }

  Future<void> fetchMore() async {
    if (_isLoadingMore || !_hasMore || _lastDocument == null) return;

    _isLoadingMore = true;

    String? creatorIdFilter;
    if (_currentFilter == 'organizer') {
      creatorIdFilter = _currentUserId;
      // If user logs out while paginating 'mine', stop fetching
      if (creatorIdFilter == null) {
        _isLoadingMore = false;
        _hasMore = false; 
        return;
      }
    }

    final currentEvents = state.valueOrNull ?? [];

    try {
      final (newEvents, newLastDoc) = await _repository.fetchMoreEvents(
        limit: _limit,
        startAfterDocument: _lastDocument!,
        sortBy: _currentSortBy,
        creatorId: creatorIdFilter,
      );

      _lastDocument = newLastDoc;
      _hasMore = newEvents.length == _limit;

      // Combine old and new events
      final combinedEvents = List<Event>.from(currentEvents)..addAll(newEvents);

      // Apply filtering and sorting to the combined list
      final filteredEvents = _filterEventsLocally(combinedEvents, _currentFilter);
      _sortEvents(filteredEvents, _currentSortBy);

      // Update the state with the new combined, filtered, and sorted list
      state = AsyncData(filteredEvents);

    } catch (e, st) {
      debugPrint('Error fetching more events: $e\n$st');
    } finally {
      _isLoadingMore = false;
    }
  }

  // Filter events based on criteria (returns a new list)
  List<Event> _filterEventsLocally(List<Event> events, String filter) {
    // Create a mutable copy to avoid modifying the original list directly
    List<Event> mutableEvents = List.from(events);
    switch (filter) {
      case 'upcoming':
        return mutableEvents
            .where((event) => event.startDate.isAfter(DateTime.now()))
            .toList();
      case 'past':
        return mutableEvents
            .where((event) => event.startDate.isBefore(DateTime.now()))
            .toList();
      case 'popular':
        return mutableEvents.where((event) => (event.averageRating ?? 0) >= 4.0).toList();
      case 'all':
      case 'organizer':
      default:
        return mutableEvents;
    }
  }

  // Sort events based on criteria
  void _sortEvents(List<Event> events, String sortBy) {
    switch (sortBy) {
      case 'date':
        events.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case 'rating':
        events.sort((a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0));
        break;
      case 'name':
        events.sort((a, b) => a.title.compareTo(b.title));
        break;
      default:
        events.sort((a, b) => a.startDate.compareTo(b.startDate)); // Default sort
    }
  }

  Future<void> addEvent(Event event) async {
    // Show loading state while saving
    state = const AsyncLoading<List<Event>>().copyWithPrevious(state);
    try {
      await _repository.saveEvent(event);
      ref.invalidateSelf(); // Trigger a full rebuild and refetch
    } catch (error, stackTrace) {
      debugPrint('Error adding event: $error');
      // Set error state, preserving previous data if available
      state = AsyncError<List<Event>>(error, stackTrace).copyWithPrevious(state);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final previousState = state;
    if (state.hasValue) {
      final currentEvents = List<Event>.from(state.value!);
      currentEvents.removeWhere((event) => event.id == eventId);
      // Apply filter/sort to the optimistically updated list
      final filtered = _filterEventsLocally(currentEvents, _currentFilter);
      _sortEvents(filtered, _currentSortBy);
      state = AsyncData(filtered);
    }

    try {
      await _repository.deleteEvent(eventId);
      // If delete succeeds, invalidate to confirm state or handle pagination edge cases.
      // For simplicity, invalidation ensures consistency.
      ref.invalidateSelf(); 
    } catch (error, stackTrace) {
       debugPrint('Error deleting event: $error');
       // Revert to previous state if delete failed
       state = previousState;
       // Optionally show an error message to the user
    }
  }

  Future<void> updateEvent(Event updatedEvent) async {
    state = const AsyncLoading<List<Event>>().copyWithPrevious(state);
    try {
      await _repository.saveEvent(updatedEvent);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      debugPrint('Error updating event: $error');
      state = AsyncError<List<Event>>(error, stackTrace).copyWithPrevious(state);
    }
  }

  bool get hasMoreEvents => _hasMore;
}

class EventsControllerWidget extends ConsumerWidget {
  final String filter;
  final String sortBy;
  final Widget Function(List<Event>) builder;

  const EventsControllerWidget({
    super.key,
    this.filter = 'all',
    this.sortBy = 'date',
    required this.builder,
  });

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
