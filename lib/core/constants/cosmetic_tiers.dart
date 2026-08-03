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

  /// 무료로 열어두는 품종 (Phase 29-5).
  ///
  /// `Shiba Inu`는 서버 기본값이기도 해서 반드시 포함되어야 한다.
  static const Set<String> freeBreeds = {
    'Golden Retriever',
    'Labrador',
    'Shiba Inu',
  };

  /// 무료로 열어두는 색상. `golden`은 UI 기본값이라 반드시 포함.
  static const Set<String> freeColors = {
    'golden',
    'brown',
    'black',
  };

  static bool isAccessoryLocked(PetAccessory a, {required bool isPremium}) =>
      !isPremium && !freeAccessories.contains(a);

  /// 품종 잠금 여부.
  ///
  /// ⚠️ **[currentPetBreed]는 절대 잠기지 않는다.** 온보딩은 8품종을 모두
  /// 열어주므로, 무료 집합에 없는 품종(예: Husky)을 고른 사람이 나온다.
  /// 그걸 잠그면 "내 개 품종을 내가 못 쓰는" 상태가 되고, 생성 시 서버가
  /// 기본값(Shiba Inu)으로 바꿔 **자기 개가 조용히 다른 개가 된다.**
  ///
  /// ⚠️ 대신 품종·색상 잠금은 **클라이언트 전용**이다. 펫은 Isar(로컬)에만
  /// 있어 서버가 "이 사람의 원래 품종"을 알 수 없어서, 액세서리처럼
  /// 서버에서 강등할 수 없다(강등하면 위의 정당한 Husky 이용자가 깨진다).
  /// 원가 영향이 없는 축이라 감수한 트레이드오프.
  static bool isBreedLocked(
    String breed, {
    required bool isPremium,
    String? currentPetBreed,
  }) {
    if (isPremium) return false;
    if (freeBreeds.contains(breed)) return false;
    if (currentPetBreed != null && breed == currentPetBreed) return false;
    return true;
  }

  static bool isColorLocked(String color, {required bool isPremium}) =>
      !isPremium && !freeColors.contains(color);

  /// 지금 등급에서 **실제로 착용 중인 것으로 취급할** 액세서리 (Phase 29-8).
  ///
  /// 구독이 끝난 이용자는 `pet.accessory`에 프리미엄 액세서리(예: 왕관)가
  /// 남는다. 그대로 두면 세 화면이 서로 다른 말을 했다 —
  /// 홈 배지는 왕관을 보여주고, 커스터마이즈는 잠긴 채 선택돼 있고,
  /// 정작 생성된 스티커엔 왕관이 없었다(서버가 `none`으로 강등).
  /// **아무 안내도 없어서 "생성이 고장났다"로 읽힌다.**
  ///
  /// 그래서 표시·전송은 전부 이 함수를 거쳐 한 가지 답만 내놓는다.
  ///
  /// ⚠️ **저장된 값(`pet.accessory`)은 건드리지 않는다.** 권한은 만료돼도
  /// 데이터는 남겨서, 재구독하면 왕관이 그대로 돌아온다.
  /// (해지 시점에 `none`으로 밀어버리면 복구가 불가능해진다)
  static PetAccessory effectiveAccessory(
    PetAccessory stored, {
    required bool isPremium,
  }) =>
      isAccessoryLocked(stored, isPremium: isPremium)
          ? PetAccessory.none
          : stored;

  static bool isStyleLocked(StickerStyle s, {required bool isPremium}) =>
      !isPremium && !freeStyles.contains(s);

  static bool isBackgroundLocked(StickerBackground b,
          {required bool isPremium}) =>
      !isPremium && !freeBackgrounds.contains(b);
}
