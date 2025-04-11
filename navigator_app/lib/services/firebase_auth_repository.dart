import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigator_app/models/app_user.dart';
import 'package:navigator_app/services/exception_errors.dart';

class FirebaseAuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  AppUser? get currentUser => _convertUser(_firebaseAuth.currentUser);

  AppUser? _convertUser(User? user) =>
      user == null ? null : AppUser.fromUser(user);

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_convertUser);
  }

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw NetworkException(),
          );
      final user = _convertUser(userCredential.user);
      if (user == null) {
        throw AuthException('Failed to get user data after sign in');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } on Exception catch (e) {
      throw AuthException('Unexpected error: $e');
    }
  }

  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw NetworkException(),
          );
      final user = _convertUser(userCredential.user);
      if (user == null) {
        throw AuthException('Failed to get user data after sign in');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } on Exception catch (e) {
      throw AuthException('Unexpected error: $e');
    }
  }

  Future<void> signOut() async {
    try {
    await _firebaseAuth.signOut();
  } on FirebaseAuthException catch (e) {
    throw AuthException('Sign out error: ${e.message}');
  } on Exception catch (e) {
    throw AuthException('Unexpected error during sign out: $e');
  }
  }
}
