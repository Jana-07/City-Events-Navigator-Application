import 'package:flutter/material.dart';
import 'package:navigator_app/data/models/saudi_city.dart';

class LocationButton extends StatefulWidget {
  const LocationButton({super.key});

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  final TextEditingController locationController = TextEditingController();

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> cities = saudiCities.map((city) => city.name).toList();
    return DropdownMenu(
      hintText: 'Select a City',
      //TODO
      //initialSelection: Current user location,
      controller: locationController,
      onSelected: (String? city) {
        setState(() {
          if (city != null) {
            locationController.text = city;
          }
        });
      },
      dropdownMenuEntries: cities
          .map<DropdownMenuEntry<String>>(
            (String city) => DropdownMenuEntry(value: city, label: city),
          )
          .toList(),
      enableSearch: true,
      requestFocusOnTap: true,
      enableFilter: true,
      textAlign: TextAlign.end,
      textStyle: theme.textTheme.titleMedium,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.textTheme.titleMedium,
        border: InputBorder.none,
        suffixIconColor: theme.colorScheme.onPrimary,
      ),
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}
