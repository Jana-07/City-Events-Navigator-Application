import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/data/models/favorite.dart'; // Assuming FavoriteEvent has toUnified()
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/controllers/event_controller.dart';
import 'package:navigator_app/ui/controllers/favorite_controller.dart'; // Assuming userFavoritesStreamProvider exists
import 'package:navigator_app/ui/widgets/events/event_item.dart';

class EventsList extends ConsumerStatefulWidget {
  const EventsList({
    super.key,
    this.filter = 'all',
    this.sortBy = 'date', // Corresponds to 'startDate' in Event model
  });

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
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Check if scrolled near the bottom
   if (_scrollController.position.pixels >= 
      _scrollController.position.maxScrollExtent - 200) {
    
    // Read the controller notifier
    final controllerNotifier = ref.read(eventsControllerProvider('all').notifier);
    
    // *** ADD THIS CHECK ***
    // Only call fetchMore if it has more events AND is not already loading
    if (controllerNotifier.hasMoreEvents && !controllerNotifier.isLoadingMore) {
      controllerNotifier.fetchMore();
    }
  }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _deleteEvent(String eventId) {
    ref.read(eventsControllerProvider('all').notifier).deleteEvent(eventId);
  }

  @override
  Widget build(BuildContext context) {
    final eventsProvider = eventsControllerProvider('all');
    final eventsAsync = widget.filter == 'favorite'
        ? ref.watch(userFavoritesStreamProvider(null))
        : ref.watch(eventsProvider);

    return eventsAsync.when(
      data: (rawEvents) {
        if (rawEvents.isEmpty) {
          return const Center(
            child: Text('No events available'),
          );
        }

        // Adapt data based on whether it's favorites or regular events
        final List<dynamic> events;
        if (widget.filter == 'favorite') {
          if (rawEvents is List<FavoriteEvent>) {
            events = rawEvents;
          } else {
            return const Center(
                child: Text('Error: Unexpected favorite data type'));
          }
        } else {
          if (rawEvents is List<Event>) {
            events = rawEvents;
          } else {
            return const Center(
                child: Text('Error: Unexpected event data type'));
          }
        }

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          itemCount: events.length,
          itemBuilder: (ctx, index) {
            final event = events[index];
            return Dismissible(
              key: Key(event.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _deleteEvent(event.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${event.title} removed'), // Assuming common 'title'
                  ),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: Text(
                          'Are you sure you want to delete ${event.title}?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: EventItem(
                eventId: event.id,
                title: event.title,
                address: event.address,
                date: event.startDate,
                imageURL: event.imageURL,
                onToggle: () {
                  context.pushNamed(
                    Routes.eventDetailsName,
                    pathParameters: {'eventId': event.id},
                  );
                },
              ),
            );
          },
          separatorBuilder: (ctx, index) => const SizedBox(height: 6),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, st) => Center(
        // Displaying the stack trace might be helpful during development
        child: Text("Error loading events: $e\n$st"),
      ),
    );
  }
}
