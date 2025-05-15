import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:navigator_app/core/constant/cloudinary_config.dart';
import 'package:navigator_app/data/services/cloudinary_service.dart';
import 'package:navigator_app/data/services/firestore_service.dart';
import 'package:navigator_app/providers/filter_provider.dart';
import '../models/event.dart';

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
        break;
      case 'rating':
        field = 'averageRating';
        effectiveDescending = true;
        break;
      case 'name':
        field = 'title';
        break;
      case 'price':
        field = 'price';
        break;
      default:
        field = 'startDate';
        effectiveDescending = false;
    }
    return query.orderBy(field, descending: effectiveDescending);
  }

  Future<List<Event>> searchEvents(EventFilter filter,
      {DocumentSnapshot? startAfterDocument}) async {
    try {
      Query<Map<String, dynamic>> query =
          _firestoreService.collection('events');
      bool isSearchActive =
          filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty;
      // Search query by title
      if (isSearchActive) {
        if (kDebugMode)
          print('Performing prefix search for: "${filter.searchQuery}"');
        final String searchText = filter.searchQuery!.trim().toLowerCase();

        if (searchText.isNotEmpty) {
          // Calculate end text for prefix range query
          final String endText =
              searchText.substring(0, searchText.length - 1) +
                  String.fromCharCode(
                      searchText.codeUnitAt(searchText.length - 1) + 1);

          // Apply range query on 'title_lowercase'
          query = query
              .where('titleLowercase', isGreaterThanOrEqualTo: searchText)
              .where('titleLowercase', isLessThan: endText);

          // Order by the search field
          query = _applySorting(query, 'titleLowercase', filter.descending);
        } else {
          // Search query was only whitespace, return empty list
          return [];
        }
      } else {
        // Standard Filter Logic
        if (kDebugMode) print('Performing standard filter search.');

        if (filter.categories != null && filter.categories!.isNotEmpty) {
          if (filter.categories!.length == 1 &&
              filter.categories!.first != 'All') {
            query =
                query.where('category', isEqualTo: filter.categories!.first);
          } else if (filter.categories!.length > 1 &&
              filter.categories!.length <= 30) {
            query = query.where('category', whereIn: filter.categories);
          }
        }

        if (filter.city != null && filter.city!.isNotEmpty) {
          query = query.where('city', isEqualTo: filter.city);
        }

        // Add price range filters
        String? firstRangeField;
        if (filter.minPrice != null || filter.maxPrice != null) {
          firstRangeField = 'price';
          if (filter.minPrice != null) {
            query =
                query.where('price', isGreaterThanOrEqualTo: filter.minPrice);
          }
          if (filter.maxPrice != null) {
            query = query.where('price', isLessThanOrEqualTo: filter.maxPrice);
          }
        }

        // Ensure not conflicting with price range
        if ((filter.startDate != null || filter.endDate != null) &&
            firstRangeField == null) {
          firstRangeField = 'startDate';
          if (filter.startDate != null) {
            query = query.where('startDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(filter.startDate!));
          }
          if (filter.endDate != null) {
            query = query.where('startDate',
                isLessThanOrEqualTo: Timestamp.fromDate(filter.endDate!));
          }
        } else if ((filter.startDate != null || filter.endDate != null) &&
            firstRangeField != null) {
          if (kDebugMode)
            print(
                'Warning: Cannot apply range filters on both price and date. Ignoring date filter.');
        }

        // Apply sorting based on filter settings
        String effectiveSortBy = filter.sortBy;
        if (firstRangeField != null && effectiveSortBy != firstRangeField) {
          if (kDebugMode)
            print(
                'WARNING: Sorting by "$effectiveSortBy" conflicts with range filter on "$firstRangeField". Forcing sort by "$firstRangeField".');
          effectiveSortBy = firstRangeField;
        }
        query = _applySorting(query, effectiveSortBy, filter.descending);
      }

      // Apply Pagination
      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      // Apply Limit
      int effectiveLimit = 10;
      query = query.limit(effectiveLimit);

      // Execute Query
      final querySnapshot = await query.get();
      List<Event> events =
          querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();

      if (kDebugMode) {
        print(
            'searchEvents: Firestore query executed. Returning ${events.length} events.');
      }

      return events;
    } catch (e, st) {
      if (kDebugMode) print('Error searching events: $e\n$st');
      if (kDebugMode && e.toString().contains('requires an index')) {
        print(
            'Firestore Index Required! Check console for link. Likely needed for title_lowercase field or combination with sorting/filters.');
      }
      rethrow;
    }
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
}
