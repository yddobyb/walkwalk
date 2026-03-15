// lib/services/firebase/quota_service.dart

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/quota_response.dart';

/// 할당량 조회 서비스
///
/// Week 4: Firebase Cloud Functions를 통한 할당량 조회
///
/// Usage:
/// ```dart
/// final service = QuotaService();
/// final response = await service.getQuota();
/// print('Remaining: ${response.data.remaining}/${response.data.total}');
/// ```
class QuotaService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  /// 인증 확인 및 필요시 재인증
  Future<void> _ensureAuthenticated() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      debugPrint('🔐 [AUTH] No user authenticated, attempting anonymous sign-in...');
      try {
        final credential = await auth.signInAnonymously();
        debugPrint('🔐 [AUTH] ✅ Anonymous sign-in successful: ${credential.user?.uid}');
      } catch (e) {
        debugPrint('🔐 [AUTH] ❌ Anonymous sign-in failed: $e');
        throw QuotaException(
          code: 'unauthenticated',
          message: 'Failed to authenticate. Please restart the app.',
        );
      }
    }
  }

  /// 할당량 조회
  ///
  /// Returns: 할당량 응답 (남은 횟수, 전체 횟수, 리셋 시간 포함)
  ///
  /// Throws:
  /// - [FirebaseFunctionsException] API 호출 실패
  /// - [FormatException] 응답 파싱 실패
  Future<QuotaResponse> getQuota() async {
    try {
      // 인증 확인 및 필요시 재인증
      await _ensureAuthenticated();

      debugPrint('📊 Fetching quota...');

      final callable = _functions.httpsCallable('quota');
      final result = await callable.call({});

      // result.data는 Map<Object?, Object?>이므로 Map<String, dynamic>으로 deep copy
      final rawData = result.data as Map;
      final data = {
        'success': rawData['success'],
        'data': Map<String, dynamic>.from(rawData['data'] as Map),
      };
      final response = QuotaResponse.fromJson(data);

      debugPrint('✅ Quota fetched successfully');
      debugPrint('   - Remaining: ${response.data.remaining}/${response.data.total}');
      debugPrint('   - Used: ${response.data.used}');
      debugPrint('   - Reset in: ${response.data.formattedTimeUntilReset}');

      return response;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Quota fetch failed: ${e.code}');
      debugPrint('   Message: ${e.message}');
      debugPrint('   Details: ${e.details}');

      throw QuotaException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error: $e');
      debugPrint('   Stack trace: $stackTrace');

      throw QuotaException(
        code: 'unknown',
        message: e.toString(),
      );
    }
  }
}

/// 할당량 조회 예외
class QuotaException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  const QuotaException({
    required this.code,
    required this.message,
    this.details,
  });

  /// 사용자 친화적 메시지
  String get userMessage {
    switch (code) {
      case 'unauthenticated':
        return '로그인이 필요합니다.';
      case 'internal':
        return '할당량 조회에 실패했습니다. 잠시 후 다시 시도해주세요.';
      case 'deadline-exceeded':
        return '요청 시간이 초과되었습니다. 다시 시도해주세요.';
      default:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }

  @override
  String toString() => 'QuotaException($code): $message';
}
