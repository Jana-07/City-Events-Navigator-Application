import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigator_app/data/models/review.dart';
import 'package:navigator_app/data/services/firestore_service.dart';
import '../models/event.dart';

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
    return _firestoreService
        .streamCollection(
      'events',
      queryBuilder: (query) => query.orderBy('startDate', descending: false),
      limit: limit,
    )
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }

  // Stream events by creator
  Stream<List<Event>> streamCreatorEvents(String creatorId) {
    return _firestoreService
        .streamCollection(
      'events',
      queryBuilder: (query) => query.where('creatorID', isEqualTo: creatorId),
    )
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }

  // Stream events by category
  Stream<List<Event>> streamEventsByCategory(String category) {
    return _firestoreService
        .streamCollection(
      'events',
      queryBuilder: (query) => query.where('category', isEqualTo: category),
    )
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }

  // Stream events by tag
  Stream<List<Event>> streamEventsByTag(String tag) {
    return _firestoreService
        .streamCollection(
      'events',
      queryBuilder: (query) => query.where('tags', arrayContains: tag),
    )
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }

  // Stream events by price range
  Stream<List<Event>> streamEventsByPriceRange(
      double minPrice, double maxPrice) {
    return _firestoreService
        .streamCollection(
      'events',
      queryBuilder: (query) => query
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice),
    )
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }

  // Stream events by date range
  Stream<List<Event>> streamEventsByDateRange(
      DateTime startDate, DateTime endDate) {
    return _firestoreService
        .streamCollection(
      'events',
      queryBuilder: (query) => query
          .where('startDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate)),
    )
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }

  // Create or update event
  Future<String> saveEvent(Event event) async {
    if (event.id.isEmpty) {
      // Create new event
      final docRef = await _firestoreService.addDocument(
        'events',
        event.toMap(),
      );
      return docRef.id;
    } else {
      // Update existing event
      await _firestoreService.setDocument(
        'events/${event.id}',
        event.toMap(),
      );
      return event.id;
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestoreService.deleteDocument('events/$eventId');
  }

  // REVIEWS SUBCOLLECTION METHODS

  // Get all reviews for an event
  Future<List<Review>> getEventReviews(String eventId) async {
    final snapshot = await _firestoreService.getCollection(
      'events/$eventId/reviews',
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );

    return snapshot.docs.map((doc) => Review.fromDocument(doc)).toList();
  }

  // Stream all reviews for an event
  Stream<List<Review>> streamEventReviews(String eventId) {
    return _firestoreService
        .streamCollection(
      'events/$eventId/reviews',
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    )
        .map((snapshot) {
      return snapshot.docs.map((doc) => Review.fromDocument(doc)).toList();
    });
  }

  // Add review to event
  Future<void> addReview(String eventId, Review review) async {
    // Add the review to the subcollection
    await _firestoreService.addDocument(
      'events/$eventId/reviews',
      review.toMap(),
    );

    // Get all reviews to calculate new average
    final reviews = await getEventReviews(eventId);
    final reviewsCount = reviews.length;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.stars).reduce((a, b) => a + b) / reviewsCount;

    // Update the event with new rating data
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
      },
    );
  }

  // Update review
  Future<void> updateReview(
      String eventId, String reviewId, Review updatedReview) async {
    // Update the review in the subcollection
    await _firestoreService.updateDocument(
      'events/$eventId/reviews/$reviewId',
      updatedReview.toMap(),
    );

    // Get all reviews to calculate new average
    final reviews = await getEventReviews(eventId);
    final reviewsCount = reviews.length;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.stars).reduce((a, b) => a + b) / reviewsCount;

    // Update the event with new rating data
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
      },
    );
  }

  // Delete review
  Future<void> deleteReview(String eventId, String reviewId) async {
    // Delete the review from the subcollection
    await _firestoreService.deleteDocument('events/$eventId/reviews/$reviewId');

    // Get all reviews to calculate new average
    final reviews = await getEventReviews(eventId);
    final reviewsCount = reviews.length;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.stars).reduce((a, b) => a + b) / reviewsCount;

    // Update the event with new rating data
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
      },
    );
  }

  // Check if user has reviewed an event
  Future<Review?> getUserReview(String eventId, String userId) async {
    final snapshot = await _firestoreService.getCollection(
      'events/$eventId/reviews',
      queryBuilder: (query) => query.where('userID', isEqualTo: userId),
      limit: 1,
    );

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return Review.fromDocument(snapshot.docs.first);
  }

