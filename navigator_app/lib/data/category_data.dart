import 'package:flutter/material.dart';
import 'package:navigator_app/models/categoy.dart';

final List<Category> categories = [
  Category(
    name: 'Festivals',
    icon: Icons.festival,
    color: Color.fromARGB(255, 255, 165, 0),
  ),
  Category(
    name: 'Food',
    icon: Icons.restaurant_menu,
    color: Color.fromARGB(255, 184, 66, 66),
  ),
  Category(
    name: 'Sports',
    icon: Icons.sports_basketball,
    color: Color.fromARGB(255, 38, 141, 244),
  ),
  Category(
    name: 'Art',
    icon: Icons.draw_outlined,
    color: Color.fromARGB(255, 95, 44, 95),
  ),
  Category(
    name: 'Conferences',
    icon: Icons.confirmation_number_outlined,
    color: Color.fromARGB(255, 85, 85, 85),
  ),
  Category(
    name: 'Tech',
    icon: Icons.confirmation_number_outlined,
    color: Color.fromARGB(255, 122, 205, 205),
  ),
];
