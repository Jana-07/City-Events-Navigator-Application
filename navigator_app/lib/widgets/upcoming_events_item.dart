import 'package:flutter/material.dart';
import 'package:navigator_app/models/event.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/widgets/favorite_button.dart';

class UpcomingEventItem extends StatelessWidget {
  const UpcomingEventItem({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280, // Ensuring fixed width
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        color: Theme.of(context).colorScheme.onPrimary,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://platinumlist.net/guide/wp-content/uploads/2024/08/Saudi-National-Day-1.jpg',
                        width: 260,
                        height: 150,
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
                          color: const Color.fromARGB(255, 151, 158, 155),
                        ),
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: '${DateFormat.d().format(event.date)}\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryFixedVariant,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                            ),
                            TextSpan(
                              text: DateFormat.MMM()
                                  .format(event.date)
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
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
                      child: FavoriteButton(),
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
                        event.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: const Color.fromARGB(255, 76, 108, 86),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '1k+ Favorite',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 76, 108, 86),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color.fromARGB(255, 117, 114, 114),
                          ),
                          Text(
                            event.address,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 117, 114, 114),
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
