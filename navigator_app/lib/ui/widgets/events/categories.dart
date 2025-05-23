import 'package:flutter/material.dart';
import 'package:navigator_app/ui/widgets/events/category_item.dart';
import 'package:navigator_app/data/category_data.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        children: categories
            .map(
              (category) => CategoryItem(category: category),
            )
            .toList(),
      ),
    );
  }
}
