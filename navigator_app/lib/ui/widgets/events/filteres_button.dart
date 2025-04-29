import 'package:flutter/material.dart';

class FiltersButtonTwo extends StatelessWidget {
  final VoidCallback? onPressed;

  const FiltersButtonTwo({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      icon: const Icon(Icons.filter_list),
      label: const Text('Filters'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
