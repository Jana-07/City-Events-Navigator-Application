import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/event_data.dart';
import 'package:navigator_app/ui/widgets/events/events_list.dart';
import 'package:navigator_app/ui/widgets/events/filters_button.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen(
      {super.key, required this.title, required this.initialFilter});

  final String title;
  final String initialFilter;

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: () {
                context.pop();
              }),
          title: Text(
            widget.title,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              child: Row(
                children: [
                  Text('Sort'),
                  Spacer(),
                  FiltersButton(),
                ],
              ),
            ),
            Flexible(child: EventsList()),
          ],
        ));
  }
}
