import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/data/models/favorite.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/controllers/event_controller.dart';
import 'package:navigator_app/ui/controllers/favorite_controller.dart';
import 'package:navigator_app/ui/widgets/events/event_item.dart';

class UnifiedEvent {
  final String id;
  final String title;
  final String address;
  final DateTime date;
  final String imageURL;

  UnifiedEvent({
    required this.id,
    required this.title,
    required this.address,
    required this.date,
    required this.imageURL,
  });
}

extension EventToUnified on Event {
  UnifiedEvent toUnified() => UnifiedEvent(
        id: id,
        title: title,
        address: address,
        date: startDate,
        imageURL: imageURL,
      );
}

extension FavoriteEventToUnified on FavoriteEvent {
  UnifiedEvent toUnified() => UnifiedEvent(
        id: id,
        title: eventTitle,
        address: eventAddress,
        date: eventStartDate,
        imageURL: eventImageURL,
      );
}

class EventsList extends ConsumerStatefulWidget {
  const EventsList({
    super.key,
    //required this.events,
    this.filter = 'all',
    this.sortBy = 'date',
  });

  //final List<Event> events;
  final String filter;
  final String sortBy;

  @override
  ConsumerState<EventsList> createState() => _EventsListState();
}

class _EventsListState extends ConsumerState<EventsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref
            .read(eventsControllerProvider(
                    filter: widget.filter, sortBy: widget.sortBy)
                .notifier)
            .fetchMore(filter: widget.filter, sortBy: widget.sortBy);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = widget.filter == 'favorite'
        ? ref.watch(userFavoritesStreamProvider)
        : ref.watch(eventsControllerProvider(
            filter: widget.filter, sortBy: widget.sortBy));

    // final eventsAsync = ref.watch(
    //     eventsControllerProvider(filter: widget.filter, sortBy: widget.sortBy));

    return eventsAsync.when(
      data: (rawEvents) { 
        final events = widget.filter == 'favorite'
          ? (rawEvents as List<FavoriteEvent>).map((favEvent) => favEvent.toUnified()).toList()
          : (rawEvents as List<Event>).map((event) => event.toUnified()).toList();

        return ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        itemCount: events.length,
        itemBuilder: (ctx, index) {
          final event = events[index];
          return EventItem(
            eventId: event.id,
            title: event.title,
            address: event.address,
            date: event.date,
            imageURL: event.imageURL,
            onToggle: () {
              context.pushNamed(
                Routes.eventDetailsName,
                pathParameters: {'eventId': event.id},
              );
            },
          );
        },
        separatorBuilder: (ctx, index) => const SizedBox(height: 6),
      ); },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, st) => Center(
        child: Text("Error loading events: $e"),
      ),
    );
  }
}
