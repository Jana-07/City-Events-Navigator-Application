import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final GeoPoint location;
  final String address;
  final String creatorID;
  final String category;
  final double averageRating;
  final int reviewsCount;
  final String imageURL;
  final List<String> imageURLs;
  final double price;
  final List<String> tags;
  final String ticketURL;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DocumentSnapshot? snapshot;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.address,
    required this.creatorID,
    required this.category,
    this.averageRating = 0.0,
    this.reviewsCount = 0,
    this.imageURL = '',
    this.imageURLs = const [],
    this.price = 0.0,
    this.tags = const [],
    this.ticketURL = '',
    required this.createdAt,
    this.updatedAt,
    this.snapshot,
  });

  // Create from Firestore document
  factory Event.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now().add(const Duration(hours: 2)),
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      address: data['address'] ?? '',
      creatorID: data['creatorID'] ?? '',
      category: data['category'] ?? '',
      averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: data['reviewsCount'] ?? 0,
      imageURL: data['imageURL'] ?? '',
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      tags: List<String>.from(data['tags'] ?? []),
      ticketURL: data['ticketURL'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      snapshot: doc,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'address': address,
      'creatorID': creatorID,
      'category': category,
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
      'imageURL': imageURL,
      'imageURLs': imageURLs,
      'price': price,
      'tags': tags,
      'ticketURL': ticketURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Create a copy with updated fields
  Event copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    GeoPoint? location,
    String? address,
    String? creatorID,
    String? category,
    double? averageRating,
    int? reviewsCount,
    String? imageURL,
    List<String>? imageURLs,
    double? price,
    List<String>? tags,
    String? ticketURL,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      address: address ?? this.address,
      creatorID: creatorID ?? this.creatorID,
      category: category ?? this.category,
      averageRating: averageRating ?? this.averageRating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageURL: imageURL ?? this.imageURL,
      imageURLs: imageURLs ?? this.imageURLs,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      ticketURL: ticketURL ?? this.ticketURL,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
