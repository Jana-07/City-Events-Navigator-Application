import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteEvent {
  final String id;
  final DateTime addedAt;
  final String address;
  final String imageURL;
  final DocumentReference eventRef;
  final DateTime startDate;
  final String title;
  final bool notify;
  final int reminderTime; // Time in minutes before event to send reminder

  FavoriteEvent({
    required this.id,
    required this.addedAt,
    required this.address,
    required this.imageURL,
    required this.eventRef,
    required this.startDate,
    required this.title,
    this.notify = false,
    this.reminderTime = 60, // Default 1 hour reminder
  });

  // Create from Firestore document
  factory FavoriteEvent.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return FavoriteEvent(
      id: doc.id,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      address: data['address'] ?? '',
      imageURL: data['imageURL'] ?? '',
      eventRef: data['eventRef'] as DocumentReference? ?? FirebaseFirestore.instance.doc('events/placeholder'),
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data['title'] ?? '',
      notify: data['notify'] ?? false,
      reminderTime: data['reminderTime'] ?? 60,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'addedAt': Timestamp.fromDate(addedAt),
      'address': address,
      'imageURL': imageURL,
      'eventRef': eventRef,
      'startDate': Timestamp.fromDate(startDate),
      'title': title,
      'notify': notify,
      'reminderTime': reminderTime,
    };
  }

  // Create a copy with updated fields
  FavoriteEvent copyWith({
    DateTime? addedAt,
    String? address,
    String? imageURL,
    DocumentReference? eventRef,
    DateTime? startDate,
    String? title,
    bool? notify,
    int? reminderTime,
  }) {
    return FavoriteEvent(
      id: id,
      addedAt: addedAt ?? this.addedAt,
      address: address ?? this.address,
      imageURL: imageURL ?? this.imageURL,
      eventRef: eventRef ?? this.eventRef,
      startDate: startDate ?? this.startDate,
      title: title ?? this.title,
      notify: notify ?? this.notify,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}