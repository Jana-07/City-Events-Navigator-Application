import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigator_app/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'firebase_auth_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuthRepository authRepository(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(auth);
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(Ref ref) {
  final auth = ref.watch(authRepositoryProvider);
  return auth.authStateChanges();
}

class FirebaseAuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  AppUser? get currentUser => _convertUser(_firebaseAuth.currentUser);

  AppUser? _convertUser(User? user) =>
      user == null ? null : AppUser.fromUser(user);

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_convertUser);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
