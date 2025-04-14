import 'package:flutter/material.dart';
import 'package:navigator_app/data/event_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

class GenerateData extends ConsumerWidget{
  const GenerateData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventRepository = ref.watch(eventRepositoryProvider);

    return TextButton(onPressed: () async {
      for (var event in dummyEvents) {
          eventRepository.saveEvent(event);  
      }
    }, child: Text('Save data to firesotre'),);
  }
}