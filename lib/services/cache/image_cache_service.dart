// lib/services/cache/image_cache_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/sticker_request.dart';

/// 로컬 이미지 캐시 서비스
///
/// Week 4: 이미지 캐싱 시스템
/// - 30일 만료 정책
/// - 최대 100MB 용량 제한
/// - SHA-256 기반 캐시 키
///
/// Usage:
/// ```dart
/// final service = ImageCacheService();
/// await service.initialize();
///
/// // 캐시 확인
/// final cached = await service.getCachedImage(request);
/// if (cached != null) {
///   return cached; // 캐시 히트
/// }
///
/// // 캐시 저장
/// await service.cacheImage(request, imageBytes);
/// ```
class ImageCacheService {
  static const String _cacheDir = 'sticker_cache';
  static const String _metadataPrefix = 'sticker_metadata_';
  static const int _maxCacheSizeBytes = 100 * 1024 * 1024; // 100MB
  static const int _maxCacheAgeDays = 30; // 30일

  Directory? _cacheDirectory;
  SharedPreferences? _prefs;

  /// 초기화
  ///
  /// 앱 시작 시 호출 필요
  Future<void> initialize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDirectory = Directory('${appDir.path}/$_cacheDir');

      if (!await _cacheDirectory!.exists()) {
        await _cacheDirectory!.create(recursive: true);
        debugPrint('✅ Image cache directory created: ${_cacheDirectory!.path}');
      }

      _prefs = await SharedPreferences.getInstance();
      debugPrint('✅ ImageCacheService initialized');

