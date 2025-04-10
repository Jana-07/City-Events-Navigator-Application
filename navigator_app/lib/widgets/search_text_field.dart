import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final theme = Theme.of(context);
    return TextField(
      controller: searchController,
      style: theme.textTheme.titleMedium,
      decoration: InputDecoration(
        fillColor: theme.primaryColor,
        border: InputBorder.none,
        hintText: 'Search..',
        hintStyle: theme.textTheme.titleMedium,
      ),
      cursorColor: theme.colorScheme.onPrimary.withAlpha(130),
    );
  }
}
