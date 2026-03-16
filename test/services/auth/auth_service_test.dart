// test/services/auth/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/auth/auth_service.dart';

/// AuthService 유닛 테스트
///
/// 테스트 항목:
/// 1. Firebase 미초기화 시 안전한 접근 (테스트 환경)
/// 2. providerName 로직
/// 3. isAppleSignInAvailable (Platform.isIOS)
///
/// Note: FirebaseAuth, GoogleSignIn 등은 플랫폼 의존 →
/// 테스트 환경에서는 Firebase 미초기화 상태의 예외 처리를 검증.
void main() {
  group('AuthService Tests', () {
    // ========================================================================
    // 1. Firebase 미초기화 시 안전한 접근
    // ========================================================================
    test('currentUser - Firebase 미초기화 시 예외 발생', () {
      // 테스트 환경에서 FirebaseAuth.instance 접근 → 예외
      expect(
        () => AuthService.currentUser,
        throwsA(anything),
      );
    });

    test('isSignedIn - Firebase 미초기화 시 예외 발생', () {
      expect(
        () => AuthService.isSignedIn,
        throwsA(anything),
      );
    });

    test('isAnonymous - Firebase 미초기화 시 예외 발생', () {
      // 이것이 settings_screen.dart에서 try-catch로 감싼 이유
      expect(
        () => AuthService.isAnonymous,
        throwsA(anything),
      );
    });

    test('providerName - Firebase 미초기화 시 예외 발생', () {
      expect(
        () => AuthService.providerName,
        throwsA(anything),
      );
    });

    test('authStateChanges - Firebase 미초기화 시 예외 발생', () {
      expect(
        () => AuthService.authStateChanges,
        throwsA(anything),
      );
    });

    // ========================================================================
    // 2. isAppleSignInAvailable
    // ========================================================================
    test('isAppleSignInAvailable - macOS 테스트 환경에서 false', () {
      // macOS에서 테스트 실행 → Platform.isIOS == false
      // 따라서 isAppleSignInAvailable == false
      expect(AuthService.isAppleSignInAvailable, isFalse);
    });

    // ========================================================================
    // 3. signInWithGoogle - Firebase 미초기화 시 예외
    // ========================================================================
    test('signInWithGoogle - Firebase 미초기화 시 예외', () async {
      // GoogleSignIn.instance 접근 시 예외
      expect(
        () => AuthService.signInWithGoogle(),
        throwsA(anything),
      );
    });

    // ========================================================================
    // 4. signInWithApple - 비iOS에서 null 반환
    // ========================================================================
    test('signInWithApple - macOS 환경에서 null 반환', () async {
      // Platform.isIOS == false → 즉시 null 반환
      final result = await AuthService.signInWithApple();
      expect(result, isNull);
    });

    // ========================================================================
    // 5. signOut - Firebase 미초기화 시 예외
    // ========================================================================
    test('signOut - Firebase 미초기화 시 예외', () async {
      expect(
        () => AuthService.signOut(),
        throwsA(anything),
      );
    });
  });
}
