// test/services/subscription/revenue_cat_auto_mapping_test.dart
//
// RevenueCat App Store 계정 자동 매핑 구현 종합 테스트
//
// 검증 항목:
// 1. 초기화 순서 (main.dart): 익명 로그인 → RevenueCat 순서
// 2. appUserID 미설정 확인 (소스 코드 검증)
// 3. _autoRestoreOnStartup 메서드 존재 확인
// 4. 플레이스홀더 키 안전 모드 (모든 메서드)
// 5. PurchaseResult 모델 완전성
// 6. 이중 초기화 방지 (idempotency)
// 7. Firestore 동기화 안전성 (uid null 시)
// 8. UserTierService 통합 테스트
// 9. customerInfoStream 안전성

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/services/subscription/revenue_cat_service.dart';
import 'package:walk_dog/services/user/user_tier_service.dart';

void main() {
  // =========================================================
  // 1. 소스 코드 구조 검증: main.dart 초기화 순서
  // =========================================================
  group('main.dart 초기화 순서 검증', () {
    late String mainSource;

    setUpAll(() {
      final file = File('lib/main.dart');
      mainSource = file.readAsStringSync();
    });

    test('익명 로그인이 RevenueCat 초기화보다 먼저 실행됨', () {
      final authIndex = mainSource.indexOf('signInAnonymously()');
      final rcIndex = mainSource.indexOf(
        'RevenueCatService.initialize()',
      );

      expect(authIndex, greaterThan(-1), reason: '익명 로그인 코드 존재');
      expect(rcIndex, greaterThan(-1), reason: 'RevenueCat 초기화 코드 존재');
      expect(
        authIndex,
        lessThan(rcIndex),
        reason: '익명 로그인이 RevenueCat 초기화보다 앞에 위치해야 함',
      );
    });

    test('익명 로그인이 try-catch로 보호됨', () {
      // signInAnonymously 앞에 try가 있는지 확인
      final tryIndex = mainSource.indexOf('try {');
      final authIndex = mainSource.indexOf('signInAnonymously()');
      final catchIndex = mainSource.indexOf(
        "debugPrint('[AUTH] Anonymous authentication failed:",
      );

      expect(tryIndex, lessThan(authIndex));
      expect(catchIndex, greaterThan(authIndex));
    });

    test('Firebase 초기화가 익명 로그인보다 먼저 실행됨', () {
      final firebaseIndex = mainSource.indexOf(
        'FirebaseService.initialize()',
      );
      final authIndex = mainSource.indexOf('signInAnonymously()');

      expect(
        firebaseIndex,
        lessThan(authIndex),
        reason: 'Firebase 초기화 → 익명 로그인 순서',
      );
    });

    test('디버그 print가 debugPrint로 통일됨 (print 미사용)', () {
      // main() 함수 내에서 print() 직접 호출이 없어야 함
      // (debugPrint만 허용)
      final lines = mainSource.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        // import 줄이나 주석은 제외
        if (trimmed.startsWith('import') || trimmed.startsWith('//')) {
          continue;
        }
        // print( 로 시작하는 직접 호출이 없어야 함
        // debugPrint는 OK
        if (trimmed.contains(RegExp(r'\bprint\('))) {
          fail(
            'main.dart에서 print() 직접 호출 발견 '
            '(debugPrint로 교체 필요): $trimmed',
          );
        }
      }
    });
  });

  // =========================================================
  // 2. 소스 코드 구조 검증: revenue_cat_service.dart
  // =========================================================
  group('revenue_cat_service.dart 소스 코드 검증', () {
    late String rcSource;

    setUpAll(() {
      final file = File(
        'lib/services/subscription/revenue_cat_service.dart',
      );
      rcSource = file.readAsStringSync();
    });

    test('appUserID가 설정되지 않음 (config.appUserID 미사용)', () {
      // appUserID가 할당되는 코드가 없어야 함
      expect(
        rcSource.contains('config.appUserID'),
        isFalse,
        reason: 'appUserID를 설정하면 안 됨 '
            '(RevenueCat 자동 매핑 사용)',
      );
      expect(
        rcSource.contains('appUserID ='),
        isFalse,
        reason: 'appUserID 할당 코드가 없어야 함',
      );
    });

    test('_autoRestoreOnStartup 메서드가 존재함', () {
      expect(
        rcSource.contains('_autoRestoreOnStartup'),
        isTrue,
        reason: '앱 시작 시 자동 복원 메서드 필요',
      );
    });

    test('_autoRestoreOnStartup이 getCustomerInfo를 사용함 '
        '(restorePurchases 아님)', () {
      // _autoRestoreOnStartup 메서드 본문 추출
      final startIdx = rcSource.indexOf(
        'static Future<void> _autoRestoreOnStartup()',
      );
      final endIdx = rcSource.indexOf(
        'static Future<void> _syncSubscriptionToFirestore(',
      );
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('Purchases.getCustomerInfo()'),
        isTrue,
        reason: 'getCustomerInfo()를 사용해야 함',
      );
      expect(
        methodBody.contains('Purchases.restorePurchases()'),
        isFalse,
        reason: 'restorePurchases()는 Apple 리젝 위험이 있어 '
            '사용하면 안 됨',
      );
    });

    test('_autoRestoreOnStartup이 try-catch로 보호됨 '
        '(non-fatal)', () {
      final startIdx = rcSource.indexOf(
        'static Future<void> _autoRestoreOnStartup()',
      );
      final endIdx = rcSource.indexOf(
        'static Future<void> _syncSubscriptionToFirestore(',
      );
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(methodBody.contains('try {'), isTrue);
      expect(methodBody.contains('catch (e)'), isTrue);
      expect(
        methodBody.contains('non-fatal'),
        isTrue,
        reason: '실패 시 non-fatal 로그 출력',
      );
    });

    test('initialize()에서 _autoRestoreOnStartup이 호출됨', () {
      // initialize() 메서드 본문에서 _autoRestoreOnStartup 호출 확인
      final initStart = rcSource.indexOf(
        'static Future<void> initialize()',
      );
      final initEnd = rcSource.indexOf(
        '/// 프리미엄 엔타이틀먼트 보유 여부',
      );
      final initBody = rcSource.substring(initStart, initEnd);

      expect(
        initBody.contains('await _autoRestoreOnStartup()'),
        isTrue,
        reason: 'initialize()에서 _autoRestoreOnStartup() 호출 필요',
      );
    });

    test('_syncSubscriptionToFirestore가 uid null 시 즉시 반환', () {
      final startIdx = rcSource.indexOf(
        'static Future<void> _syncSubscriptionToFirestore(',
      );
      final endIdx = rcSource.lastIndexOf('}');
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('if (uid == null) return'),
        isTrue,
        reason: 'uid가 null이면 Firestore 쓰기를 건너뛰어야 함',
      );
    });

    test('Firestore 동기화에 merge: true 옵션 사용', () {
      expect(
        rcSource.contains('SetOptions(merge: true)'),
        isTrue,
        reason: '기존 사용자 데이터를 덮어쓰지 않도록 merge 옵션 필요',
      );
    });

    test('PurchasesConfiguration에 apiKey만 전달', () {
      expect(
        rcSource.contains('PurchasesConfiguration(apiKey)'),
        isTrue,
        reason: 'apiKey만 전달하고 appUserID는 미설정',
      );
    });
  });

  // =========================================================
  // 3. 플레이스홀더 키 안전 모드 테스트
  // =========================================================
  group('플레이스홀더 키 안전 모드', () {
    test('isConfigured가 false', () {
      expect(RevenueCatService.isConfigured, isFalse);
    });

    test('hasPremiumEntitlement → false', () async {
      final result =
          await RevenueCatService.hasPremiumEntitlement();
      expect(result, isFalse);
    });

    test('getMonthlyProduct → null', () async {
      final product =
          await RevenueCatService.getMonthlyProduct();
      expect(product, isNull);
    });

    test('restorePurchases → error', () async {
      final result = await RevenueCatService.restorePurchases();
      expect(result.success, isFalse);
      expect(result.errorMessage, 'Store not configured');
      expect(result.isCancelled, isFalse);
      expect(result.alreadySubscribed, isFalse);
    });

    test('customerInfoStream → empty', () async {
      final stream = RevenueCatService.customerInfoStream;
      final events = await stream.toList();
      expect(events, isEmpty);
    });

    test('hasPremiumEntitlement 여러 번 호출해도 안전', () async {
      // 반복 호출 시 에러 없이 동일 결과
      for (var i = 0; i < 5; i++) {
        final result =
            await RevenueCatService.hasPremiumEntitlement();
        expect(result, isFalse);
      }
    });

    test('restorePurchases 여러 번 호출해도 안전', () async {
      for (var i = 0; i < 3; i++) {
        final result =
            await RevenueCatService.restorePurchases();
        expect(result.success, isFalse);
        expect(result.errorMessage, 'Store not configured');
      }
    });
  });

  // =========================================================
  // 4. PurchaseResult 모델 완전성 테스트
  // =========================================================
  group('PurchaseResult 모델 edge cases', () {
    test('기본 생성자: 모든 필드 false/null', () {
      const r = PurchaseResult();
      expect(r.success, isFalse);
      expect(r.alreadySubscribed, isFalse);
      expect(r.isCancelled, isFalse);
      expect(r.errorMessage, isNull);
    });

    test('성공 결과', () {
      const r = PurchaseResult(success: true);
      expect(r.success, isTrue);
      expect(r.isCancelled, isFalse);
      expect(r.errorMessage, isNull);
    });

    test('취소 결과', () {
      const r = PurchaseResult(isCancelled: true);
      expect(r.success, isFalse);
      expect(r.isCancelled, isTrue);
    });

    test('에러 결과', () {
      const r = PurchaseResult(errorMessage: 'Network error');
      expect(r.success, isFalse);
      expect(r.errorMessage, 'Network error');
    });

    test('이미 구독 결과', () {
      const r = PurchaseResult(alreadySubscribed: true);
      expect(r.alreadySubscribed, isTrue);
      expect(r.success, isFalse);
    });

    test('복합 상태: success + errorMessage (비정상이지만 가능)', () {
      const r = PurchaseResult(
        success: true,
        errorMessage: 'Warning',
      );
      expect(r.success, isTrue);
      expect(r.errorMessage, 'Warning');
    });

    test('빈 문자열 에러 메시지', () {
      const r = PurchaseResult(errorMessage: '');
      expect(r.errorMessage, isEmpty);
      expect(r.success, isFalse);
    });

    test('const 생성 가능 (immutable)', () {
      // const 생성이 컴파일 타임에 가능한지 확인
      const r1 = PurchaseResult(success: true);
      const r2 = PurchaseResult(success: true);
      expect(identical(r1, r2), isTrue);
    });
  });

  // =========================================================
  // 5. 이중 초기화 방지 (idempotency)
  // =========================================================
  group('초기화 idempotency', () {
    test('initialize() 여러 번 호출해도 에러 없음', () async {
      // 플레이스홀더 키이므로 내부적으로 _initialized = true만 설정
      // 두 번째 호출부터는 즉시 반환
      await RevenueCatService.initialize();
      await RevenueCatService.initialize();
      await RevenueCatService.initialize();

      // 여전히 unconfigured
      expect(RevenueCatService.isConfigured, isFalse);
    });
  });

  // =========================================================
  // 6. UserTierService 통합 테스트
  // =========================================================
  group('UserTierService + RevenueCat 통합', () {
    late UserTierService service;

    setUp(() {
      service = UserTierService();
    });

    test('unconfigured 상태에서 getCurrentTier → free', () async {
      final tier = await service.getCurrentTier();
      expect(tier, UserTier.free);
    });

    test('unconfigured 상태에서 isPremium → false', () async {
      expect(await service.isPremium(), isFalse);
    });

    test('unconfigured 상태에서 isFree → true', () async {
      expect(await service.isFree(), isTrue);
    });

    test('getCurrentTier 반복 호출 일관성', () async {
      final results = <UserTier>[];
      for (var i = 0; i < 5; i++) {
        results.add(await service.getCurrentTier());
      }
      expect(results, everyElement(UserTier.free));
    });
  });

  // =========================================================
  // 7. UserTier enum 확장 메서드 안전성
  // =========================================================
  group('UserTier enum 안전성', () {
    test('모든 tier의 dailyImageLimit > 0', () {
      for (final tier in UserTier.values) {
        expect(tier.dailyImageLimit, greaterThan(0));
      }
    });

    test('premium limit > free limit', () {
      expect(
        UserTier.premium.dailyImageLimit,
        greaterThan(UserTier.free.dailyImageLimit),
      );
    });

    test('모든 tier의 cloudFunctionName이 비어있지 않음', () {
      for (final tier in UserTier.values) {
        expect(tier.cloudFunctionName, isNotEmpty);
      }
    });

    test('free와 premium의 cloudFunctionName이 다름', () {
      expect(
        UserTier.free.cloudFunctionName,
        isNot(UserTier.premium.cloudFunctionName),
      );
    });

    test('모든 tier의 displayName이 비어있지 않음', () {
      for (final tier in UserTier.values) {
        expect(tier.displayName, isNotEmpty);
      }
    });
  });

  // =========================================================
  // 8. customerInfoStream 안전성
  // =========================================================
  group('customerInfoStream 안전성', () {
    test('unconfigured 시 empty stream → toList 즉시 완료', () async {
      final events =
          await RevenueCatService.customerInfoStream.toList();
      expect(events, isEmpty);
    });

    test('여러 번 stream 생성해도 안전', () async {
      for (var i = 0; i < 3; i++) {
        final events =
            await RevenueCatService.customerInfoStream.toList();
        expect(events, isEmpty);
      }
    });
  });
}
