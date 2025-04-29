import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/data/repositories/event_repository.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/ui/controllers/event_controller.dart';

import 'package:navigator_app/ui/widgets/common/favorite_button.dart';

class EventItem extends ConsumerWidget {
  const EventItem({
    super.key,
    //required this.event,
    required this.onToggle,
    required this.eventId,
    required this.title,
    required this.address,
    required this.date,
    required this.imageURL,
  });

  //final Event event;
  final void Function() onToggle;
  final String eventId;
  final String title;
  final String address;
  final DateTime date;
  final String imageURL;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 140,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageURL,
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
                          Text(DateFormat('EEE, MMMM d, h:mm a').format(date),
                              style: theme.textTheme.labelLarge),
                          Spacer(),
                          FavoriteButton(
                              eventId: eventId,
                              title: title,
                              address: address,
                              date: date,
                              imageURL: imageURL),
                        ],
                      ),
                      Text(
                        title,
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
                              address,
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
