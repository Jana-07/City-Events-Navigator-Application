import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/providers/filter_provider.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/controllers/event_controller.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';
import 'package:navigator_app/ui/widgets/events/event_item.dart';

class LimitedEventList extends ConsumerWidget {
  final int limit;

  const LimitedEventList({
    super.key,
    this.limit = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserControllerWidget(
      builder: (user) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(EventFiltersProvider('Recommended').notifier)
              .setCategories(user.preferences);
        });
        return EventsControllerWidget(
            type: 'Recommended',
            builder: (events) {
              if (events.isEmpty) {
                return Center(
                  child: Text('No events match your preferred categories'),
                );
              }
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                itemCount: events.length < limit ? events.length : limit,
                itemBuilder: (ctx, index) {
                  final event = events[index];
                  return EventItem(
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
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 6),
              );
            });
      },
    );
  }
}
