// lib/core/services/firebase_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Firebase 초기화 서비스
///
/// Week 3: Firebase Core, Remote Config, Analytics 초기화
///
/// Usage:
/// ```dart
/// await FirebaseService.initialize();
/// ```
class FirebaseService {
  static bool _isInitialized = false;

  /// Firebase 초기화
  ///
  /// 앱 시작 시 main() 함수에서 호출
  ///
  /// Returns: true if 성공, false if 실패
  static Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ Firebase - Already initialized');
      return true;
    }

    try {
      // Firebase Core 초기화
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _isInitialized = true;
      debugPrint('✅ Firebase - Initialized successfully');
      debugPrint('   - Project: ${Firebase.app().options.projectId}');
      debugPrint('   - Platform: ${defaultTargetPlatform.name}');

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Firebase - Initialization failed: $e');
      debugPrint('   Stack trace: $stackTrace');
      _isInitialized = false;
      return false;
    }
  }

  /// Firebase 초기화 상태 확인
  static bool get isInitialized => _isInitialized;

  /// Firebase 앱 인스턴스 가져오기
  static FirebaseApp get app {
    if (!_isInitialized) {
      throw StateError('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return Firebase.app();
  }

  /// 프로젝트 ID 가져오기
  static String get projectId {
    if (!_isInitialized) {
      throw StateError('Firebase not initialized');
    }
    return Firebase.app().options.projectId;
  }

  /// Storage Bucket 가져오기
  static String get storageBucket {
    if (!_isInitialized) {
      throw StateError('Firebase not initialized');
    }
    return Firebase.app().options.storageBucket ?? '';
  }
}
