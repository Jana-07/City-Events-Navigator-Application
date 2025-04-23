import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteEvent {
  final String id;
  final DateTime addedAt;
  final String eventAddress;
  final String eventImageURL;
  final DocumentReference eventRef;
  final DateTime eventStartDate;
  final String eventTitle;
  final bool notify;
  final int reminderTime; // Time in minutes before event to send reminder

  FavoriteEvent({
    required this.id,
    required this.addedAt,
    required this.eventAddress,
    required this.eventImageURL,
    required this.eventRef,
    required this.eventStartDate,
    required this.eventTitle,
    this.notify = false,
    this.reminderTime = 60, // Default 1 hour reminder
  });

  // Create from Firestore document
  factory FavoriteEvent.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return FavoriteEvent(
      id: doc.id,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      eventAddress: data['eventAddress'] ?? '',
      eventImageURL: data['eventImageURL'] ?? '',
      eventRef: data['eventRef'] as DocumentReference? ?? FirebaseFirestore.instance.doc('events/placeholder'),
      eventStartDate: (data['eventStartDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      eventTitle: data['eventTitle'] ?? '',
      notify: data['notify'] ?? false,
      reminderTime: data['reminderTime'] ?? 60,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'addedAt': Timestamp.fromDate(addedAt),
      'eventAddress': eventAddress,
      'eventImageURL': eventImageURL,
      'eventRef': eventRef,
      'eventStartDate': Timestamp.fromDate(eventStartDate),
      'eventTitle': eventTitle,
      'notify': notify,
      'reminderTime': reminderTime,
    };
  }

  // Create a copy with updated fields
  FavoriteEvent copyWith({
    DateTime? addedAt,
    String? eventAddress,
    String? eventImageURL,
    DocumentReference? eventRef,
    DateTime? eventStartDate,
    String? eventTitle,
    bool? notify,
    int? reminderTime,
  }) {
    return FavoriteEvent(
      id: id,
      addedAt: addedAt ?? this.addedAt,
      eventAddress: eventAddress ?? this.eventAddress,
      eventImageURL: eventImageURL ?? this.eventImageURL,
      eventRef: eventRef ?? this.eventRef,
      eventStartDate: eventStartDate ?? this.eventStartDate,
      eventTitle: eventTitle ?? this.eventTitle,
      notify: notify ?? this.notify,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
