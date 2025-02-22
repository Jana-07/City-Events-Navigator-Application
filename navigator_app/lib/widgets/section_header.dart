import 'package:flutter/material.dart';
import 'package:navigator_app/screens/event_list_screen.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8),
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(210),
                        ),
                  ),
                  Icon(
                    Icons.arrow_right_rounded,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(210),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
