import 'app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<void> sendPasswordReset(String email);

  Future<void> startPhoneLogin(String phoneNumber);

  Future<AppUser?> verifyOtp({
    required String verificationId,
    required String smsCode,
    required bool rememberMe,
  });

  Future<AppUser?> signInWithGoogle({required bool rememberMe});

  Future<void> signOut({bool allDevices = false});
}
