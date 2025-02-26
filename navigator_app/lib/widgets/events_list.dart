import 'package:flutter/material.dart';
import 'package:navigator_app/models/event.dart';
import 'package:navigator_app/widgets/event_item.dart';

class EventsList extends StatelessWidget {
  const EventsList({super.key, required this.events});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 14),
      itemCount: 3,
      itemBuilder: (ctx, index) {
        return EventItem(event: events[index]);
      },
    );
  }
}
