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
    return DropdownMenu(
      hintText: 'Select City',
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
      textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
              fontWeight: FontWeight.w500,
            ),
        border: InputBorder.none,
        suffixIconColor: Theme.of(context).colorScheme.onPrimary,
      ),
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
