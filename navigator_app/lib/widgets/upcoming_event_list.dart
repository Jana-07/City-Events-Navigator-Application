import 'package:flutter/material.dart';

import 'package:navigator_app/models/event.dart';
import 'package:navigator_app/widgets/upcoming_events_item.dart';

class UpcomingEventsList extends StatelessWidget {
  const UpcomingEventsList({super.key, required this.events});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
  }
}
