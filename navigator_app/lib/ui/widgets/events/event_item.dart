import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';

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
    final location = GoRouter.of(context).state.uri.toString();
    return UserControllerWidget(
      builder: (user) => SizedBox(
        height: 150,
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
                      width: 120,
                      height: 120,
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
                            user.role == 'organizer' &&
                                    user.eventsHosted.contains(eventId) &&
                                    location.startsWith(Routes.profile)
                                ? TextButton(
                                    onPressed: () {
                                      context.goNamed(Routes.editEventName,
                                          pathParameters: {'eventId': eventId});
                                    },
                                    child: Text(
                                      'Edit',
                                      style: theme.textTheme.labelLarge,
                                    ),
                                  )
                                : FavoriteButton(
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
      ),
    );
  }
}
