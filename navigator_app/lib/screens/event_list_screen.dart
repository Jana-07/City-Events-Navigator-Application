import 'package:flutter/material.dart';
import 'package:navigator_app/data/event_data.dart';
import 'package:navigator_app/widgets/events_list.dart';

class EventListScreen extends StatefulWidget{
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => EventListScreenState();
}

class EventListScreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EventsList(events: dummyEvents)
        ],
      ),
    );
  }
}