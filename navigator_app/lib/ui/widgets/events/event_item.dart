import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/ui/widgets/common/favorite_button.dart';

class EventItem extends StatelessWidget {
  const EventItem({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const String image =
        'https://platinumlist.net/guide/wp-content/uploads/2024/08/Saudi-National-Day-1.jpg';
    return SizedBox(
      height: 140,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    image,
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
                            color: const Color.fromARGB(255, 84, 87, 84),
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
