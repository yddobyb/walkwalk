// lib/core/constants/cosmetic_tiers.dart
import '../../data/models/sticker_request.dart';
import '../../domain/entities/pet.dart';

/// 무료/프리미엄 장식 구분 (Phase 29-3).
///
/// **품종·색상은 잠그지 않는다.** 그건 "내 개가 무엇인가"라서, 막으면 열망이
/// 아니라 벌로 읽힌다. 온보딩에서 고른 값이고 홈 아바타에 계속 뜬다.
/// 잠그는 건 장식(액세서리/스타일/배경)뿐.
///
/// 무료 집합 = **Phase 29-2 확대 이전에 있던 것 그대로.** 늘어난 것만
/// 프리미엄이라 아무도 쓰던 걸 잃지 않는다.
///
/// ⚠️ 서버 `functions/src/utils/stickerPrompt.ts`의 `FREE_*`와 **반드시 일치**해야
/// 한다. 어긋나면 이용자에겐 열려 보이는데 서버가 조용히 기본값으로 바꿔버려,
/// "골랐는데 결과가 안 바뀌는" 상태가 된다.
/// `test/data/sticker_option_allowlist_test.dart`가 드리프트를 잡는다.
class CosmeticTiers {
  CosmeticTiers._();

  static const Set<PetAccessory> freeAccessories = {
    PetAccessory.none,
    PetAccessory.bandana,
    PetAccessory.glasses,
    PetAccessory.bowtie,
    PetAccessory.hat,
    PetAccessory.collar,
  };

  static const Set<StickerStyle> freeStyles = {
    StickerStyle.stickerFlat,
    StickerStyle.sticker3d,
    StickerStyle.realistic,
  };

  static const Set<StickerBackground> freeBackgrounds = {
    StickerBackground.transparent,
    StickerBackground.white,
    StickerBackground.gradient,
  };

  static bool isAccessoryLocked(PetAccessory a, {required bool isPremium}) =>
      !isPremium && !freeAccessories.contains(a);

  static bool isStyleLocked(StickerStyle s, {required bool isPremium}) =>
      !isPremium && !freeStyles.contains(s);

  static bool isBackgroundLocked(StickerBackground b,
          {required bool isPremium}) =>
      !isPremium && !freeBackgrounds.contains(b);
}
