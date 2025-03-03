import 'package:flutter/material.dart';
import 'package:navigator_app/models/event.dart';
import 'package:navigator_app/widgets/event_item.dart';
import 'package:navigator_app/data/event_data.dart';
import 'package:flutter/material.dart';
import 'package:navigator_app/models/event.dart'; // Adjust the import path as needed

class EventList extends StatelessWidget {
  final List<Event> events;

  EventList({required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          leading: Image.asset(event.image), // Display the image
          title: Text(event.name),
          subtitle: Text('${event.address} - ${event.date.toString()}'),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: EventList(events: dummyEvents),
    ),
  ));
}
/*class EventsList extends StatelessWidget {
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
}*/
