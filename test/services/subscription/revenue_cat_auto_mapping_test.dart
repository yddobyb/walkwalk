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

    test('Firestore 동기화가 Cloud Function 경유로 수행됨', () {
      expect(
        rcSource.contains("httpsCallable('syncSubscription')"),
        isTrue,
        reason: 'Firestore 동기화는 Cloud Function 경유 (보안)',
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
  // 8. logIn/logOut 연동 테스트 (Phase 14)
  // =========================================================
  group('logIn/logOut - unconfigured 모드 안전성', () {
    test('logIn은 unconfigured 시 에러 없이 즉시 반환', () async {
      // _isConfigured == false → Purchases.logIn 호출 안 함
      await RevenueCatService.logIn('test-user-id-123');
      // 에러 없이 완료되면 성공
      expect(RevenueCatService.isConfigured, isFalse);
    });

    test('logOut은 unconfigured 시 에러 없이 즉시 반환', () async {
      await RevenueCatService.logOut();
      expect(RevenueCatService.isConfigured, isFalse);
    });

    test('logIn 빈 문자열 userId도 에러 없음', () async {
      await RevenueCatService.logIn('');
      expect(RevenueCatService.isConfigured, isFalse);
    });

    test('logIn/logOut 반복 호출해도 안전', () async {
      for (var i = 0; i < 5; i++) {
        await RevenueCatService.logIn('user-$i');
        await RevenueCatService.logOut();
      }
      expect(RevenueCatService.isConfigured, isFalse);
    });
  });

  // =========================================================
  // 9. logIn/logOut 소스 코드 구조 검증
  // =========================================================
  group('logIn/logOut 소스 코드 검증', () {
    late String rcSource;

    setUpAll(() {
      final file = File(
        'lib/services/subscription/revenue_cat_service.dart',
      );
      rcSource = file.readAsStringSync();
    });

    test('logIn 메서드가 존재함', () {
      expect(
        rcSource.contains('static Future<void> logIn(String userId)'),
        isTrue,
        reason: 'logIn 메서드 필요',
      );
    });

    test('logOut 메서드가 존재함', () {
      expect(
        rcSource.contains('static Future<void> logOut()'),
        isTrue,
        reason: 'logOut 메서드 필요',
      );
    });

    test('logIn이 Purchases.logIn을 호출함', () {
      final startIdx = rcSource.indexOf(
        'static Future<void> logIn(String userId)',
      );
      final endIdx = rcSource.indexOf(
        '/// RevenueCat 로그아웃',
      );
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('Purchases.logIn(userId)'),
        isTrue,
        reason: 'RevenueCat SDK logIn 호출 필요',
      );
    });

    test('logOut이 Purchases.logOut을 호출함', () {
      final startIdx = rcSource.indexOf(
        'static Future<void> logOut()',
      );
      final endIdx = rcSource.indexOf(
        '/// 앱 시작 시 구독 상태를 자동으로',
      );
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('Purchases.logOut()'),
        isTrue,
        reason: 'RevenueCat SDK logOut 호출 필요',
      );
    });

    test('logIn이 _isConfigured 가드를 포함함', () {
      final startIdx = rcSource.indexOf(
        'static Future<void> logIn(String userId)',
      );
      final endIdx = rcSource.indexOf(
        '/// RevenueCat 로그아웃',
      );
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('if (!_isConfigured) return'),
        isTrue,
        reason: 'unconfigured 시 즉시 반환 가드 필요',
      );
    });

    test('logOut이 _isConfigured 가드를 포함함', () {
      final startIdx = rcSource.indexOf(
        'static Future<void> logOut()',
      );
      final endIdx = rcSource.indexOf(
        '/// 앱 시작 시 구독 상태를 자동으로',
      );
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('if (!_isConfigured) return'),
        isTrue,
        reason: 'unconfigured 시 즉시 반환 가드 필요',
      );
    });

    test('logIn 후 Firestore 동기화가 호출됨', () {
      final startIdx = rcSource.indexOf(
        'static Future<void> logIn(String userId)',
      );
      final endIdx = rcSource.indexOf(
        '/// RevenueCat 로그아웃',
      );
      final methodBody = rcSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('_syncSubscriptionToFirestore'),
        isTrue,
        reason: 'logIn 후 구독 상태 Firestore 동기화 필요',
      );
    });

    test('logIn/logOut이 try-catch로 보호됨', () {
      final logInStart = rcSource.indexOf(
        'static Future<void> logIn(String userId)',
      );
      final logOutEnd = rcSource.indexOf(
        '/// 앱 시작 시 구독 상태를 자동으로',
      );
      final methodBodies = rcSource.substring(logInStart, logOutEnd);

      // logIn과 logOut 모두 try-catch로 보호
      final tryCount = 'try {'.allMatches(methodBodies).length;
      final catchCount = 'catch (e)'.allMatches(methodBodies).length;

      expect(tryCount, greaterThanOrEqualTo(2),
          reason: 'logIn과 logOut 모두 try-catch 필요');
      expect(catchCount, greaterThanOrEqualTo(2),
          reason: 'logIn과 logOut 모두 catch 필요');
    });
  });

  // =========================================================
  // 10. auth_service.dart RevenueCat 연동 소스 코드 검증
  // =========================================================
  group('auth_service.dart RevenueCat 연동 검증', () {
    late String authSource;

    setUpAll(() {
      final file = File('lib/services/auth/auth_service.dart');
      authSource = file.readAsStringSync();
    });

    test('revenue_cat_service.dart import가 존재함', () {
      expect(
        authSource.contains(
          "import '../subscription/revenue_cat_service.dart'",
        ),
        isTrue,
        reason: 'RevenueCatService import 필요',
      );
    });

    test('signInWithGoogle에서 RevenueCatService.logIn 호출', () {
      final startIdx = authSource.indexOf('signInWithGoogle()');
      final endIdx = authSource.indexOf('// Apple 로그인');
      final methodBody = authSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('RevenueCatService.logIn(result.user!.uid)'),
        isTrue,
        reason: 'Google 로그인 성공 후 RevenueCat logIn 호출 필요',
      );
    });

    test('signInWithApple에서 RevenueCatService.logIn 호출', () {
      final startIdx = authSource.indexOf('signInWithApple()');
      final endIdx = authSource.indexOf('// 로그아웃');
      final methodBody = authSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('RevenueCatService.logIn(result.user!.uid)'),
        isTrue,
        reason: 'Apple 로그인 성공 후 RevenueCat logIn 호출 필요',
      );
    });

    test('signOut에서 RevenueCatService.logOut 호출', () {
      final startIdx = authSource.indexOf('signOut()');
      final endIdx = authSource.indexOf('// 유틸리티');
      final methodBody = authSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('RevenueCatService.logOut()'),
        isTrue,
        reason: 'signOut 시 RevenueCat logOut 호출 필요',
      );
    });

    test('signOut에서 RevenueCat logOut이 Firebase signOut보다 먼저 호출됨',
        () {
      final startIdx = authSource.indexOf('signOut()');
      final endIdx = authSource.indexOf('// 유틸리티');
      final methodBody = authSource.substring(startIdx, endIdx);

      final rcLogOutIdx = methodBody.indexOf('RevenueCatService.logOut()');
      final firebaseLogOutIdx = methodBody.indexOf('_auth.signOut()');

      expect(
        rcLogOutIdx,
        lessThan(firebaseLogOutIdx),
        reason: 'RevenueCat logOut이 Firebase signOut보다 먼저 '
            '호출되어야 함 (UID가 아직 유효한 동안)',
      );
    });

    test('signInWithGoogle에서 result.user null 체크 후 logIn 호출', () {
      final startIdx = authSource.indexOf('signInWithGoogle()');
      final endIdx = authSource.indexOf('// Apple 로그인');
      final methodBody = authSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('if (result.user != null)'),
        isTrue,
        reason: 'user가 null이 아닌 경우에만 logIn 호출',
      );
    });
  });

  // =========================================================
  // 11. customerInfoStream 안전성
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

  // =========================================================
  // 12. 보안 수정 검증 — Phase 15 Security Hardening
  // =========================================================
  group('보안: auth_service.dart TOCTOU 레이스 방지', () {
    late String authSource;

    setUpAll(() {
      final file = File('lib/services/auth/auth_service.dart');
      authSource = file.readAsStringSync();
    });

    test('signInWithGoogle에서 currentUser를 로컬 변수로 캡처', () {
      final startIdx = authSource.indexOf('signInWithGoogle()');
      final endIdx = authSource.indexOf('// Apple 로그인');
      final methodBody = authSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('final currentUser = _auth.currentUser'),
        isTrue,
        reason: 'currentUser를 로컬 변수로 캡처하여 TOCTOU 방지',
      );

      // _auth.currentUser! 직접 사용 금지 확인
      expect(
        methodBody.contains('_auth.currentUser!.linkWithCredential'),
        isFalse,
        reason: 'currentUser를 직접 사용하지 않고 로컬 변수 사용',
      );
    });

    test('signInWithApple에서 currentUser를 로컬 변수로 캡처', () {
      final startIdx = authSource.indexOf('signInWithApple()');
      final endIdx = authSource.indexOf('// 로그아웃');
      final methodBody = authSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('final currentUser = _auth.currentUser'),
        isTrue,
        reason: 'currentUser를 로컬 변수로 캡처하여 TOCTOU 방지',
      );

      expect(
        methodBody.contains('_auth.currentUser!.linkWithCredential'),
        isFalse,
        reason: 'currentUser를 직접 사용하지 않고 로컬 변수 사용',
      );
    });
  });

  group('보안: signOut 부분 실패 방지', () {
    late String authSource;

    setUpAll(() {
      final file = File('lib/services/auth/auth_service.dart');
      authSource = file.readAsStringSync();
    });

    test('signOut이 각 단계를 개별 try-catch로 보호', () {
      final startIdx = authSource.indexOf('signOut()');
      final endIdx = authSource.indexOf('// 유틸리티');
      final methodBody = authSource.substring(startIdx, endIdx);

      // RevenueCat logOut이 독립적 try-catch로 보호됨
      expect(
        methodBody.contains("await RevenueCatService.logOut();\n"
            "    } catch (e) {\n"
            "      debugPrint('[Auth] RevenueCat logOut failed:"),
        isTrue,
        reason: 'RevenueCat logOut 실패가 Firebase signOut을 막지 않아야 함',
      );

      // firstError 패턴으로 에러 수집
      expect(
        methodBody.contains('firstError'),
        isTrue,
        reason: '부분 실패 시 첫 에러를 보존하여 전파',
      );
    });

    test('signOut에서 Firebase signOut이 RevenueCat 이후에 실행', () {
      final startIdx = authSource.indexOf('signOut()');
      final endIdx = authSource.indexOf('// 유틸리티');
      final methodBody = authSource.substring(startIdx, endIdx);

      final rcIdx = methodBody.indexOf('RevenueCatService.logOut()');
      final fbIdx = methodBody.indexOf('_auth.signOut()');

      expect(rcIdx, lessThan(fbIdx));
    });
  });

  group('보안: RevenueCat 디바운스 동기화', () {
    late String rcSource;

    setUpAll(() {
      final file = File(
        'lib/services/subscription/revenue_cat_service.dart',
      );
      rcSource = file.readAsStringSync();
    });

    test('_syncDebounce Timer 필드가 존재함', () {
      expect(
        rcSource.contains('static Timer? _syncDebounce'),
        isTrue,
        reason: '디바운스를 위한 Timer 필드 필요',
      );
    });

    test('_debouncedSync 메서드가 존재함', () {
      expect(
        rcSource.contains('static void _debouncedSync('),
        isTrue,
        reason: 'customerInfoUpdateListener의 디바운스 래퍼 필요',
      );
    });

    test('customerInfoUpdateListener에 디바운스 적용됨', () {
      expect(
        rcSource.contains(
          'addCustomerInfoUpdateListener(\n'
          '        _debouncedSync,',
        ),
        isTrue,
        reason: '직접 _syncSubscriptionToFirestore 대신 '
            '_debouncedSync 사용',
      );
    });
  });

  group('보안: 로그아웃 시 inactive 동기화', () {
    late String rcSource;

    setUpAll(() {
      final file = File(
        'lib/services/subscription/revenue_cat_service.dart',
      );
      rcSource = file.readAsStringSync();
    });

    test('logOut에서 _syncInactiveToFirestore 호출', () {
      final startIdx = rcSource.indexOf('static Future<void> logOut()');
      final endIdx = rcSource.indexOf('_syncInactiveToFirestore()');
      // _syncInactiveToFirestore가 logOut 메서드 안에 있는지 확인
      expect(endIdx, greaterThan(startIdx));
    });

    test('_syncInactiveToFirestore가 inactive 상태를 전송', () {
      expect(
        rcSource.contains("'status': 'inactive'"),
        isTrue,
        reason: 'inactive 상태 동기화 필요',
      );
    });
  });

  group('보안: syncSubscription Cloud Function 입력 검증', () {
    late String cfSource;

    setUpAll(() {
      final file = File('functions/src/syncSubscription.ts');
      cfSource = file.readAsStringSync();
    });

    test('expiresAt 미래 날짜 제한 (13개월)', () {
      expect(
        cfSource.contains('maxExpiry.setMonth(maxExpiry.getMonth() + 13)'),
        isTrue,
        reason: '13개월 초과 만료일 거부 필요',
      );
    });

    test('만료된 날짜로 active 설정 거부', () {
      expect(
        cfSource.contains('Cannot set active with expired date'),
        isTrue,
        reason: '과거 만료일 + active 조합 거부',
      );
    });

    test('productId 화이트리스트 검증', () {
      expect(
        cfSource.contains('allowedProducts'),
        isTrue,
        reason: '허용된 productId만 수락',
      );

      expect(
        cfSource.contains('walkdog_premium_monthly'),
        isTrue,
        reason: '월간 구독 상품 ID가 화이트리스트에 포함',
      );
    });

    test('App Check 검증', () {
      expect(
        cfSource.contains('if (!context.app)'),
        isTrue,
        reason: 'App Check 필수',
      );
    });

    test('인증 검증', () {
      expect(
        cfSource.contains('if (!context.auth)'),
        isTrue,
        reason: '인증 필수',
      );
    });
  });

  group('보안: Firestore Rules 필드 보호', () {
    late String rulesSource;

    setUpAll(() {
      final file = File('firestore.rules');
      rulesSource = file.readAsStringSync();
    });

    test('subscription 필드 클라이언트 쓰기 차단 (create)', () {
      expect(
        rulesSource.contains(
          "!request.resource.data.keys().hasAny(['subscription'])",
        ),
        isTrue,
        reason: '신규 문서에 subscription 필드 차단',
      );
    });

    test('subscription 필드 클라이언트 쓰기 차단 (update)', () {
      expect(
        rulesSource.contains("affectedKeys().hasAny(['subscription'])"),
        isTrue,
        reason: '기존 문서에서 subscription 필드 변경 차단',
      );
    });

    test('isOwner 헬퍼 함수 사용', () {
      expect(
        rulesSource.contains('function isOwner()'),
        isTrue,
        reason: '인증 + 소유자 확인 헬퍼',
      );
    });

    test('monitoring 컬렉션 클라이언트 접근 차단', () {
      expect(
        rulesSource.contains("match /monitoring/{document=**}"),
        isTrue,
      );
    });
  });

  group('보안: settings_screen.dart 로그아웃 에러 핸들링', () {
    late String settingsSource;

    setUpAll(() {
      final file = File(
        'lib/presentation/screens/settings/settings_screen.dart',
      );
      settingsSource = file.readAsStringSync();
    });

    test('_confirmSignOut에 try-catch가 있음', () {
      // _confirmSignOut 메서드를 포함한 _AccountSection 범위
      final startIdx = settingsSource.indexOf('void _confirmSignOut');
      final endIdx = settingsSource.indexOf(
        'class _SubscriptionSection',
      );
      expect(startIdx, greaterThan(-1), reason: '_confirmSignOut 메서드 존재');
      expect(endIdx, greaterThan(startIdx));
      final methodBody = settingsSource.substring(startIdx, endIdx);

      expect(
        methodBody.contains('try {'),
        isTrue,
        reason: 'signOut 호출에 에러 핸들링 필요',
      );

      expect(
        methodBody.contains('} catch (e) {'),
        isTrue,
        reason: 'signOut 실패 시 사용자에게 피드백 필요',
      );
    });
  });
}
