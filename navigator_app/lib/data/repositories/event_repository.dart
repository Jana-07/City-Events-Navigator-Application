import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigator_app/core/constant/cloudinary_config.dart';
import 'package:navigator_app/data/models/review.dart';
import 'package:navigator_app/data/services/cloudinary_service.dart';
import 'package:navigator_app/data/services/firestore_service.dart';
import '../models/event.dart';

class EventRepository {
  EventRepository(this._firestoreService, this._cloudinaryService);

  final FirestoreService _firestoreService;
  final CloudinaryService _cloudinaryService;

  // Helper to apply sorting based on the sortBy string
  Query<Map<String, dynamic>> _applySorting(
      Query<Map<String, dynamic>> query, String? sortBy) {
    // Default sort: Start Date Ascending
    String field = 'startDate';
    bool descending = false;

    switch (sortBy) {
      case 'date':
        field = 'startDate';
        descending = false; // Controller sorts ascending by default
        break;
      case 'rating':
        field = 'averageRating';
        descending = true; // Controller sorts descending by default
        break;
      case 'name':
        field = 'title';
        descending = false; // Controller sorts ascending by default
        break;
      // Add other cases if needed
      default:
        field = 'startDate';
        descending = false;
    }
    return query.orderBy(field, descending: descending);
  }

