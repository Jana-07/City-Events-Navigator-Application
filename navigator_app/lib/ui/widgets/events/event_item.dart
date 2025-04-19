import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/widgets/common/favorite_button.dart';

class EventItem extends StatelessWidget {
  const EventItem({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 140,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            context.pushNamed(
              Routes.eventDetailsName,
              pathParameters: {'eventId': event.id},
              extra: event,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    event.imageURL,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              DateFormat('EEE, MMMM d, h:mm a')
                                  .format(event.startDate),
                              style: theme.textTheme.labelLarge),
                          Spacer(),
                          FavoriteButton(),
                        ],
                      ),
                      Text(
                        event.title,
                        style: theme.textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color.fromARGB(200, 84, 87, 84),
                          ),
                          Flexible(
                            child: Text(
                              event.address,
                              style: theme.textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
