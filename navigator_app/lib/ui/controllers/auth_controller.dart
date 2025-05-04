import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/core/utils/exception_errors.dart';
import 'package:navigator_app/data/repositories/firebase_auth_repository.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/core/utils/loading_state.dart';
import 'package:navigator_app/data/repositories/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  FirebaseAuthRepository? _authRepository;
  UserRepository? _userRepository;

  @override
  AuthLoadingState build() {
    // Initialize or re-assign on build
    _authRepository = ref.watch(authRepositoryProvider);
    _userRepository = ref.watch(userRepositoryProvider);

    // Return initial state
    return const AuthLoadingState(LoadingStateEnum.initial, null);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (_authRepository == null) {
       state = AuthLoadingState(LoadingStateEnum.error, AuthException('Auth repository not initialized'));
       return;
    }
    if (email.isEmpty || password.isEmpty) {
      state = AuthLoadingState(LoadingStateEnum.error,
          AuthException('Email and password cannot be empty'));
      return;
    }

    if (!_isValidEmail(email)) {
      state = AuthLoadingState(LoadingStateEnum.error, InvalidEmailException());
      return;
    }
    return _executeAuthAction(() => _authRepository!.signInWithEmailAndPassword(
          email: email,
          password: password,
        ));
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
    required String phoneNumber,
    required List<String> preferences,
  }) async {
    // Add null checks
    if (_authRepository == null || _userRepository == null) {
       state = AuthLoadingState(LoadingStateEnum.error, AuthException('Repositories not initialized'));
       return;
    }
    if (email.isEmpty || password.isEmpty) {
      state = AuthLoadingState(LoadingStateEnum.error,
          AuthException('Email and password cannot be empty'));
      return;
    }

    if (!_isValidEmail(email)) {
      state = AuthLoadingState(LoadingStateEnum.error, InvalidEmailException());
      return;
    }
    final user = await _executeAuthAction<AppUser>(
        () => _authRepository!.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ));

    // Use null-aware operator just in case, though user should be non-null on success
    if (user != null) {
       await _userRepository!.saveUser(user.copyWith(
         userName: userName,
         phoneNumber: phoneNumber,
         preferences: preferences,
       ));
    } else {
       // Handle unexpected null user case if necessary
       state = AuthLoadingState(LoadingStateEnum.error, AuthException('User creation failed unexpectedly'));
    }
  }

  Future<void> signOut() async {
    // Add null check
    if (_authRepository == null) {
       state = AuthLoadingState(LoadingStateEnum.error, AuthException('Auth repository not initialized'));
       return;
    }
    return _executeAuthAction(() => _authRepository!.signOut());
  }

  Future<T> _executeAuthAction<T>(Future<T> Function() authAction) async {
    state = const AuthLoadingState(LoadingStateEnum.loading, null);
    try {
      final result = await authAction();
      state = const AuthLoadingState(LoadingStateEnum.success, null);
      return result;
    } on Exception catch (e) {
      state = AuthLoadingState(LoadingStateEnum.error, e);
      rethrow;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$'); // Added $ for end anchor
    return emailRegExp.hasMatch(email);
  }
}

