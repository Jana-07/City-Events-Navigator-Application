import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/repositories/event_repository.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/data/event_data.dart';

import 'package:navigator_app/ui/widgets/events/categories.dart';
import 'package:navigator_app/ui/widgets/events/filters_button.dart';
import 'package:navigator_app/ui/widgets/common/location_button.dart';
import 'package:navigator_app/ui/widgets/common/search_text_field.dart';
import 'package:navigator_app/ui/widgets/common/section_header.dart';
import 'package:navigator_app/ui/widgets/events/limted_event_list.dart';
import 'package:navigator_app/ui/widgets/events/upcoming_event_list.dart';
import 'package:path_provider/path_provider.dart';

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
            onTab: () => context.pushNamed(Routes.eventListName),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: UpcomingEventsList(),
          ),
          const SizedBox(height: 40),
          SectionHeader(
            title: 'Recommendation',
            onTab: () => context.pushNamed(Routes.eventListName),
          ),
          SizedBox(
            //width: 400,
            height: 280,
            //child: EventsList(),
            child: LimitedEventList(),
          ),
          const SizedBox(
            height: 20,
          ),
          // TextButton(
          //     onPressed: () async {
          //       final eventRepository = ref.watch(eventRepositoryProvider);

          //       try {
          //         for (final event in eventsList) {
                   
          //           final eventId = await eventRepository.saveEvent(event);
          //           File imageFile =
          //               await loadAssetWithPossibleExtensions(event.title);
          //           final imageUrl = await eventRepository.uploadEventMainImage(
          //             imageFile,
          //             eventId,
          //           );
          //         }
          //       } catch (e) {
          //         print(e);
          //       }
          //     },
          //     child: Text('Add Events')),
        ],
      ),
    );
  }
}

Future<File> loadAssetWithPossibleExtensions(String baseName) async {
  final possibleExtensions = ['jpg', 'jpeg', 'png'];

  for (final ext in possibleExtensions) {
    final assetPath = 'assets/$baseName.$ext';
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$baseName.$ext');
      await tempFile.writeAsBytes(
        byteData.buffer.asUint8List(),
        flush: true,
      );
      print('picture');
      return tempFile;
    } catch (e) {
      // Ignore and try next extension
    }
  }

  throw Exception(
      'Asset not found for $baseName with any supported extension.');
}
