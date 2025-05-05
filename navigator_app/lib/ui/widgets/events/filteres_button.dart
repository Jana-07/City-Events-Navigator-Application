import 'package:flutter/material.dart';

class FiltersButtonTwo extends StatelessWidget {
  final Function() onPressed;

  const FiltersButtonTwo({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.filter_list, color: Colors.white),
      label: const Text('Filters'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
