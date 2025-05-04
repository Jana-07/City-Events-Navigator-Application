import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/core/utils/global_error_handler.dart';
import 'package:navigator_app/data/models/event.dart'; // Ensure Event has 'snapshot' field
import 'package:navigator_app/data/repositories/event_repository.dart';
import 'package:navigator_app/providers/filter_provider.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_controller.g.dart';

// Define a record to hold pagination state together
typedef _PaginationState = ({DocumentSnapshot? lastDoc, bool hasMore, EventFilter? filter});

@riverpod
class EventsController extends _$EventsController {
  static const int _limit = 10;

  // Combined pagination state
  _PaginationState _paginationState = (lastDoc: null, hasMore: true, filter: null);
  bool _isLoadingMore = false;

  // Helper to get repository
  EventRepository get _repository => ref.read(eventRepositoryProvider);

  @override
  Future<List<Event>> build() async {
    final currentFilter = ref.watch(eventFiltersProvider);
    debugPrint("EventsController Build START: New Filter=$currentFilter, Previous Filter=${_paginationState.filter}, CurrentState=$state");

    // Reset pagination state COMPLETELY only if the filter has actually changed
    if (currentFilter != _paginationState.filter) {
      debugPrint("EventsController Build: Filter changed. Resetting pagination. Stored Filter=${_paginationState.filter}");
      _paginationState = (lastDoc: null, hasMore: true, filter: currentFilter);
      _isLoadingMore = false; // Ensure loading more is reset
    } else {
      debugPrint("EventsController Build: Filter unchanged. Using existing pagination state.");
      // If filter is the same, we might be rebuilding due to other reasons (e.g., invalidate)
      // Keep the existing pagination state unless it's the very first build.
      if (_paginationState.filter == null) { // Handle initial build case
         _paginationState = (lastDoc: null, hasMore: true, filter: currentFilter);
      }
    }

    // Use the filter associated with the current pagination state for the initial fetch
    final filterForFetch = _paginationState.filter ?? currentFilter; // Fallback just in case

    try {
      final initialEvents = await _repository.searchEvents(
        queryText: filterForFetch.searchQuery,
        categories: filterForFetch.categories,
        city: filterForFetch.city,
        tags: null, // Add if needed
        startDate: filterForFetch.startDate,
        endDate: filterForFetch.endDate,
        minPrice: filterForFetch.minPrice,
        maxPrice: filterForFetch.maxPrice,
        creatorId: filterForFetch.creatorId,
        sortBy: filterForFetch.sortBy,
        descending: filterForFetch.descending,
        limit: _limit,
        startAfterDocument: null, // Initial fetch always starts from beginning
      );

      // Update pagination state based on this initial fetch
      final newLastDoc = initialEvents.isNotEmpty && initialEvents.length == _limit
          ? initialEvents.last.snapshot // Assumes Event has 'snapshot'
          : null;
      final newHasMore = initialEvents.length == _limit;
      _paginationState = (lastDoc: newLastDoc, hasMore: newHasMore, filter: filterForFetch);

      debugPrint("EventsController Build END: Fetched=${initialEvents.length}, HasMore=${_paginationState.hasMore}, LastDoc=${_paginationState.lastDoc?.id}");
      return initialEvents;
    } catch (e, st) {
      debugPrint("EventsController Build ERROR: $e\n$st");
      // Reset pagination state on error during build
      _paginationState = (lastDoc: null, hasMore: false, filter: null);
      _isLoadingMore = false;
      rethrow;
    }
  }