      // 초기화 시 만료된 캐시 정리
      await _cleanupExpiredCache();
    } catch (e, stackTrace) {
      debugPrint('❌ ImageCacheService initialization failed: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// 캐시된 이미지 조회
  ///
  /// [request] 스티커 요청
  ///
  /// Returns: 캐시된 이미지 바이트 (없으면 null)
  Future<Uint8List?> getCachedImage(StickerRequest request) async {
    if (_cacheDirectory == null || _prefs == null) {
      debugPrint('⚠️ ImageCacheService not initialized');
      return null;
    }

    try {
      final cacheKey = _generateCacheKey(request);
      final file = File('${_cacheDirectory!.path}/$cacheKey.webp');

      // 파일 존재 확인
      if (!await file.exists()) {
        debugPrint('📦 Cache miss: $cacheKey');
        return null;
      }

      // 메타데이터 확인
      final metadata = _getMetadata(cacheKey);
      if (metadata == null) {
        debugPrint('⚠️ Cache metadata missing: $cacheKey');
        await file.delete();
        return null;
      }

      // 만료 확인
      final cachedAt = DateTime.parse(metadata['cached_at'] as String);
      final age = DateTime.now().difference(cachedAt);
      if (age.inDays > _maxCacheAgeDays) {
        debugPrint('⏰ Cache expired: $cacheKey (${age.inDays} days old)');
        await _removeCacheEntry(cacheKey);
        return null;
      }

      // 캐시 히트
      final bytes = await file.readAsBytes();
      debugPrint('✅ Cache hit: $cacheKey');
      debugPrint('   - Age: ${age.inDays} days');
      debugPrint('   - Size: ${(bytes.length / 1024).toStringAsFixed(2)} KB');

      return bytes;
    } catch (e) {
      debugPrint('❌ Failed to get cached image: $e');
      return null;
    }
  }

  /// 이미지 캐싱
  ///
  /// [request] 스티커 요청
  /// [imageBytes] 이미지 바이트 (WebP)
  /// [seed] 생성 시드 (선택)
  Future<void> cacheImage(
    StickerRequest request,
    Uint8List imageBytes, {
    int? seed,
  }) async {
    if (_cacheDirectory == null || _prefs == null) {
      debugPrint('⚠️ ImageCacheService not initialized');
      return;
    }

    try {
      final cacheKey = _generateCacheKey(request);
      final file = File('${_cacheDirectory!.path}/$cacheKey.webp');

      // 용량 체크 및 정리
      await _ensureCacheSize(imageBytes.length);

      // 파일 저장
      await file.writeAsBytes(imageBytes);

      // 메타데이터 저장
      final metadata = {
        'cached_at': DateTime.now().toIso8601String(),
        'size': imageBytes.length,
        'breed': request.breed,
        'color': request.color,
        'accessory': request.accessory.name,
        'style': request.style.name,
        if (seed != null) 'seed': seed,
      };
      await _saveMetadata(cacheKey, metadata);

      debugPrint('✅ Image cached: $cacheKey');
      debugPrint('   - Size: ${(imageBytes.length / 1024).toStringAsFixed(2)} KB');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to cache image: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// 캐시 통계 조회
  Future<CacheStats> getStats() async {
    if (_cacheDirectory == null || _prefs == null) {
      return CacheStats(
        totalFiles: 0,
        totalSizeBytes: 0,
        oldestCacheAge: Duration.zero,
        newestCacheAge: Duration.zero,
      );
    }

    try {
      final files = await _cacheDirectory!.list().toList();
      final imageFiles = files.whereType<File>().where((f) => f.path.endsWith('.webp')).toList();

      if (imageFiles.isEmpty) {
        return CacheStats(
          totalFiles: 0,
          totalSizeBytes: 0,
          oldestCacheAge: Duration.zero,
          newestCacheAge: Duration.zero,
        );
      }

      int totalSize = 0;
      DateTime? oldest;
      DateTime? newest;

      for (final file in imageFiles) {
        final stat = await file.stat();
        totalSize += stat.size;

        final modified = stat.modified;
        if (oldest == null || modified.isBefore(oldest)) {
          oldest = modified;
        }
        if (newest == null || modified.isAfter(newest)) {
          newest = modified;
        }
      }

      final now = DateTime.now();
      return CacheStats(
        totalFiles: imageFiles.length,
        totalSizeBytes: totalSize,
        oldestCacheAge: oldest != null ? now.difference(oldest) : Duration.zero,
        newestCacheAge: newest != null ? now.difference(newest) : Duration.zero,
      );
    } catch (e) {
      debugPrint('❌ Failed to get cache stats: $e');
      return CacheStats(
        totalFiles: 0,
        totalSizeBytes: 0,
        oldestCacheAge: Duration.zero,
        newestCacheAge: Duration.zero,
      );
    }
  }

  /// 전체 캐시 삭제
  Future<void> clearCache() async {
    if (_cacheDirectory == null || _prefs == null) {
      return;
    }

    try {
      final files = await _cacheDirectory!.list().toList();
      for (final file in files) {
        if (file is File) {
          await file.delete();
        }
      }

      // 메타데이터 삭제
      final keys = _prefs!.getKeys().where((k) => k.startsWith(_metadataPrefix)).toList();
      for (final key in keys) {
        await _prefs!.remove(key);
      }

      debugPrint('✅ Cache cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear cache: $e');
    }
  }

  // ========== Private Methods ==========

  /// 캐시 키 생성 (SHA-256 해시)
  String _generateCacheKey(StickerRequest request) {
    final input = '${request.breed}_${request.color}_${request.accessory.name}_${request.style.name}_${request.bg.name}_${request.size}';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 메타데이터 저장
  Future<void> _saveMetadata(String cacheKey, Map<String, dynamic> metadata) async {
    final key = '$_metadataPrefix$cacheKey';
    await _prefs!.setString(key, jsonEncode(metadata));
  }

  /// 메타데이터 조회
  Map<String, dynamic>? _getMetadata(String cacheKey) {
    final key = '$_metadataPrefix$cacheKey';
    final json = _prefs!.getString(key);
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }

  /// 캐시 엔트리 삭제
  Future<void> _removeCacheEntry(String cacheKey) async {
    try {
      final file = File('${_cacheDirectory!.path}/$cacheKey.webp');
      if (await file.exists()) {
        await file.delete();
      }
      await _prefs!.remove('$_metadataPrefix$cacheKey');
    } catch (e) {
      debugPrint('❌ Failed to remove cache entry: $e');
    }
  }

  /// 만료된 캐시 정리
  Future<void> _cleanupExpiredCache() async {
    try {
      final keys = _prefs!.getKeys().where((k) => k.startsWith(_metadataPrefix));
      int cleaned = 0;

      for (final key in keys) {
        final cacheKey = key.substring(_metadataPrefix.length);
        final metadata = _getMetadata(cacheKey);
        if (metadata == null) continue;

        final cachedAt = DateTime.parse(metadata['cached_at'] as String);
        final age = DateTime.now().difference(cachedAt);

        if (age.inDays > _maxCacheAgeDays) {
          await _removeCacheEntry(cacheKey);
          cleaned++;
        }
      }

      if (cleaned > 0) {
        debugPrint('🧹 Cleaned $cleaned expired cache entries');
      }
    } catch (e) {
      debugPrint('❌ Failed to cleanup expired cache: $e');
    }
  }

  /// 캐시 용량 확보
  Future<void> _ensureCacheSize(int newFileSize) async {
    try {
      final stats = await getStats();
      final newTotalSize = stats.totalSizeBytes + newFileSize;

      if (newTotalSize <= _maxCacheSizeBytes) {
        return; // 용량 충분
      }

      // 오래된 파일부터 삭제
      final files = await _cacheDirectory!.list().toList();
      final imageFiles = files.whereType<File>().where((f) => f.path.endsWith('.webp')).toList();

      // 수정 시간 기준 정렬
      imageFiles.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return aStat.modified.compareTo(bStat.modified);
      });

      int freedSize = 0;
      int deleted = 0;

      for (final file in imageFiles) {
        final stat = await file.stat();
        final cacheKey = file.path.split('/').last.replaceAll('.webp', '');

        await _removeCacheEntry(cacheKey);
        freedSize += stat.size;
        deleted++;

        if (stats.totalSizeBytes - freedSize + newFileSize <= _maxCacheSizeBytes) {
          break;
        }
      }

      if (deleted > 0) {
        debugPrint('🧹 Freed ${(freedSize / 1024 / 1024).toStringAsFixed(2)} MB by deleting $deleted old cache files');
      }
    } catch (e) {
      debugPrint('❌ Failed to ensure cache size: $e');
    }
  }
}

/// 캐시 통계
class CacheStats {
  final int totalFiles;
  final int totalSizeBytes;
  final Duration oldestCacheAge;
  final Duration newestCacheAge;

  const CacheStats({
    required this.totalFiles,
    required this.totalSizeBytes,
    required this.oldestCacheAge,
    required this.newestCacheAge,
  });

  /// 전체 용량 (MB)
  double get totalSizeMB => totalSizeBytes / 1024 / 1024;

  /// 평균 파일 크기 (KB)
  double get averageFileSizeKB => totalFiles > 0 ? (totalSizeBytes / totalFiles) / 1024 : 0;

  @override
  String toString() {
    return 'CacheStats(files: $totalFiles, size: ${totalSizeMB.toStringAsFixed(2)} MB, '
        'oldest: ${oldestCacheAge.inDays}d, newest: ${newestCacheAge.inDays}d)';
  }
}
