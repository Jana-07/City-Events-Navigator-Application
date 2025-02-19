import 'package:flutter/material.dart';
import 'package:navigator_app/widgets/category_item.dart';
import 'package:navigator_app/data/category_data.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: categories
            .map(
              (category) => CategoryItem(category: category),
            )
            .toList(),
      ),
    );
  }
}
