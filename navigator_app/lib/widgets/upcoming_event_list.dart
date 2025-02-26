import 'package:flutter/material.dart';

import 'package:navigator_app/data/event_data.dart';
import 'package:navigator_app/widgets/upcoming_events_item.dart';

class UpcomingEventsList extends StatelessWidget {
  const UpcomingEventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children:
          dummyEvents.map((event) => UpcomingEventItem(event: event)).toList(),
    );
  }
}
