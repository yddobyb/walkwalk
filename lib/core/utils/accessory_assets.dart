// lib/core/utils/accessory_assets.dart
import '../../domain/entities/pet.dart';
import '../../l10n/app_localizations.dart';

/// 액세서리 표시용 이모지/이름 매핑 (Phase 29-1).
///
/// 예전엔 `customize_screen`의 private 메서드였는데, 홈 아바타에도 액세서리를
/// 보여주게 되면서 두 화면이 같은 표를 봐야 해서 여기로 옮겼다.
/// 새 액세서리를 추가할 땐 **[PetAccessory] enum 맨 뒤에만** 추가할 것
/// — Isar가 enum을 인덱스로 저장해서, 중간에 끼워넣으면 기존 펫이 쓰던
/// 액세서리가 다른 것으로 바뀐다.
class AccessoryAssets {
  AccessoryAssets._();

  /// 액세서리 이모지. [PetAccessory.none]은 "없음"을 고르는 UI 칩에서만
  /// 쓰이고, 실제 표시(뱃지)에서는 호출되지 않는다.
  static String emojiFor(PetAccessory accessory) {
    switch (accessory) {
      case PetAccessory.none:
        return '🚫';
      case PetAccessory.bandana:
        return '🔴';
      case PetAccessory.glasses:
        return '🕶️';
      case PetAccessory.bowtie:
        return '🎀';
      case PetAccessory.hat:
        return '🎩';
      case PetAccessory.collar:
        return '⭕';
    }
  }

  /// 현재 로케일의 액세서리 이름
  static String nameFor(PetAccessory accessory, AppLocalizations l10n) {
    switch (accessory) {
      case PetAccessory.none:
        return l10n.accessoryNone;
      case PetAccessory.bandana:
        return l10n.accessoryBandana;
      case PetAccessory.glasses:
        return l10n.accessoryGlasses;
      case PetAccessory.bowtie:
        return l10n.accessoryBowtie;
      case PetAccessory.hat:
        return l10n.accessoryHat;
      case PetAccessory.collar:
        return l10n.accessoryCollar;
    }
  }
}
