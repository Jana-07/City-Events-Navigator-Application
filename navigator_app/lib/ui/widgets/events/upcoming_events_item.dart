import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/widgets/common/favorite_button.dart';

class UpcomingEventItem extends StatelessWidget {
  const UpcomingEventItem({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 280,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            context.pushNamed(
              Routes.eventDetailsName,
              pathParameters: {'eventId': event.id},
              extra: event,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    child: Image.network(
                      event.imageURL,
                      width: 280,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 55,
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.outlineVariant,
                      ),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '${DateFormat.d().format(event.startDate)}\n',
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryFixedVariant,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat.MMM()
                                .format(event.startDate)
                                .toUpperCase(),
                            style: theme.textTheme.labelLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryFixedVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FavoriteButton(
                        eventId: event.id,
                        title: event.title,
                        address: event.address,
                        date: event.startDate,
                        imageURL: event.imageURL),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
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
                            overflow: TextOverflow.clip,
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
    );
  }
}
