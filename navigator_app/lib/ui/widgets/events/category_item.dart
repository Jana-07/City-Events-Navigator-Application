import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:navigator_app/data/models/categoy.dart';
import 'package:navigator_app/providers/filter_provider.dart';
import 'package:navigator_app/router/routes.dart';

class CategoryItem extends ConsumerWidget {
  const CategoryItem({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(25),
      color: category.color,
      child: InkWell(
        onTap: () {
          ref.read(eventFiltersProvider('all').notifier).toggleCategory(category.name);
          context.pushNamed(Routes.eventListName);
        },
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category.icon,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(width: 5),
              Text(
                category.name,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
