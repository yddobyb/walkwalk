// lib/services/ai/ai_consent_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 제3자 AI 데이터 전송 동의 관리 서비스
///
/// Phase 27 (법적 고지 대응):
/// - Apple App Store Review Guideline 5.1.2(i): 제3자 AI에 개인정보를 공유하기
///   전에 명시적으로 고지하고 동의를 받아야 함
/// - 개인정보보호법 제28조의8: 개인정보 국외 이전 시 고지·동의
///
/// 동의는 opt-in(기본 미동의)이며, 동의하지 않아도 산책·미션·통계 등
/// 나머지 기능은 모두 사용할 수 있다. 설정에서 언제든 철회 가능.
class AiConsentService {
  static const String _consentKey = 'ai_third_party_consent';
  static const String _consentAtKey = 'ai_third_party_consent_at';

  /// 동의 여부 조회 (기본값: 미동의)
  Future<bool> hasConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey) ?? false;
  }

  /// 동의 시각 조회 (미동의 시 null) — 처리방침 고지 이력용
  Future<DateTime?> consentedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString(_consentAtKey);
    if (iso == null) return null;
    return DateTime.tryParse(iso);
  }

  /// 동의 부여
  Future<void> grant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
    await prefs.setString(_consentAtKey, DateTime.now().toIso8601String());
    debugPrint('✅ AiConsentService - consent granted');
  }

  /// 동의 철회
  Future<void> withdraw() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, false);
    await prefs.remove(_consentAtKey);
    debugPrint('🚫 AiConsentService - consent withdrawn');
  }
}

final aiConsentServiceProvider = Provider<AiConsentService>(
  (ref) => AiConsentService(),
);

/// 현재 동의 상태 (UI 구독용)
///
/// 동의/철회 후에는 `ref.invalidate(aiConsentProvider)`로 갱신한다.
final aiConsentProvider = FutureProvider<bool>((ref) async {
  return ref.read(aiConsentServiceProvider).hasConsent();
});
