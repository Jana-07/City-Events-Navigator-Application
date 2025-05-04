import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigator_app/core/constant/cloudinary_config.dart';
import 'package:navigator_app/data/models/review.dart';
import 'package:navigator_app/data/services/cloudinary_service.dart';
import 'package:navigator_app/data/services/firestore_service.dart';
import '../models/event.dart'; // Ensure Event has 'snapshot' field

class EventRepository {
  EventRepository(this._firestoreService, this._cloudinaryService);

  final FirestoreService _firestoreService;
  final CloudinaryService _cloudinaryService;

  // Helper to apply sorting based on the sortBy string
  Query<Map<String, dynamic>> _applySorting(
      Query<Map<String, dynamic>> query, String? sortBy, bool descending) {
    // Default sort: Start Date Ascending
    String field = 'startDate';
    bool effectiveDescending = descending;

    switch (sortBy) {
      case 'date':
        field = 'startDate';
        // effectiveDescending remains as passed
        break;
      case 'rating':
        field = 'averageRating';
        effectiveDescending = true; // Default sort for rating is descending
        break;
      case 'name':
        field = 'title';
        // effectiveDescending remains as passed
        break;
      case 'price': // Added price sorting
        field = 'price';
        // effectiveDescending remains as passed
        break;
      // Add other cases if needed
      default:
        field = 'startDate';
        effectiveDescending = false; // Default to ascending for date
    }
    // IMPORTANT: Firestore requires the first orderBy field to match the field used in inequality filters (range filters)
    // If we have range filters on date or price, we might need to adjust the primary sort field here or ensure compatibility.
    return query.orderBy(field, descending: effectiveDescending);
  }

  // Simplified searchEvents focusing on reducing query complexity for pagination
  Future<List<Event>> searchEvents({
    String? queryText, // Not implemented in query building yet
    List<String>? categories,
    List<String>? tags, // Not implemented
    double? minPrice,
    double? maxPrice,
    DateTime? startDate,
    DateTime? endDate,
    String? city,
    String? creatorId,
    bool? isFeatured,
    String? sortBy,
    bool descending = false,
    int? limit,
    DocumentSnapshot? startAfterDocument,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestoreService.collection('events');

      // --- Determine Filter Complexity --- 
      bool hasMultipleCategories = categories != null && categories.isNotEmpty && categories.length > 1;
      bool hasSingleCategory = categories != null && categories.isNotEmpty && categories.length == 1 && categories.first != 'All';
      bool hasDateRange = startDate != null || endDate != null;
      bool hasPriceRange = minPrice != null || maxPrice != null;
      bool hasCity = city != null && city.isNotEmpty;
      bool hasCreator = creatorId != null && creatorId.isNotEmpty;
      bool hasFeatured = isFeatured != null && isFeatured;

      // --- Apply Basic Equality Filters (Generally Safe) --- 
      if (hasCreator) {
        query = query.where('creatorID', isEqualTo: creatorId);
      }
      if (hasCity) {
        query = query.where('city', isEqualTo: city);
      }
      if (hasFeatured) {
        query = query.where('isFeatured', isEqualTo: true);
      }
      if (hasSingleCategory) {
        query = query.where('category', isEqualTo: categories!.first);
      }

      // --- Handle Complex Filters (Potential Conflicts) --- 

      // Strategy: Prioritize making pagination work. If multiple categories are selected,
      // avoid combining them with range filters (date/price) in the *same* Firestore query.
      // Also, Firestore has limitations on combining 'whereIn' with certain 'orderBy' clauses.

      bool applyClientSideCategoryFilter = false;
      List<String>? categoriesForClientFilter;

      if (hasMultipleCategories) {
        // If multiple categories AND range filters are present, we MUST filter categories client-side
        // OR simplify the query by removing the range filters from the Firestore query.
        // Let's try removing range filters from Firestore query when multi-category is active.
        if (hasDateRange || hasPriceRange) {
           print('WARNING: Multi-category filter active with range filters. Applying category filter client-side AND removing range filters from Firestore query for stability.');
           applyClientSideCategoryFilter = true;
           categoriesForClientFilter = categories;
           // DO NOT apply date/price range filters to the Firestore query in this case
           hasDateRange = false; // Prevent range filters below
           hasPriceRange = false; // Prevent range filters below
        } else if (categories.length <= 30) {
           // If only multi-category (no range filters), 'whereIn' might be okay, but requires specific indexes with the sort field.
           // Let's try applying it, but be aware this can still cause issues with certain sorts.
           query = query.where('category', whereIn: categories);
        } else {
           // Too many categories for 'whereIn', filter client-side
           print('WARNING: Too many categories selected (>30). Applying category filter client-side.');
           applyClientSideCategoryFilter = true;
           categoriesForClientFilter = categories;
        }
      }

      // --- Apply Range Filters (Only if not disabled above) ---
      String? firstRangeField;
      if (hasDateRange) {
        firstRangeField = 'startDate';
        if (startDate != null) {
          query = query.where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
        }
        if (endDate != null) {
          // Firestore limitation: Inequality filters must be on the same field if combined with other filters/sorts.
          // If startDate is also applied, this is okay. If only endDate, it might restrict sorting options.
          query = query.where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
        }
      }
      
      // Firestore limitation: Cannot have range filters on different fields.
      // If date range is applied, we cannot apply price range in the same query.
      if (hasPriceRange && !hasDateRange) { 
        firstRangeField = 'price';
        if (minPrice != null) {
          query = query.where('price', isGreaterThanOrEqualTo: minPrice);
        }
        if (maxPrice != null) {
          query = query.where('price', isLessThanOrEqualTo: maxPrice);
        }
      } else if (hasPriceRange && hasDateRange) {
          print('WARNING: Cannot apply both date and price range filters in Firestore. Ignoring price range.');
          // Price range is ignored if date range is active.
      }

      // --- Apply Sorting --- 
      String effectiveSortBy = sortBy ?? 'startDate'; // Default sort
      
      // Firestore limitation: If you have a range filter (<, <=, >, >=), your first sort order must be on the same field.
      if (firstRangeField != null && effectiveSortBy != firstRangeField) {
          print('WARNING: Sorting by "$effectiveSortBy" conflicts with range filter on "$firstRangeField". Forcing sort by "$firstRangeField".');
          effectiveSortBy = firstRangeField; 
      }
      query = _applySorting(query, effectiveSortBy, descending);

      // --- Apply Pagination --- 
      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      // --- Apply Limit --- 
      if (limit != null && limit > 0) {
        query = query.limit(limit);
      }

      // --- Execute Query --- 
      final querySnapshot = await query.get();
      List<Event> events = querySnapshot.docs
          .map((doc) => Event.fromDocument(doc))
          .toList();

      // --- Apply Client-Side Filtering (if needed) --- 
      if (applyClientSideCategoryFilter && categoriesForClientFilter != null) {
        print('Applying client-side category filter for ${categoriesForClientFilter.length} categories.');
        events = events.where((event) {
          // Assuming event.category is a String?
          return categoriesForClientFilter!.contains(event.category);
        }).toList();
      }
      
      // NOTE: Client-side filtering breaks Firestore pagination guarantees.
      // If client-side filtering removes items, the next 'startAfterDocument' might be incorrect,
      // and 'hasMore' logic in the controller becomes unreliable.
      // This simplified approach prioritizes avoiding the Firestore error, but true pagination
      // with complex filters often requires different strategies (e.g., backend aggregation, simpler UI filters).

      print('searchEvents: Firestore query executed. Returning ${events.length} events.');
      return events;

    } catch (e, st) {
      print('Error searching events: $e\n$st');
      // Rethrow or handle as appropriate for the controller
      rethrow; 
    }
  }


