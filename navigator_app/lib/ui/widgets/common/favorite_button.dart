import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        //color: const Color.fromARGB(255, 161, 179, 171),
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.favorite,
        color: theme.primaryColor,
        size: 20,
      ),
    );
  }
}
