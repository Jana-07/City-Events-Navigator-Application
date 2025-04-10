import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigator_app/services/firestore_service.dart';
import '../models/event.dart';

/// Example of an event repository implementation
class EventRepository {
  EventRepository(this._firestoreService);
  
  final FirestoreService _firestoreService;
  
  // Get event by ID
  Future<Event?> getEvent(String eventId) async {
    final doc = await _firestoreService.getDocument('events/$eventId');
    if (!doc.exists) {
      return null;
    }
    
    return Event.fromDocument(doc);
  }
  
  // Stream event by ID
  Stream<Event?> streamEvent(String eventId) {
    return _firestoreService.streamDocument('events/$eventId').map((doc) {
      if (!doc.exists) {
        return null;
      }
      
      return Event.fromDocument(doc);
    });
  }
  
  // Stream all events (for organizers)
  Stream<List<Event>> streamAllEvents() {
    return _firestoreService.streamCollection('events').map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }
  
  // Stream public events (for regular users)
  Stream<List<Event>> streamPublicEvents({int? limit}) {
    return _firestoreService.streamCollection(
      'events',
      queryBuilder: (query) => query.where('isPublic', isEqualTo: true),
      limit: limit,
    ).map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }
  
  // Stream events by organizer
  Stream<List<Event>> streamOrganizerEvents(String organizerId) {
    return _firestoreService.streamCollection(
      'events',
      queryBuilder: (query) => query.where('organizerId', isEqualTo: organizerId),
    ).map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }
  
  // Create or update event
  Future<void> saveEvent(Event event) async {
    if (event.id.isEmpty) {
      // Create new event
      await _firestoreService.addDocument(
        'events',
        event.toMap(),
      );
    } else {
      // Update existing event
      await _firestoreService.setDocument(
        'events/${event.id}',
        event.toMap(),
      );
    }
  }
  
  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestoreService.deleteDocument('events/$eventId');
  }
  
  // Add attendee to event
  Future<void> addAttendee(String eventId, String userId) async {
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'attendees': FieldValue.arrayUnion([userId]),
      },
    );
  }
  
  // Remove attendee from event
  Future<void> removeAttendee(String eventId, String userId) async {
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'attendees': FieldValue.arrayRemove([userId]),
      },
    );
  }
}
