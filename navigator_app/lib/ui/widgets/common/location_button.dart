import 'package:flutter/material.dart';

const List<String> cities = [
  'Riyadh',
  'Jeddah',
  'Qassim',
  'Mecca',
  'Medina',
  'Abha',
  'Dammam'
];

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
