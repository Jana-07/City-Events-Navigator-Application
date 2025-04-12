import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String comment;
  final DateTime createdAt;
  final double stars;
  final String userID;
  final String userName;
  final String userProfilePhotoURL;

  Review({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.stars,
    required this.userID,
    required this.userName,
    required this.userProfilePhotoURL,
  });

  // Create from Firestore document
  factory Review.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return Review(
      id: doc.id,
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stars: (data['stars'] as num?)?.toDouble() ?? 0.0,
      userID: data['userID'] ?? '',
      userName: data['userName'] ?? '',
      userProfilePhotoURL: data['userProfilePhotoURL'] ?? '',
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'stars': stars,
      'userID': userID,
      'userName': userName,
      'userProfilePhotoURL': userProfilePhotoURL,
    };
  }

  // Create a copy with updated fields
  Review copyWith({
    String? comment,
    DateTime? createdAt,
    double? stars,
    String? userID,
    String? userName,
    String? userProfilePhotoURL,
  }) {
    return Review(
      id: id,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      stars: stars ?? this.stars,
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      userProfilePhotoURL: userProfilePhotoURL ?? this.userProfilePhotoURL,
    );
  }
}
