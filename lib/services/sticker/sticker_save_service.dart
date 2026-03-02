// lib/services/sticker/sticker_save_service.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/datasources/database_service.dart';
import '../../domain/entities/pet.dart';
import '../pet/pet_reward_service.dart';
import '../tracking/step_tracking_service.dart';

/// 스티커 저장 서비스
///
/// Week 4: 생성된 스티커를 영구 저장하고 Pet 엔티티를 업데이트
///
/// Usage:
/// ```dart
/// final service = ref.read(stickerSaveServiceProvider);
/// final savedPath = await service.saveStickerToPet(
///   petId: pet.petId,
///   imageBytes: stickerBytes,
/// );
/// ```
class StickerSaveService {
  static const String _stickerDir = 'pet_stickers';

  Directory? _stickerDirectory;
  final DatabaseService _databaseService = DatabaseService();

  /// 초기화
  Future<void> initialize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _stickerDirectory = Directory('${appDir.path}/$_stickerDir');

      if (!await _stickerDirectory!.exists()) {
        await _stickerDirectory!.create(recursive: true);
        debugPrint('✅ Sticker directory created: ${_stickerDirectory!.path}');
      }

      debugPrint('✅ StickerSaveService initialized');
    } catch (e, stackTrace) {
      debugPrint('❌ StickerSaveService initialization failed: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// 스티커를 Pet에 저장
  ///
  /// [petId] Pet의 고유 ID
  /// [imageBytes] 이미지 바이트 (WebP)
  ///
  /// Returns: 저장된 파일 경로
  Future<String?> saveStickerToPet({
    required String petId,
    required Uint8List imageBytes,
  }) async {
    if (_stickerDirectory == null) {
      await initialize();
    }

    if (_stickerDirectory == null) {
      debugPrint('❌ StickerSaveService not initialized');
      return null;
    }

    try {
      // 1. 기존 스티커 삭제 (있으면)
      await _deleteExistingSticker(petId);

      // 2. 새 스티커 파일 저장
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'sticker_${petId}_$timestamp.webp';
      final filePath = '${_stickerDirectory!.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      debugPrint('✅ Sticker saved: $filePath');
      debugPrint('   - Size: ${(imageBytes.length / 1024).toStringAsFixed(2)} KB');

      return filePath;
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to save sticker: $e');
      debugPrint('   Stack trace: $stackTrace');
      return null;
    }
  }

  /// Pet 엔티티 업데이트 (스티커 경로 저장)
  ///
  /// [pet] 업데이트할 Pet
  /// [stickerPath] 저장된 스티커 파일 경로
  Future<Pet?> updatePetWithSticker({
    required Pet pet,
    required String stickerPath,
  }) async {
    try {
      // Pet 엔티티 업데이트
      final updatedPet = pet.copyWith(
        stickerPath: stickerPath,
        stickerGeneratedAt: DateTime.now(),
      );

      // 데이터베이스에 저장
      await _databaseService.savePet(updatedPet);

      debugPrint('✅ Pet updated with sticker: ${pet.petId}');
      debugPrint('   - Sticker path: $stickerPath');

      return updatedPet;
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to update pet with sticker: $e');
      debugPrint('   Stack trace: $stackTrace');
      return null;
    }
  }

  /// 저장된 스티커 파일 가져오기
  ///
  /// [stickerPath] 스티커 파일 경로
  ///
  /// Returns: 파일이 존재하면 File, 없으면 null
  Future<File?> getStickerFile(String? stickerPath) async {
    if (stickerPath == null || stickerPath.isEmpty) {
      return null;
    }

    try {
      final file = File(stickerPath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get sticker file: $e');
      return null;
    }
  }

  /// Pet의 기존 스티커 삭제
  Future<void> _deleteExistingSticker(String petId) async {
    if (_stickerDirectory == null) return;

    try {
      final files = await _stickerDirectory!.list().toList();
      for (final file in files) {
        if (file is File && file.path.contains('sticker_$petId')) {
          await file.delete();
          debugPrint('🗑️ Deleted old sticker: ${file.path}');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to delete existing sticker: $e');
    }
  }

  /// 스티커 저장 + Pet 업데이트를 한번에 수행
  ///
  /// [pet] 업데이트할 Pet
  /// [imageBytes] 이미지 바이트
  ///
  /// Returns: 업데이트된 Pet (실패 시 null)
  Future<Pet?> saveAndApplySticker({
    required Pet pet,
    required Uint8List imageBytes,
  }) async {
    // 1. 스티커 파일 저장
    final stickerPath = await saveStickerToPet(
      petId: pet.petId,
      imageBytes: imageBytes,
    );

    if (stickerPath == null) {
      debugPrint('❌ Failed to save sticker file');
      return null;
    }

    // 2. Pet 엔티티 업데이트
    final updatedPet = await updatePetWithSticker(
      pet: pet,
      stickerPath: stickerPath,
    );

    return updatedPet;
  }
}

/// StickerSaveService Provider
final stickerSaveServiceProvider = Provider<StickerSaveService>((ref) {
  final service = StickerSaveService();
  service.initialize();
  return service;
});

/// 스티커 적용 상태
enum StickerApplyState {
  idle,
  applying,
  success,
  error,
}

/// 스티커 적용 Notifier
class StickerApplyNotifier extends StateNotifier<AsyncValue<StickerApplyState>> {
  final Ref ref;

  StickerApplyNotifier(this.ref) : super(const AsyncValue.data(StickerApplyState.idle));

  /// 스티커 적용
  Future<bool> applySticker(Uint8List imageBytes) async {
    state = const AsyncValue.loading();

    try {
      // 현재 활성 Pet 가져오기
      final petAsync = ref.read(activePetProvider);
      final pet = petAsync.valueOrNull;

      if (pet == null) {
        debugPrint('❌ No active pet found');
        state = const AsyncValue.data(StickerApplyState.error);
        return false;
      }

      // 스티커 저장 서비스
      final service = ref.read(stickerSaveServiceProvider);

      // 스티커 저장 및 Pet 업데이트
      final updatedPet = await service.saveAndApplySticker(
        pet: pet,
        imageBytes: imageBytes,
      );

      if (updatedPet == null) {
        state = const AsyncValue.data(StickerApplyState.error);
        return false;
      }

      // activePetProvider 갱신을 위해 invalidate
      ref.invalidate(activePetProvider);

      // StepTrackingService의 _currentPet도 갱신 (중요!)
      // 이렇게 하지 않으면 StepTrackingService가 스티커 없는 버전으로 덮어씀
      await StepTrackingService().reloadCurrentPet();

      state = const AsyncValue.data(StickerApplyState.success);
      debugPrint('✅ Sticker applied successfully');
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to apply sticker: $e');
      debugPrint('   Stack trace: $stackTrace');
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 상태 초기화
  void reset() {
    state = const AsyncValue.data(StickerApplyState.idle);
  }
}

/// 스티커 적용 Provider
final stickerApplyProvider =
    StateNotifierProvider<StickerApplyNotifier, AsyncValue<StickerApplyState>>(
  (ref) => StickerApplyNotifier(ref),
);