  // Fetch initial batch of events
   Future<(List<Event>, DocumentSnapshot?)> fetchEvents({
    required int limit,
    String? sortBy,
    String? creatorId, // Added creatorId parameter
  }) async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        'events',
        queryBuilder: (query) {
          // Apply creator filter if provided
          if (creatorId != null && creatorId.isNotEmpty) {
            query = query.where('creatorID', isEqualTo: creatorId);
          }
          // Apply sorting (ensure indexes support creatorID + sort field)
          query = _applySorting(query, sortBy);
          return query;
        },
        limit: limit,
      );

      final lastDocument =
          querySnapshot.docs.isNotEmpty && querySnapshot.docs.length == limit
              ? querySnapshot.docs.last
              : null;

      final events =
          querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();

      return (events, lastDocument);
    } catch (e) {
      print('Error fetching initial events: $e');
      rethrow;
    }
  }

  // MODIFIED: Paginated fetch with sorting
  Future<(List<Event>, DocumentSnapshot?)> fetchMoreEvents({
    required int limit,
    required DocumentSnapshot startAfterDocument,
    String? sortBy,
    String? creatorId, // Added creatorId parameter
    List<String> fields = const [], // Unused, kept for compatibility
  }) async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        'events',
        queryBuilder: (query) {
          // Apply creator filter if provided
          if (creatorId != null && creatorId.isNotEmpty) {
            query = query.where('creatorID', isEqualTo: creatorId);
          }
          // Apply sorting (ensure indexes support creatorID + sort field)
          query = _applySorting(query, sortBy);
          // Apply pagination cursor
          query = query.startAfterDocument(startAfterDocument);
          return query;
        },
        limit: limit,
      );

      final lastDocument =
          querySnapshot.docs.isNotEmpty && querySnapshot.docs.length == limit
              ? querySnapshot.docs.last
              : null;

      final events =
          querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();

      return (events, lastDocument);
    } catch (e) {
      print('Error fetching more events: $e');
      rethrow;
    }
  }

  // --- Existing methods below (unchanged unless necessary) ---

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

  DocumentReference<Map<String, dynamic>> eventRef(String eventId) {
    return _firestoreService.collection('events').doc(eventId);
  }

  // This streamEvents might conflict or be redundant now?
  // Kept for now, but review if it's still needed.
  Stream<List<Event>> streamEvents({
    int limit = 10,
  }) {
    return _firestoreService
        .streamCollection(
      'events',
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
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

  // REVIEWS SUBCOLLECTION METHODS (Unchanged)

  Future<List<Review>> getEventReviews(String eventId) async {
    final snapshot = await _firestoreService.getCollection(
      'events/$eventId/reviews',
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
    );
    return snapshot.docs.map((doc) => Review.fromDocument(doc)).toList();
  }

  Future<String> uploadEventMainImage(File imageFile, String eventId) async {
    final folder = CloudinaryConfig.eventImagePath(eventId);
    final result = await _cloudinaryService.uploadImage(imageFile, folder);
    final imageUrl = result['secure_url'];
    await _firestoreService
        .collection('events')
        .doc(eventId)
        .update({'imageURL': imageUrl});
    return imageUrl;
  }

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

  Future<void> addReview(String eventId, Review review) async {
    await _firestoreService.addDocument(
      'events/$eventId/reviews',
      review.toMap(),
    );
    final reviews = await getEventReviews(eventId);
    final reviewsCount = reviews.length;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.stars).reduce((a, b) => a + b) / reviewsCount;
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
      },
    );
  }

  Future<void> updateReview(
      String eventId, String reviewId, Review updatedReview) async {
    await _firestoreService.updateDocument(
      'events/$eventId/reviews/$reviewId',
      updatedReview.toMap(),
    );
    final reviews = await getEventReviews(eventId);
    final reviewsCount = reviews.length;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.stars).reduce((a, b) => a + b) / reviewsCount;
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
      },
    );
  }

  Future<void> deleteReview(String eventId, String reviewId) async {
    await _firestoreService.deleteDocument('events/$eventId/reviews/$reviewId');
    final reviews = await getEventReviews(eventId);
    final reviewsCount = reviews.length;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.stars).reduce((a, b) => a + b) / reviewsCount;
    await _firestoreService.updateDocument(
      'events/$eventId',
      {
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
      },
    );
  }

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

  // Comprehensive search events function (Unchanged)
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
      Query<Map<String, dynamic>> buildQuery(
          Query<Map<String, dynamic>> query) {
        if (creatorId != null && creatorId.isNotEmpty) {
          query = query.where('creatorID', isEqualTo: creatorId);
        }
        if (category != null && category.isNotEmpty && category != 'All') {
          query = query.where('category', isEqualTo: category);
        }
        if (isFeatured != null && isFeatured) {
          query = query.where('isFeatured', isEqualTo: true);
        }
        if (tags != null && tags.length == 1) {
          query = query.where('tags', arrayContains: tags.first);
        }
        if (startDate != null && endDate != null) {
          query = query
              .where('startDate',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
              .where('startDate',
                  isLessThanOrEqualTo: Timestamp.fromDate(endDate));
        } else if (startDate != null) {
          query = query.where('startDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
        } else if (endDate != null) {
          query = query.where('startDate',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate));
        }

        // Apply sorting (using the complex logic from original search)
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
          query = query.orderBy('startDate', descending: false);
        }

        if (startAfterDocument != null) {
          query = query.startAfterDocument(startAfterDocument);
        }
        return query;
      }

      final snapshot = await _firestoreService.getCollection(
        'events',
        queryBuilder: buildQuery,
        limit: limit,
      );

      List<Event> events =
          snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();

      // In-memory filters (unchanged)
      if (query != null && query.isNotEmpty) {
        final lowercaseQuery = query.toLowerCase();
        events = events.where((event) {
          return event.title.toLowerCase().contains(lowercaseQuery) ||
              event.description.toLowerCase().contains(lowercaseQuery) ||
              event.address.toLowerCase().contains(lowercaseQuery) ||
              event.category.toLowerCase().contains(lowercaseQuery);
        }).toList();
      }
      if (tags != null && tags.length > 1) {
        events = events.where((event) {
          return tags.any((tag) => event.tags.contains(tag));
        }).toList();
      }
      if ((minPrice != null || maxPrice != null) &&
          (startDate != null || endDate != null)) {
        events = events.where((event) {
          if (minPrice != null && event.price < minPrice) return false;
          if (maxPrice != null && event.price > maxPrice) return false;
          return true;
        }).toList();
      }
      if (location != null && location.isNotEmpty) {
        final lowercaseLocation = location.toLowerCase();
        events = events.where((event) {
          return event.address.toLowerCase().contains(lowercaseLocation);
        }).toList();
      }

      return events;
    } catch (e) {
      print('Error searching events: $e');
      rethrow;
    }
  }
}

