import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/ui/controllers/event_controller.dart';
import 'package:navigator_app/ui/widgets/events/upcoming_events_item.dart';

class UpcomingEventsList extends ConsumerStatefulWidget {
  const UpcomingEventsList({
    super.key,
    //required this.events,
    this.filter = 'all',
    this.sortBy = 'date',
  });

  //final List<Event> events;
  final String filter;
  final String sortBy;

  @override
  ConsumerState<UpcomingEventsList> createState() => _UpcomingEventsListState();
}

class _UpcomingEventsListState extends ConsumerState<UpcomingEventsList> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref
            .read(eventsControllerProvider(filter: 'all', sortBy: 'date')
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
    final eventsAsync = ref.watch(
        eventsControllerProvider(filter: widget.filter, sortBy: widget.sortBy));

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return Center(
            child: Text('No events available'),
          );
        }
        return ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: events.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            final event = events[index];
            return UpcomingEventItem(
              key: ValueKey(event.title),
              event: event,
            );
          },
          separatorBuilder: (ctx, index) => const SizedBox(width: 20),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, st) => Center(
        child: Text("Error loading events: $e"),
      ),
    );
  }
}
