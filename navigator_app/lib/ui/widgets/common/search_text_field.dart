import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/providers/filter_provider.dart';
import 'package:navigator_app/router/routes.dart';

class SearchTextField extends ConsumerWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
    final theme = Theme.of(context);
    return TextField(
      controller: searchController,
      style: theme.textTheme.titleMedium,
      decoration: InputDecoration(
        fillColor: theme.primaryColor,
        border: InputBorder.none,
        hintText: 'Search..',
        hintStyle: theme.textTheme.titleMedium!.copyWith(
          color: Colors.white.withAlpha(225),
        ),
      ),
      cursorColor: theme.colorScheme.onPrimary.withAlpha(130),
      onSubmitted: (value) {
        ref.read(eventFiltersProvider('all').notifier).setSearchQuery(value.trim());
        context.pushNamed(Routes.eventListName);
      },
    );
  }
}
