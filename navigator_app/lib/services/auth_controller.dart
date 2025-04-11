import 'package:navigator_app/models/app_user.dart';
import 'package:navigator_app/services/exception_errors.dart';
import 'package:navigator_app/services/firebase_auth_repository.dart';
import 'package:navigator_app/services/firebase_rivrpod_provider.dart';
import 'package:navigator_app/services/loading_state.dart';
import 'package:navigator_app/services/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  late final FirebaseAuthRepository _authRepository;
  late final UserRepository _userRepository;

  @override
  AuthLoadingState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _userRepository = ref.watch(userRepositoryProvider);

    return const AuthLoadingState(LoadingStateEnum.initial, null);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = AuthLoadingState(LoadingStateEnum.error,
          AuthException('Email and password cannot be empty'));
      return;
    }

    if (!_isValidEmail(email)) {
      state = AuthLoadingState(LoadingStateEnum.error, InvalidEmailException());
      return;
    }
    return _executeAuthAction(() => _authRepository.signInWithEmailAndPassword(
          email: email,
          password: password,
        ));
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = AuthLoadingState(LoadingStateEnum.error,
          AuthException('Email and password cannot be empty'));
      return;
    }

    if (!_isValidEmail(email)) {
      state = AuthLoadingState(LoadingStateEnum.error, InvalidEmailException());
      return;
    }
    final user =  await _executeAuthAction<AppUser>(
        () => _authRepository.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ));

    await _userRepository.saveUser(user);
  }

  Future<void> signOut() async {
    return _executeAuthAction(() => _authRepository.signOut());
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
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }
}
