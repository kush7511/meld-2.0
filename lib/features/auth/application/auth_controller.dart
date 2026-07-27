import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../data/firebase_auth_repository.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    preferences: ref.watch(sharedPreferencesProvider),
  );
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repository) : super(const AsyncData(null));

  final AuthRepository _repository;

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.signInWithEmail(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ),
    );
  }

  Future<void> signInWithGoogle({required bool rememberMe}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.signInWithGoogle(rememberMe: rememberMe),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.sendPasswordReset(email));
  }

  Future<void> startPhoneLogin(String phoneNumber) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.startPhoneLogin(phoneNumber));
  }

  Future<void> signOut({bool allDevices = false}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.signOut(allDevices: allDevices),
    );
  }
}
