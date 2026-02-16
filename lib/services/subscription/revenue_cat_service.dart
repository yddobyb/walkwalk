// lib/services/subscription/revenue_cat_service.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 구매 결과
class PurchaseResult {
  final bool success;
  final bool alreadySubscribed;
  final bool isCancelled;
  final String? errorMessage;

  const PurchaseResult({
    this.success = false,
    this.alreadySubscribed = false,
    this.isCancelled = false,
    this.errorMessage,
  });
}

/// RevenueCat SDK 래퍼
///
/// API 키가 플레이스홀더이면 모든 메서드가 안전한 기본값을 반환.
/// 구매 성공 시 Firestore에 구독 상태를 기록하여
/// 서버(Cloud Functions)가 읽을 수 있도록 한다.
class RevenueCatService {
  RevenueCatService._();

  // TODO: 스토어 계정 생성 후 실제 API 키로 교체
  static const _apiKeyIos = 'PLACEHOLDER_IOS_API_KEY';
  static const _apiKeyAndroid = 'PLACEHOLDER_ANDROID_API_KEY';

  static const _entitlementId = 'premium';
  static const _monthlyProductId = 'walkdog_premium_monthly';

  static bool _isConfigured = false;
  static bool _initialized = false;

  /// SDK가 정상 설정되었는지 여부
  static bool get isConfigured => _isConfigured;

  /// SDK 초기화
  ///
  /// 플레이스홀더 키면 초기화를 건너뛴다.
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final apiKey = defaultTargetPlatform == TargetPlatform.iOS
        ? _apiKeyIos
        : _apiKeyAndroid;

    if (apiKey.contains('PLACEHOLDER')) {
      debugPrint(
        '[RevenueCat] API key is placeholder - '
        'running in unconfigured mode',
      );
      _isConfigured = false;
      return;
    }

    try {
      await Purchases.setLogLevel(LogLevel.debug);

      // appUserID를 설정하지 않음 → RevenueCat이 $RCAnonymousID 자동 생성
      // → App Store/Google Play 계정에 자동 매핑
      // → 앱 재설치 시에도 같은 스토어 계정이면 구독 복원 가능
      final config = PurchasesConfiguration(apiKey);

      await Purchases.configure(config);
      _isConfigured = true;

      debugPrint('[RevenueCat] Configured successfully');

      // 구독 변경 시 Firestore 동기화
      Purchases.addCustomerInfoUpdateListener(
        _syncSubscriptionToFirestore,
      );

      // 앱 시작 시 구독 상태 자동 확인 및 Firestore 동기화
      await _autoRestoreOnStartup();
    } catch (e) {
      debugPrint('[RevenueCat] Configuration failed: $e');
      _isConfigured = false;
    }
  }

  /// 프리미엄 엔타이틀먼트 보유 여부
  static Future<bool> hasPremiumEntitlement() async {
    if (!_isConfigured) return false;

    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      debugPrint('[RevenueCat] Error checking entitlement: $e');
      return false;
    }
  }

  /// 월간 구독 상품 조회
  static Future<StoreProduct?> getMonthlyProduct() async {
    if (!_isConfigured) return null;

    try {
      final products = await Purchases.getProducts(
        [_monthlyProductId],
      );
      if (products.isNotEmpty) return products.first;
    } catch (e) {
      debugPrint('[RevenueCat] Error fetching product: $e');
    }
    return null;
  }

  /// 구독 구매
  static Future<PurchaseResult> purchase(
    StoreProduct product,
  ) async {
    if (!_isConfigured) {
      return const PurchaseResult(
        errorMessage: 'Store not configured',
      );
    }

    try {
      final info = await Purchases.purchaseStoreProduct(product);
      final active = info.entitlements.active.containsKey(
        _entitlementId,
      );

      if (active) {
        await _syncSubscriptionToFirestore(info);
        return const PurchaseResult(success: true);
      }

      return const PurchaseResult(
        errorMessage: 'Purchase completed but entitlement not found',
      );
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        return const PurchaseResult(isCancelled: true);
      }
      return PurchaseResult(errorMessage: e.toString());
    } catch (e) {
      if (e.toString().contains('userCancelled') ||
          e.toString().contains('purchaseCancelled')) {
        return const PurchaseResult(isCancelled: true);
      }
      return PurchaseResult(errorMessage: e.toString());
    }
  }

  /// 구매 복원
  static Future<PurchaseResult> restorePurchases() async {
    if (!_isConfigured) {
      return const PurchaseResult(
        errorMessage: 'Store not configured',
      );
    }

    try {
      final info = await Purchases.restorePurchases();
      final active = info.entitlements.active.containsKey(
        _entitlementId,
      );

      if (active) {
        await _syncSubscriptionToFirestore(info);
        return const PurchaseResult(success: true);
      }

      return const PurchaseResult(
        alreadySubscribed: false,
        errorMessage: 'No active subscription found',
      );
    } catch (e) {
      return PurchaseResult(errorMessage: e.toString());
    }
  }

  /// CustomerInfo 스트림 (구독 상태 변경 감지)
  static Stream<CustomerInfo> get customerInfoStream {
    if (!_isConfigured) return const Stream.empty();

    final controller = StreamController<CustomerInfo>.broadcast();

    void listener(CustomerInfo info) {
      controller.add(info);
    }

    Purchases.addCustomerInfoUpdateListener(listener);

    controller.onCancel = () {
      Purchases.removeCustomerInfoUpdateListener(listener);
    };

    return controller.stream;
  }

  /// 앱 시작 시 구독 상태를 자동으로 확인하고 Firestore에 동기화
  ///
  /// [Purchases.getCustomerInfo()]를 사용하여 캐시/서버에서 구독 상태를 읽음.
  /// [Purchases.restorePurchases()]는 Apple 리젝 위험이 있어 사용하지 않음.
  /// 실패해도 앱 실행에 영향 없음 (non-fatal).
  static Future<void> _autoRestoreOnStartup() async {
    try {
      final info = await Purchases.getCustomerInfo();
      final isActive = info.entitlements.active.containsKey(
        _entitlementId,
      );
      debugPrint(
        '[RevenueCat] Auto-restore check: '
        '${isActive ? "premium active" : "no active subscription"}',
      );
      if (isActive) {
        await _syncSubscriptionToFirestore(info);
      }
    } catch (e) {
      debugPrint(
        '[RevenueCat] Auto-restore failed (non-fatal): $e',
      );
    }
  }

  /// Firestore에 구독 상태 동기화
  ///
  /// Cloud Functions(quota.ts)가 이 데이터를 읽어 tier 판별.
  static Future<void> _syncSubscriptionToFirestore(
    CustomerInfo info,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final entitlement = info.entitlements.active[_entitlementId];
      final isActive = entitlement != null;

      final data = <String, dynamic>{
        'subscription': {
          'status': isActive ? 'active' : 'inactive',
          'expiresAt': entitlement?.expirationDate,
          'updatedAt': FieldValue.serverTimestamp(),
          'productId': entitlement?.productIdentifier ?? '',
        },
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(data, SetOptions(merge: true));

      debugPrint(
        '[RevenueCat] Synced subscription to Firestore: '
        '${isActive ? "active" : "inactive"}',
      );
    } catch (e) {
      debugPrint('[RevenueCat] Firestore sync error: $e');
    }
  }
}
