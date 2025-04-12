import 'package:flutter/material.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/ui/widgets/events/event_item.dart';

class EventsList extends StatelessWidget {
  const EventsList({super.key, required this.events});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      itemCount: events.length,
      itemBuilder: (ctx, index) {
        return EventItem(event: events[index]);
      },
      separatorBuilder: (ctx, index) => const SizedBox(height: 6),
    );
  }
}
