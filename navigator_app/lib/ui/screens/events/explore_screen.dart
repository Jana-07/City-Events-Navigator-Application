import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/router/routes.dart';

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
                      left: 36,
                      right: 36,
                      top: screenHeight * 0.12,
                    ),
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
                  SizedBox(height: screenHeight * 0.075),
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
            height: 280,
            // List recommendation evnets
            child: LimitedEventList(),
          ),
          const SizedBox(
            height: 20,
          ),
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
