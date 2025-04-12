import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/event_data.dart';

import 'package:navigator_app/ui/widgets/events/categories.dart';
import 'package:navigator_app/ui/widgets/events/events_list.dart';
import 'package:navigator_app/ui/widgets/events/filters_button.dart';
import 'package:navigator_app/ui/widgets/common/location_button.dart';
import 'package:navigator_app/ui/widgets/common/search_text_field.dart';
import 'package:navigator_app/ui/widgets/common/section_header.dart';
import 'package:navigator_app/ui/widgets/events/upcoming_event_list.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.27,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: MediaQuery.of(context).padding.top),
                    child: Row(
                      children: [
                        Spacer(),
                        Spacer(),
                        LocationButton(),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.notifications_none),
                          color: colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SearchTextField(),
                        ),
                        Spacer(),
                        FiltersButton(),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Categories(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          SectionHeader(
            title: 'Upcoming Events',
            onTab: () => context.push('/event'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: UpcomingEventsList(events: dummyEvents ?? []),
          ),
          const SizedBox(height: 40),
          SectionHeader(
            title: 'Recommendation',
            onTab: () => context.push('/event'),
          ),
          SizedBox(
            //width: 400,
            height: 300,
            child: EventsList(events: dummyEvents),
          ),
        ],
      ),
    );
  }
}
