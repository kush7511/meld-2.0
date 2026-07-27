import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    required SharedPreferences preferences,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _preferences = preferences;

  static const _rememberMeKey = 'auth.remember_me';

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _preferences;

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_mapUser);
  }

  @override
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _preferences.setBool(_rememberMeKey, rememberMe);
    return _mapUser(credential.user);
  }

  @override
  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> startPhoneLogin(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _auth.signInWithCredential,
      verificationFailed: (error) => throw error,
      codeSent: (verificationId, resendToken) {},
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  @override
  Future<AppUser?> verifyOtp({
    required String verificationId,
    required String smsCode,
    required bool rememberMe,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    await _preferences.setBool(_rememberMeKey, rememberMe);
    return _mapUser(result.user);
  }

  @override
  Future<AppUser?> signInWithGoogle({required bool rememberMe}) async {
    await _googleSignIn.initialize();
    final account = await _googleSignIn.authenticate();
    final tokens = account.authentication;
    final credential = GoogleAuthProvider.credential(idToken: tokens.idToken);
    final result = await _auth.signInWithCredential(credential);
    await _preferences.setBool(_rememberMeKey, rememberMe);
    return _mapUser(result.user);
  }

  @override
  Future<void> signOut({bool allDevices = false}) async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
      _preferences.setBool(_rememberMeKey, false),
    ]);
  }

  AppUser? _mapUser(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      username: user.email?.split('@').first ?? user.phoneNumber ?? 'user',
      photoUrl: user.photoURL,
      isOnline: true,
      lastActive: DateTime.now(),
    );
  }
}
