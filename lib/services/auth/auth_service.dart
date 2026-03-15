// lib/services/auth/auth_service.dart

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// 인증 서비스
///
/// 익명 → Google/Apple 로그인 업그레이드 지원.
/// 기존 익명 계정의 데이터를 유지하면서 실명 계정으로 링크.
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool _googleInitialized = false;

  /// 현재 사용자
  static User? get currentUser => _auth.currentUser;

  /// 로그인 상태 확인
  static bool get isSignedIn => _auth.currentUser != null;

  /// 익명 사용자 여부
  static bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;

  /// 인증 상태 스트림
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ========================================================================
  // Google 로그인
  // ========================================================================

  /// Google 계정으로 로그인/링크
  ///
  /// 현재 익명 계정이 있으면 링크하여 데이터 유지.
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // GoogleSignIn v7+ API
      final googleSignIn = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await googleSignIn.initialize();
        _googleInitialized = true;
      }

      final account = await googleSignIn.authenticate();
      final idToken = account.authentication.idToken;

      if (idToken == null) {
        debugPrint('[Auth] Google sign-in: no idToken');
        return null;
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      // 익명 계정이면 링크, 아니면 로그인
      if (_auth.currentUser != null && _auth.currentUser!.isAnonymous) {
        debugPrint('[Auth] Linking anonymous account with Google');
        final result = await _auth.currentUser!.linkWithCredential(credential);
        debugPrint('[Auth] Google link success: ${result.user?.uid}');
        return result;
      } else {
        final result = await _auth.signInWithCredential(credential);
        debugPrint('[Auth] Google sign-in success: ${result.user?.uid}');
        return result;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        debugPrint('[Auth] Google account already linked to another user');
      }
      debugPrint('[Auth] Google sign-in error: ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint('[Auth] Google sign-in failed: $e');
      rethrow;
    }
  }

  // ========================================================================
  // Apple 로그인
  // ========================================================================

  /// Apple 계정으로 로그인/링크 (iOS only)
  static Future<UserCredential?> signInWithApple() async {
    if (!Platform.isIOS) {
      debugPrint('[Auth] Apple sign-in is only available on iOS');
      return null;
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // 익명 계정이면 링크
      if (_auth.currentUser != null && _auth.currentUser!.isAnonymous) {
        debugPrint('[Auth] Linking anonymous account with Apple');
        final result =
            await _auth.currentUser!.linkWithCredential(oauthCredential);
        debugPrint('[Auth] Apple link success: ${result.user?.uid}');
        return result;
      } else {
        final result = await _auth.signInWithCredential(oauthCredential);
        debugPrint('[Auth] Apple sign-in success: ${result.user?.uid}');
        return result;
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('[Auth] Apple sign-in cancelled');
        return null;
      }
      debugPrint('[Auth] Apple sign-in error: ${e.code}');
      rethrow;
    } on FirebaseAuthException catch (e) {
      debugPrint('[Auth] Apple sign-in error: ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint('[Auth] Apple sign-in failed: $e');
      rethrow;
    }
  }

  // ========================================================================
  // 로그아웃
  // ========================================================================

  /// 로그아웃 후 익명 로그인으로 복귀
  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
      // 익명 로그인으로 복귀 (앱 기능 유지)
      await _auth.signInAnonymously();
      debugPrint('[Auth] Signed out, reverted to anonymous');
    } catch (e) {
      debugPrint('[Auth] Sign out failed: $e');
      rethrow;
    }
  }

  // ========================================================================
  // 유틸리티
  // ========================================================================

  /// 로그인 제공자 이름
  static String get providerName {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) return 'anonymous';
    for (final info in user.providerData) {
      if (info.providerId == 'google.com') return 'Google';
      if (info.providerId == 'apple.com') return 'Apple';
    }
    return 'unknown';
  }

  /// Apple 로그인 가능 여부
  static bool get isAppleSignInAvailable => Platform.isIOS;
}
