import 'package:navigator_app/services/firebase_auth_repository.dart';
import 'package:navigator_app/services/loading_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthLoadingState build() {
    return const AuthLoadingState(LoadingStateEnum.initial, null);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AuthLoadingState(LoadingStateEnum.loading, null);
    try {
      final authRepository = ref.watch(authRepositoryProvider);
      await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AuthLoadingState(LoadingStateEnum.success, null);
    } on Exception catch (e) {
      state = AuthLoadingState(LoadingStateEnum.error, e);
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email, String password) async {
        state = const AuthLoadingState(LoadingStateEnum.loading, null);
        try {
            final authRepository = ref.watch(authRepositoryProvider);
            await authRepository.createUserWithEmailAndPassword(
            email: email, password: password);
        state = const AuthLoadingState(LoadingStateEnum.success, null);
        } on Exception catch (e) {
            state = AuthLoadingState(LoadingStateEnum.error, e);
        }
    }
    
    Future<void> signOut() async {
        state = const AuthLoadingState(LoadingStateEnum.loading, null);

        final authRepository = ref.watch(authRepositoryProvider);
        try {
            await authRepository.signOut();
            state = const AuthLoadingState(LoadingStateEnum.success, null);
        } on Exception catch (e) {
            state = AuthLoadingState(LoadingStateEnum.error, e);
        }
    }
}