// Comprehensive search events function with multiple filters
Future<List<Event>> searchEvents({
  String? query,
  String? category,
  List<String>? tags,
  double? minPrice,
  double? maxPrice,
  DateTime? startDate,
  DateTime? endDate,
  String? location,
  String? creatorId,
  bool? isFeatured,
  String? sortBy,
  bool descending = false,
  int? limit,
  DocumentSnapshot? startAfterDocument,
}) async {
  try {
    // Define the queryBuilder as a function declaration instead of a variable assignment
    Query<Map<String, dynamic>> buildQuery(Query<Map<String, dynamic>> query) {
      // Apply filters that can be done directly in Firestore
      
      // Creator filter
      if (creatorId != null && creatorId.isNotEmpty) {
        query = query.where('creatorID', isEqualTo: creatorId);
      }
      
      // Category filter
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      
      // Featured filter
      if (isFeatured != null && isFeatured) {
        query = query.where('isFeatured', isEqualTo: true);
      }
      
      // Single tag filter (if only one tag is provided)
      if (tags != null && tags.length == 1) {
        query = query.where('tags', arrayContains: tags.first);
      }
      
      // Date range filter - can only use one range filter in Firestore
      if (startDate != null && endDate != null) {
        query = query
            .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      } else if (startDate != null) {
        query = query.where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      } else if (endDate != null) {
        query = query.where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }
      
      // Apply sorting
      if (sortBy != null) {
        switch (sortBy) {
          case 'date':
            query = query.orderBy('startDate', descending: descending);
            break;
          case 'price':
            query = query.orderBy('price', descending: descending);
            break;
          case 'rating':
            query = query.orderBy('averageRating', descending: descending);
            break;
          case 'popularity':
            query = query.orderBy('reviewsCount', descending: descending);
            break;
          default:
            query = query.orderBy('startDate', descending: false);
        }
      } else {
        // Default sorting by date
        query = query.orderBy('startDate', descending: false);
      }
      
      // Apply pagination if startAfterDocument is provided
      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }
      
      return query;
    }
    
    // Execute the query using your existing FirestoreService
    final snapshot = await _firestoreService.getCollection(
      'events',
      queryBuilder: buildQuery, // Pass the function reference
      limit: limit,
    );
    
    // Convert to Event objects
    List<Event> events = snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    
    // Apply remaining filters in-memory
    
    // Text search filter
    if (query != null && query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      events = events.where((event) {
        return event.title.toLowerCase().contains(lowercaseQuery) ||
               event.description.toLowerCase().contains(lowercaseQuery) ||
               event.address.toLowerCase().contains(lowercaseQuery) ||
               event.category.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }
    
    // Multiple tags filter
    if (tags != null && tags.length > 1) {
      events = events.where((event) {
        return tags.any((tag) => event.tags.contains(tag));
      }).toList();
    }
    
    // Price range filter (if not already applied in Firestore query)
    if ((minPrice != null || maxPrice != null) && 
        (startDate != null || endDate != null)) { // Only apply in-memory if date range is used in Firestore
      events = events.where((event) {
        if (minPrice != null && event.price < minPrice) return false;
        if (maxPrice != null && event.price > maxPrice) return false;
        return true;
      }).toList();
    }
    
    // Location filter
    if (location != null && location.isNotEmpty) {
      final lowercaseLocation = location.toLowerCase();
      events = events.where((event) {
        return event.address.toLowerCase().contains(lowercaseLocation); //||
               //(event.city?.toLowerCase() ?? '').contains(lowercaseLocation);
      }).toList();
    }
    
    return events;
  } catch (e) {
    print('Error searching events: $e');
    rethrow;
  }
}


}
