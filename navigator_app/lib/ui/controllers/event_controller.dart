import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/core/utils/global_error_handler.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/data/repositories/event_repository.dart';
import 'package:navigator_app/providers/filter_provider.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_controller.g.dart';

typedef _PaginationState = ({
  DocumentSnapshot? lastDoc,
  bool hasMore,
  EventFilter? filter
});

@riverpod
class EventsController extends _$EventsController {
  static const int _limit = 10;

  _PaginationState _paginationState =
      (lastDoc: null, hasMore: true, filter: null);
  bool _isLoadingMore = false;

  EventRepository get _repository => ref.read(eventRepositoryProvider);

  @override
  Future<List<Event>> build(String listId) async {
    final currentFilter = ref.watch(eventFiltersProvider(listId));
    debugPrint(
        "EventsController Build START: New Filter=$currentFilter, Previous Filter=${_paginationState.filter}, CurrentState=$state");

    if (currentFilter != _paginationState.filter) {
      debugPrint(
          "EventsController Build: Filter changed. Resetting pagination. Stored Filter=${_paginationState.filter}");
      _paginationState = (lastDoc: null, hasMore: true, filter: currentFilter);
      _isLoadingMore = false;
    } else {
      debugPrint(
          "EventsController Build: Filter unchanged. Using existing pagination state.");
      if (_paginationState.filter == null) {
        _paginationState =
            (lastDoc: null, hasMore: true, filter: currentFilter);
      }
    }

    final filterForFetch = _paginationState.filter ?? currentFilter;

    try {
      final initialEvents = await _repository.searchEvents(
        filterForFetch,
      );

      final newLastDoc =
          initialEvents.isNotEmpty && initialEvents.length == _limit
              ? initialEvents.last.snapshot
              : null;
      final newHasMore = initialEvents.length == _limit;
      _paginationState =
          (lastDoc: newLastDoc, hasMore: newHasMore, filter: filterForFetch);

      debugPrint(
          "EventsController Build END: Fetched=${initialEvents.length}, HasMore=${_paginationState.hasMore}, LastDoc=${_paginationState.lastDoc?.id}");
      return initialEvents;
    } catch (e, st) {
      debugPrint("EventsController Build ERROR: $e\n$st");
      _paginationState = (lastDoc: null, hasMore: false, filter: null);
      _isLoadingMore = false;
      rethrow;
    }
  }

  Future<void> fetchMore() async {
    if (_isLoadingMore || state is AsyncLoading || state is AsyncError) {
      debugPrint(
          "FetchMore: Bailing out (isLoadingMore: $_isLoadingMore, state is loading or error)");
      return;
    }

    final currentState = _paginationState;

    final latestFilter = ref.read(eventFiltersProvider(listId));

    if (latestFilter != currentState.filter) {
      debugPrint(
          "FetchMore: Filter changed during pagination! Bailing out. Latest Filter=$latestFilter, State Filter=${currentState.filter}");
      return;
    }

    if (!currentState.hasMore || currentState.lastDoc == null) {
      debugPrint(
          "FetchMore: Bailing out (hasMore: ${currentState.hasMore}, lastDoc: ${currentState.lastDoc?.id})");
      return;
    }

    _isLoadingMore = true;
    final previousState = state;
    state = AsyncLoading<List<Event>>().copyWithPrevious(previousState);

    final currentEvents = previousState.valueOrNull ?? [];

    debugPrint(
        "FetchMore: Loading more... Filter=${currentState.filter}, StartAfter=${currentState.lastDoc?.id}");

    try {
      final newEvents = await _repository.searchEvents(
        currentState.filter!,
        startAfterDocument: currentState.lastDoc,
      );

      final newLastDoc = newEvents.isNotEmpty && newEvents.length == _limit
          ? newEvents.last.snapshot
          : null;
      final newHasMore = newEvents.length == _limit;
      _paginationState = (
        lastDoc: newLastDoc,
        hasMore: newHasMore,
        filter: currentState.filter
      );

      debugPrint(
          "FetchMore: Fetched ${newEvents.length} new events. HasMore: ${_paginationState.hasMore}, LastDoc=${_paginationState.lastDoc?.id}");

      state = AsyncData([...currentEvents, ...newEvents]);
    } catch (e, st) {
      debugPrint('Error fetching more events: $e\n$st');
      state = AsyncError<List<Event>>(e, st).copyWithPrevious(previousState);
      _paginationState = (
        lastDoc: currentState.lastDoc,
        hasMore: false,
        filter: currentState.filter
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> addEvent(Event event) async {
    state = const AsyncLoading<List<Event>>().copyWithPrevious(state);
    try {
      await _repository.saveEvent(event);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      debugPrint('Error adding event: $error');
      state =
          AsyncError<List<Event>>(error, stackTrace).copyWithPrevious(state);
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
      state =
          AsyncError<List<Event>>(error, stackTrace).copyWithPrevious(state);
    }
  }

  bool get hasMoreEvents => _paginationState.hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

class EventsControllerWidget extends ConsumerWidget {
  final Widget Function(List<Event>) builder;
  final String type;

  const EventsControllerWidget({
    super.key,
    required this.builder,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsControllerProvider(type));

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
                onPressed: () => ref.invalidate(eventsControllerProvider(type)),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }
}
