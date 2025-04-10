import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A service class that handles direct interactions with Firebase Firestore.
/// This class provides low-level access to Firestore operations.
class FirestoreService {
  FirestoreService({
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // Get a document reference
  DocumentReference<Map<String, dynamic>> document(String path) {
    return _firestore.doc(path);
  }

  // Get a collection reference
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  // Get a document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String path) {
    return document(path).get();
  }

  // Get a collection
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String path, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = collection(path);
    
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.get();
  }

  // Stream a document
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String path) {
    return document(path).snapshots();
  }

  // Stream a collection
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String path, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = collection(path);
    
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots();
  }

  // Add a document to a collection
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String path,
    Map<String, dynamic> data,
  ) {
    return collection(path).add(data);
  }

  // Set a document
  Future<void> setDocument(
    String path,
    Map<String, dynamic> data, {
    bool merge = true,
  }) {
    return document(path).set(data, SetOptions(merge: merge));
  }

  // Update a document
  Future<void> updateDocument(String path, Map<String, dynamic> data) {
    return document(path).update(data);
  }

  // Delete a document
  Future<void> deleteDocument(String path) {
    return document(path).delete();
  }

  // Perform a batch write
  Future<void> batchWrite(List<void Function(WriteBatch batch)> operations) {
    final batch = _firestore.batch();
    
    for (final operation in operations) {
      operation(batch);
    }
    
    return batch.commit();
  }

  // Perform a transaction
  Future<T> transaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler,
  ) {
    return _firestore.runTransaction(transactionHandler);
  }

  // Get user role from Firestore
  Future<String> getUserRole(String userId) async {
    final doc = await getDocument('users/$userId');
    return doc.data()?['role'] as String? ?? 'guest';
  }

  // Stream user role changes
  Stream<String> streamUserRole(String userId) {
    return streamDocument('users/$userId').map(
      (snapshot) => snapshot.data()?['role'] as String? ?? 'guest',
    );
  }
}
