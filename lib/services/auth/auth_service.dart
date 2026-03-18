// lib/services/auth/auth_service.dart

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../subscription/revenue_cat_service.dart';

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
      // 보안: currentUser를 한 번만 읽어 TOCTOU 레이스 방지
      final currentUser = _auth.currentUser;
      UserCredential result;
      if (currentUser != null && currentUser.isAnonymous) {
        debugPrint('[Auth] Linking anonymous account with Google');
        result = await currentUser.linkWithCredential(credential);
        debugPrint('[Auth] Google link success: ${result.user?.uid}');
      } else {
        result = await _auth.signInWithCredential(credential);
        debugPrint('[Auth] Google sign-in success: ${result.user?.uid}');
      }

      // RevenueCat에 사용자 ID 연동 (기기 간 구독 자동 복원)
      if (result.user != null) {
        await RevenueCatService.logIn(result.user!.uid);
      }

      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use' && e.credential != null) {
        // 이미 다른 계정에 연결된 Google 계정 → 링크 포기, 직접 로그인
        debugPrint('[Auth] Google already linked, signing in directly');
        final result = await _auth.signInWithCredential(e.credential!);
        debugPrint('[Auth] Google direct sign-in: ${result.user?.uid}');
        if (result.user != null) {
          await RevenueCatService.logIn(result.user!.uid);
        }
        return result;
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
      // 보안: currentUser를 한 번만 읽어 TOCTOU 레이스 방지
      final currentUser = _auth.currentUser;
      UserCredential result;
      if (currentUser != null && currentUser.isAnonymous) {
        debugPrint('[Auth] Linking anonymous account with Apple');
        result = await currentUser.linkWithCredential(oauthCredential);
        debugPrint('[Auth] Apple link success: ${result.user?.uid}');
      } else {
        result = await _auth.signInWithCredential(oauthCredential);
        debugPrint('[Auth] Apple sign-in success: ${result.user?.uid}');
      }

      // RevenueCat에 사용자 ID 연동 (기기 간 구독 자동 복원)
      if (result.user != null) {
        await RevenueCatService.logIn(result.user!.uid);
      }

      return result;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('[Auth] Apple sign-in cancelled');
        return null;
      }
      debugPrint('[Auth] Apple sign-in error: ${e.code}');
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use' && e.credential != null) {
        // 이미 다른 계정에 연결된 Apple 계정 → 직접 로그인
        debugPrint('[Auth] Apple already linked, signing in directly');
        final result = await _auth.signInWithCredential(e.credential!);
        debugPrint('[Auth] Apple direct sign-in: ${result.user?.uid}');
        if (result.user != null) {
          await RevenueCatService.logIn(result.user!.uid);
        }
        return result;
      }
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
  ///
  /// 순서: RevenueCat logOut → Google SDK signOut → Firebase signOut → 익명 로그인
  /// RevenueCat logOut은 Firebase signOut 전에 호출 (UID가 유효해야 함).
  /// 각 단계 실패 시에도 다음 단계를 계속 진행하여 부분 실패 방지.
  static Future<void> signOut() async {
    Object? firstError;

    // 1. RevenueCat 로그아웃 (새 익명 ID로 복귀)
    try {
      await RevenueCatService.logOut();
    } catch (e) {
      debugPrint('[Auth] RevenueCat logOut failed: $e');
      firstError ??= e;
    }

    // 2. Google SDK signOut (초기화된 경우에만)
    if (_googleInitialized) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        debugPrint('[Auth] Google signOut skipped: $e');
      }
    }

    // 3. Firebase signOut + 익명 로그인 복귀
    try {
      await _auth.signOut();
      await _auth.signInAnonymously();
      debugPrint('[Auth] Signed out, reverted to anonymous');
    } catch (e) {
      debugPrint('[Auth] Firebase signOut failed: $e');
      firstError ??= e;
    }

    // 어느 단계에서든 에러가 있었으면 전파
    if (firstError != null) {
      throw firstError;
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
