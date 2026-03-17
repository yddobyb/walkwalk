// lib/services/storage/secure_storage_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage 서비스
///
/// iOS Keychain / Android EncryptedSharedPreferences를 활용하여
/// 민감한 데이터를 안전하게 저장/조회/삭제한다.
///
/// Usage:
/// ```dart
/// await SecureStorageService.initialize();
/// await SecureStorageService.write('api_key', 'sk-or-...');
/// final key = await SecureStorageService.read('api_key');
/// ```
class SecureStorageService {
  static FlutterSecureStorage? _storage;
  static bool _isInitialized = false;

  // 키 상수
  static const String keyIsarEncryption = 'isar_encryption_key';

  /// 초기화
  static Future<void> initialize() async {
    if (_isInitialized) return;

    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );

    _isInitialized = true;
    debugPrint('[SecureStorage] Initialized');
  }

  /// 값 저장
  static Future<void> write(String key, String value) async {
    _ensureInitialized();
    await _storage!.write(key: key, value: value);
  }

  /// 값 읽기 (없으면 null)
  static Future<String?> read(String key) async {
    _ensureInitialized();
    return await _storage!.read(key: key);
  }

  /// 값 삭제
  static Future<void> delete(String key) async {
    _ensureInitialized();
    await _storage!.delete(key: key);
  }

  /// 키 존재 여부 확인
  static Future<bool> containsKey(String key) async {
    _ensureInitialized();
    return await _storage!.containsKey(key: key);
  }

  /// 모든 값 삭제
  static Future<void> deleteAll() async {
    _ensureInitialized();
    await _storage!.deleteAll();
  }

  /// 초기화 상태 확인
  static bool get isInitialized => _isInitialized;

  static void _ensureInitialized() {
    if (!_isInitialized || _storage == null) {
      throw StateError(
        'SecureStorageService not initialized. '
        'Call SecureStorageService.initialize() first.',
      );
    }
  }
}