  Future<void> fetchMore() async {
    // Prevent concurrent fetches or fetching when in error state
    if (_isLoadingMore || state is AsyncLoading || state is AsyncError) {
      debugPrint("FetchMore: Bailing out (isLoadingMore: $_isLoadingMore, state is loading or error)");
      return;
    }

    // Get the pagination state that corresponds to the currently displayed list
    final currentState = _paginationState;

    // Read the *latest* filter setting from the provider
    final latestFilter = ref.read(eventFiltersProvider);

    // *** CRITICAL CHECK: Ensure the filter hasn't changed AND pagination is possible ***
    if (latestFilter != currentState.filter) {
      debugPrint("FetchMore: Filter changed during pagination! Bailing out. Latest Filter=$latestFilter, State Filter=${currentState.filter}");
      // Let the 'build' method handle the reset and fetch for the new filter.
      return;
    }

    if (!currentState.hasMore || currentState.lastDoc == null) {
      debugPrint("FetchMore: Bailing out (hasMore: ${currentState.hasMore}, lastDoc: ${currentState.lastDoc?.id})");
      return;
    }

    _isLoadingMore = true;
    final previousState = state; // Keep previous data for UI
    // Optionally show loading indicator appended to the list, or keep the main loading state
    state = AsyncLoading<List<Event>>().copyWithPrevious(previousState);

    final currentEvents = previousState.valueOrNull ?? [];

    debugPrint("FetchMore: Loading more... Filter=${currentState.filter}, StartAfter=${currentState.lastDoc?.id}");

    try {
      // Use the filter associated with the current pagination state
      final newEvents = await _repository.searchEvents(
        queryText: currentState.filter!.searchQuery, // Use filter from state
        categories: currentState.filter!.categories,
        city: currentState.filter!.city,
        tags: null,
        startDate: currentState.filter!.startDate,
        endDate: currentState.filter!.endDate,
        minPrice: currentState.filter!.minPrice,
        maxPrice: currentState.filter!.maxPrice,
        creatorId: currentState.filter!.creatorId,
        sortBy: currentState.filter!.sortBy,
        descending: currentState.filter!.descending,
        limit: _limit,
        startAfterDocument: currentState.lastDoc, // Use cursor from state
      );

      // Update pagination state based on the NEW fetch results
      final newLastDoc = newEvents.isNotEmpty && newEvents.length == _limit
          ? newEvents.last.snapshot
          : null;
      final newHasMore = newEvents.length == _limit;
      // IMPORTANT: Update pagination state, keeping the SAME filter reference
      _paginationState = (lastDoc: newLastDoc, hasMore: newHasMore, filter: currentState.filter);

      debugPrint("FetchMore: Fetched ${newEvents.length} new events. HasMore: ${_paginationState.hasMore}, LastDoc=${_paginationState.lastDoc?.id}");

      // Update state with combined list
      state = AsyncData([...currentEvents, ...newEvents]);

    } catch (e, st) {
      debugPrint('Error fetching more events: $e\n$st');
      // Revert to previous data on error, but keep error state
      state = AsyncError<List<Event>>(e, st).copyWithPrevious(previousState);
      // Update pagination state to prevent further attempts on error
      _paginationState = (lastDoc: currentState.lastDoc, hasMore: false, filter: currentState.filter);
    } finally {
      _isLoadingMore = false;
    }
  }

  // --- CRUD methods --- (Invalidate self to trigger rebuild)
  Future<void> addEvent(Event event) async {
    state = const AsyncLoading<List<Event>>().copyWithPrevious(state);
    try {
      await _repository.saveEvent(event);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      debugPrint('Error adding event: $error');
      state = AsyncError<List<Event>>(error, stackTrace).copyWithPrevious(state);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final previousState = state;
    if (state.hasValue) {
      final currentEvents = List<Event>.from(state.value!);
      currentEvents.removeWhere((event) => event.id == eventId);
      state = AsyncData(currentEvents);
    }
    try {
      await _repository.deleteEvent(eventId);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
       debugPrint('Error deleting event: $error');
       state = previousState;
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

  // --- Status getters ---
  bool get hasMoreEvents => _paginationState.hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

// --- EventsControllerWidget (unchanged) ---
class EventsControllerWidget extends ConsumerWidget {
  final Widget Function(List<Event>) builder;

  const EventsControllerWidget({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsControllerProvider);

    return AsyncErrorHandler.withAsyncValue<List<Event>>(
      value: eventsAsync,
      data: (events) {
        return builder(events);
      },
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

