import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    
    return TextField(
      controller: searchController,
      //color and text theme of the searched text
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search..',
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(130),
              fontSize: 20,
            ),
      ),
      cursorColor: Theme.of(context).colorScheme.onPrimary.withAlpha(130),
    );
  }
}
