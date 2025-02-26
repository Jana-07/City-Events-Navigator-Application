import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 161, 179, 171),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.favorite,
        color: const Color.fromARGB(255, 20, 67, 22),
        size: 20,
      ),
    );
  }
}
