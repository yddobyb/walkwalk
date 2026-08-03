// test/core/cosmetic_tiers_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/core/constants/cosmetic_tiers.dart';
import 'package:walk_dog/domain/entities/pet.dart';

/// 구독이 끝난 이용자의 `pet.accessory`에는 프리미엄 액세서리가 남는다.
/// 표시(홈 배지·미리보기)와 전송(생성)이 각자 판단하면 세 화면이 서로 다른
/// 말을 하게 되므로(왕관이 보이는데 스티커엔 없음), 전부 이 한 함수를 거친다.
void main() {
  group('effectiveAccessory', () {
    test('무료는 잠긴 액세서리를 착용하지 않은 것으로 본다', () {
      expect(
        CosmeticTiers.effectiveAccessory(PetAccessory.crown, isPremium: false),
        PetAccessory.none,
      );
    });

    test('무료도 무료 액세서리는 그대로 유지', () {
      expect(
        CosmeticTiers.effectiveAccessory(PetAccessory.hat, isPremium: false),
        PetAccessory.hat,
      );
    });

    test('프리미엄은 무엇이든 그대로 유지', () {
      for (final a in PetAccessory.values) {
        expect(
          CosmeticTiers.effectiveAccessory(a, isPremium: true),
          a,
          reason: '결제한 이용자에게서 $a를 뺏으면 안 된다',
        );
      }
    });

    test('결과는 절대 잠긴 값이 아니다 (전 조합)', () {
      for (final a in PetAccessory.values) {
        for (final premium in [true, false]) {
          final result =
              CosmeticTiers.effectiveAccessory(a, isPremium: premium);
          expect(
            CosmeticTiers.isAccessoryLocked(result, isPremium: premium),
            isFalse,
            reason: '$a / premium=$premium 에서 잠긴 값이 나왔다 — '
                '이 값이 그대로 생성에 전달되면 서버가 조용히 강등한다',
          );
        }
      }
    });

    test('무료 집합은 전부 통과한다', () {
      for (final a in CosmeticTiers.freeAccessories) {
        expect(
          CosmeticTiers.effectiveAccessory(a, isPremium: false),
          a,
        );
      }
    });
  });

  group('잠금 규칙', () {
    test('none은 어느 등급에서도 잠기지 않는다', () {
      // 강등 결과값이라 잠기면 무한히 되돌릴 수 없는 상태가 된다.
      expect(
        CosmeticTiers.isAccessoryLocked(PetAccessory.none, isPremium: false),
        isFalse,
      );
    });

    test('펫이 가진 품종은 무료 집합 밖이어도 잠기지 않는다', () {
      expect(
        CosmeticTiers.isBreedLocked(
          'Husky',
          isPremium: false,
          currentPetBreed: 'Husky',
        ),
        isFalse,
        reason: '온보딩에서 고른 자기 개 품종을 막으면 생성 시 서버 기본값으로 바뀐다',
      );
    });

    test('펫이 가진 품종이 아니면 무료 집합 밖은 잠긴다', () {
      expect(
        CosmeticTiers.isBreedLocked(
          'Husky',
          isPremium: false,
          currentPetBreed: 'Labrador',
        ),
        isTrue,
      );
    });
  });
}
