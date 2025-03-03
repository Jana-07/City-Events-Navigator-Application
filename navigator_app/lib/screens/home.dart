import 'package:flutter/material.dart';
import 'package:navigator_app/data/event_data.dart';
import 'package:navigator_app/widgets/events_list.dart';
import 'package:navigator_app/widgets/categories.dart';
import 'package:navigator_app/widgets/events_list.dart';
import 'package:navigator_app/widgets/filters_button.dart';
import 'package:navigator_app/widgets/location_button.dart';
import 'package:navigator_app/widgets/search_text_field.dart';
import 'package:navigator_app/widgets/section_header.dart';
import 'package:navigator_app/widgets/upcoming_event_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: 24,
                      left: 24,
                      top: MediaQuery.of(context).padding.top),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          LocationButton(),
                          Spacer(),
                          Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SearchTextField(),
                          ),
                          Spacer(),
                          FiltersButton(),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.035),
                      Categories(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SectionHeader(title: 'Upcoming Events'),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: UpcomingEventsList(),
            ),
            const SizedBox(height: 40),
            SectionHeader(title: 'Recommendation'),
            SizedBox(
              width: 400,
              height: 400,
              child: EventList(events: dummyEvents),
            ),
          ],
        ),
      ),
    );
  }
}
