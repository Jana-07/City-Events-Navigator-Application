import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/ui/screens/events/event_list_screen.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.onTab});

  final String title;
  final void Function() onTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall,
          ),
          Spacer(),
          InkWell(
            onTap: onTab,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8),
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(210),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_rounded,
                    color: theme.colorScheme.onSurface.withAlpha(210),
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