  // --- Other methods (fetchEvents, fetchMoreEvents, getEvent, streams, save, delete, reviews etc.) remain largely the same ---
  // --- Ensure they call the updated searchEvents or handle their specific logic correctly --- 

  // Example: fetchEvents might be simplified or removed if searchEvents covers initial load
  Future<(List<Event>, DocumentSnapshot?)> fetchEvents_Legacy({
    required int limit,
    String? sortBy,
    String? creatorId,
  }) async {
     // This might now just call searchEvents with appropriate defaults
     final events = await searchEvents(
       limit: limit,
       sortBy: sortBy,
       creatorId: creatorId,
       // other filters null
     );
     final lastDocument = events.isNotEmpty && events.length == limit ? events.last.snapshot : null;
     return (events, lastDocument);
  }

  // Example: fetchMoreEvents might be simplified or removed if controller calls searchEvents directly
  Future<(List<Event>, DocumentSnapshot?)> fetchMoreEvents_Legacy({
    required int limit,
    required DocumentSnapshot startAfterDocument,
    String? sortBy, // Need to pass the full filter context here!
    String? creatorId,
    // ... other filters ...
  }) async {
    // This needs the *exact same* filter parameters as the previous query
    // It's generally better for the controller to call searchEvents directly
    final events = await searchEvents(
      limit: limit,
      startAfterDocument: startAfterDocument,
      sortBy: sortBy,
      creatorId: creatorId,
      // ... MUST pass all other filters used in the previous query ...
    );
     final lastDocument = events.isNotEmpty && events.length == limit ? events.last.snapshot : null;
     return (events, lastDocument);
  }

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

  Future<String> saveEvent(Event event) async {
    if (event.id.isEmpty) {
      final docRef = await _firestoreService.addDocument(
        'events',
        event.toMap(),
      );
      return docRef.id;
    } else {
      await _firestoreService.setDocument(
        'events/${event.id}',
        event.toMap(),
      );
      return event.id;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestoreService.deleteDocument('events/$eventId');
  }

  // REVIEWS SUBCOLLECTION METHODS

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
    // Update average rating (consider doing this via cloud function for robustness)
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
    // Update average rating
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
    // Update average rating
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
}

