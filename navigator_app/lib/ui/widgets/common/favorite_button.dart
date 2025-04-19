import 'package:flutter/foundation.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withAlpha(200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.favorite,
          color: theme.primaryColor,
          size: 24,
        ),
      ),
    );
  }
}
