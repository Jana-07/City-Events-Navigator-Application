import 'package:flutter/material.dart';
import 'package:navigator_app/data/models/categoy.dart';

final List<Category> categories = [
  Category(
    name: 'Festival',
    icon: Icons.festival,
    color: Color.fromARGB(255, 255, 165, 0),
  ),
  Category(
    name: 'Food',
    icon: Icons.restaurant_menu_outlined,
    color: Color.fromARGB(255, 184, 66, 66),
  ),
  Category(
    name: 'Sport',
    icon: Icons.sports_basketball_outlined,
    color: Color.fromARGB(255, 38, 141, 244),
  ),
  Category(
    name: 'Galllery',
    icon: Icons.draw_outlined,
    color: Color.fromARGB(255, 95, 44, 95),
  ),
  Category(
    name: 'Conference',
    icon: Icons.confirmation_number_outlined,
    color: Color.fromARGB(255, 85, 85, 85),
  ),
  Category(
    name: 'Education',
    icon: Icons.cast_for_education_outlined,
    color: Color.fromARGB(255, 122, 205, 205),
  ),
  Category(
    name: 'Cultural',
    icon: Icons.landscape_rounded,
    color: Color.fromARGB(255, 51, 66, 134),
  ),
  Category(
    name: 'Business',
    icon: Icons.business_sharp,
    color: Color.fromARGB(255, 51, 66, 134),
  ),
  Category(
    name: 'Exhibition',
    icon: Icons.account_balance_rounded,
    color: Colors.lightGreenAccent,
  ),
  Category(
    name: 'Tech',
    icon: Icons.devices,
    color: Colors.blue,
  ),
  Category(
    name: 'Other',
    icon: Icons.add_to_photos_outlined,
    color: Color.fromARGB(255, 76, 120, 83),
  ),
];
