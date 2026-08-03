// lib/core/services/crash_reporting_service.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// 크래시·미처리 예외 수집 (Phase 30).
///
/// 출시 전까지 앱에는 **클라이언트 오류 수집이 전혀 없었다.** 서버 쪽은
/// Firestore `monitoring`(제공자·성공률·지연·폴백)이 잘 갖춰져 있었지만,
/// 앱이 죽는 건 아무도 몰랐다 — 알게 되는 경로가 1점 리뷰뿐이었다.
///
/// **Sentry가 아니라 Crashlytics인 이유**: 이미 Firebase에 전부 올라가 있어
/// (Auth·Functions·Firestore·App Check·Remote Config·Analytics) 새 사업자가
/// 늘지 않는다. Phase 27에서 처리방침에 **국외이전 표**로 수령인을 전부
/// 명시해 뒀기 때문에, 제3자를 추가하면 한/영 문서를 다시 배포해야 한다.
///
/// ⚠️ **패키지보다 아래 두 핸들러가 본체다.** 이걸 걸지 않으면 위젯/렌더
/// 오류와 비동기 미처리 예외가 대부분 수집되지 않는다.
class CrashReportingService {
  CrashReportingService._();

  /// Firebase 초기화 **이후에** 호출할 것.
  ///
  /// 디버그 빌드는 수집하지 않는다 — 개발 중 크래시가 운영 데이터를 오염시킨다.
  /// (검증이 필요하면 [forceEnable]로 일시적으로 켠다)
  static Future<void> initialize({bool? forceEnable}) async {
    final enabled = forceEnable ?? !kDebugMode;
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(enabled);

    // 위젯 빌드·레이아웃·페인트 단계의 프레임워크 오류
    FlutterError.onError = (details) {
      FlutterError.presentError(details); // 콘솔 출력은 유지
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    // 프레임워크 밖에서 터진 비동기 미처리 예외
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true; // 처리했음 — 앱이 조용히 죽지 않게
    };

    debugPrint('[Crash] Crashlytics collection enabled=$enabled');
  }

  /// 치명적이지 않은 오류 기록 (폴백이 돌아 사용자에겐 안 보이는 실패 등).
  ///
  /// 이 앱은 **fail-closed 지점이 많다** — AI 동의 게이트·위치 가용성·
  /// App Check. 거기서 조용히 막히면 이용자에겐 "기능이 안 되는 앱"으로만
  /// 보이므로, 원인을 남겨두지 않으면 추적이 불가능하다.
  static Future<void> recordNonFatal(
    Object error,
    StackTrace? stack, {
    String? reason,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
      fatal: false,
    );
  }

  /// 크래시에 붙일 진단용 힌트.
  ///
  /// ⚠️ **개인정보·프롬프트 내용·UID 원문을 넣지 말 것.** 서버 로그가
  /// `maskUid`를 쓰는 것과 같은 원칙이다. 크래시 리포트는 처리방침상
  /// "진단 정보"이지 이용자 콘텐츠가 아니다.
  static Future<void> setHint(String key, String value) =>
      FirebaseCrashlytics.instance.setCustomKey(key, value);
}
