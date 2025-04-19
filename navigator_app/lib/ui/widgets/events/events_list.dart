import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/ui/controllers/event_controller.dart';
import 'package:navigator_app/ui/widgets/events/event_item.dart';

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
      data: (events) => ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        itemCount: events.length,
        itemBuilder: (ctx, index) => EventItem(event: events[index]),
        separatorBuilder: (ctx, index) => const SizedBox(height: 6),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, st) => Center(
        child: Text("Error loading events: $e"),
      ),
    );
  }
}
