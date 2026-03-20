// test/presentation/screens/onboarding/pet_creation_screen_test.dart
//
// Phase 17: 온보딩 간소화 테스트
//
// 검증 항목:
// 1. 색상/성격 선택 UI 제거 확인 (소스 코드 검증)
// 2. 기본값 설정 확인 (color: 'golden', personality: cheerful)
// 3. 품종 매핑 완전성 (8개 품종 모두 매핑)
// 4. 미리보기 텍스트에 색상 미포함 확인
// 5. Pet 엔티티 하위 호환성 (color, personality 필드 유지)
// 6. 커스터마이즈 화면 품종 역매핑 완전성
// 7. 커스터마이즈 화면 품종 초기화 로직

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:walk_dog/domain/entities/pet.dart';

void main() {
  // ==========================================================================
  // 소스 코드 읽기
  // ==========================================================================
  late String petCreationSource;
  late String customizeSource;
  late String petAvatarSource;
  late String petEntitySource;

  setUpAll(() {
    petCreationSource = File(
      'lib/presentation/screens/onboarding/pet_creation_screen.dart',
    ).readAsStringSync();
    customizeSource = File(
      'lib/presentation/screens/customize/customize_screen.dart',
    ).readAsStringSync();
    petAvatarSource = File(
      'lib/presentation/screens/home/widgets/pet_avatar_widget.dart',
    ).readAsStringSync();
    petEntitySource = File(
      'lib/domain/entities/pet.dart',
    ).readAsStringSync();
  });

  // ==========================================================================
  // 1. 온보딩 화면: 색상/성격 UI 제거 확인
  // ==========================================================================
  group('온보딩 간소화 - UI 제거 확인', () {
    test('색상 선택 UI가 제거됨 (_selectedColor 없음)', () {
      expect(
        petCreationSource.contains('_selectedColor'),
        isFalse,
        reason: '색상 선택 상태 변수가 제거되어야 함',
      );
    });

    test('성격 선택 UI가 제거됨 (_selectedPersonality 없음)', () {
      expect(
        petCreationSource.contains('_selectedPersonality'),
        isFalse,
        reason: '성격 선택 상태 변수가 제거되어야 함',
      );
    });

    test('_getColorMap 메서드가 제거됨', () {
      expect(
        petCreationSource.contains('_getColorMap'),
        isFalse,
        reason: '색상 매핑 메서드가 제거되어야 함',
      );
    });

    test('_getPersonalityMap 메서드가 제거됨', () {
      expect(
        petCreationSource.contains('_getPersonalityMap'),
        isFalse,
        reason: '성격 매핑 메서드가 제거되어야 함',
      );
    });

    test('petColor 레이블이 제거됨', () {
      expect(
        petCreationSource.contains('petColor'),
        isFalse,
        reason: '색상 선택 레이블이 제거되어야 함',
      );
    });

    test('petPersonality 레이블이 제거됨', () {
      expect(
        petCreationSource.contains('petPersonality'),
        isFalse,
        reason: '성격 선택 레이블이 제거되어야 함',
      );
    });

    test('ChoiceChip이 완전히 제거됨', () {
      expect(
        petCreationSource.contains('ChoiceChip'),
        isFalse,
        reason: '색상/성격 선택 칩이 모두 제거되어야 함',
      );
    });
  });

  // ==========================================================================
  // 2. 온보딩 화면: 기본값 설정 확인
  // ==========================================================================
  group('온보딩 간소화 - 기본값 설정', () {
    test('color 필드에 기본값 golden이 설정됨', () {
      expect(
        petCreationSource.contains("color: 'golden'"),
        isTrue,
        reason: 'Pet 생성 시 color 기본값이 golden이어야 함',
      );
    });

    test('personality 필드에 기본값 cheerful이 설정됨', () {
      expect(
        petCreationSource.contains('PetPersonality.cheerful'),
        isTrue,
        reason: 'Pet 생성 시 personality 기본값이 cheerful이어야 함',
      );
    });

    test('이름 입력 필드가 유지됨', () {
      expect(
        petCreationSource.contains('_nameController'),
        isTrue,
        reason: '이름 입력은 유지되어야 함',
      );
    });

    test('품종 선택이 유지됨 (_selectedBreed)', () {
      expect(
        petCreationSource.contains('_selectedBreed'),
        isTrue,
        reason: '품종 선택은 유지되어야 함',
      );
    });

    test('_getBreedMap 메서드가 유지됨', () {
      expect(
        petCreationSource.contains('_getBreedMap'),
        isTrue,
        reason: '품종 매핑은 유지되어야 함',
      );
    });
  });

  // ==========================================================================
  // 3. 품종 매핑 완전성 (온보딩 8개 품종)
  // ==========================================================================
  group('온보딩 품종 매핑 완전성', () {
    final expectedBreeds = [
      'goldenRetriever',
      'labrador',
      'shiba',
      'pomeranian',
      'husky',
      'beagle',
      'bulldog',
      'poodle',
    ];

    for (final breed in expectedBreeds) {
      test('품종 "$breed"이 매핑에 포함됨', () {
        expect(
          petCreationSource.contains("'$breed'"),
          isTrue,
          reason: '품종 $breed이 _getBreedMap에 존재해야 함',
        );
      });
    }

    test('총 8개 품종이 매핑됨', () {
      final breedCount = RegExp(r"'(\w+)': l10n\.breed")
          .allMatches(petCreationSource)
          .length;
      expect(breedCount, equals(8), reason: '8개 품종이 모두 매핑되어야 함');
    });
  });

  // ==========================================================================
  // 4. 미리보기 텍스트: 품종만 표시 (색상 제거)
  // ==========================================================================
  group('미리보기 텍스트 확인', () {
    test('미리보기에 colorName이 포함되지 않음', () {
      expect(
        petCreationSource.contains('colorName'),
        isFalse,
        reason: '미리보기에 색상 이름이 표시되지 않아야 함',
      );
    });

    test('미리보기에 breedName만 표시됨', () {
      // breedName만 단독으로 Text에 전달됨
      expect(
        petCreationSource.contains('breedName,'),
        isTrue,
        reason: '미리보기에 품종 이름만 표시되어야 함',
      );
    });
  });

  // ==========================================================================
  // 5. Pet 엔티티 하위 호환성
  // ==========================================================================
  group('Pet 엔티티 하위 호환성', () {
    test('Pet 엔티티에 color 필드가 유지됨', () {
      expect(
        petEntitySource.contains('required String color'),
        isTrue,
        reason: 'Isar 호환성을 위해 color 필드가 유지되어야 함',
      );
    });

    test('Pet 엔티티에 personality 필드가 유지됨', () {
      expect(
        petEntitySource.contains('required PetPersonality personality'),
        isTrue,
        reason: 'Isar 호환성을 위해 personality 필드가 유지되어야 함',
      );
    });

    test('PetPersonality enum이 유지됨', () {
      expect(
        petEntitySource.contains('enum PetPersonality'),
        isTrue,
        reason: 'PetPersonality enum이 유지되어야 함',
      );
    });

    test('PetPersonality enum에 5개 값이 모두 존재', () {
      for (final p in ['cheerful', 'calm', 'energetic', 'shy', 'playful']) {
        expect(
          petEntitySource.contains(p),
          isTrue,
          reason: 'PetPersonality.$p 이 존재해야 함',
        );
      }
    });

    test('Pet 객체를 기본값으로 생성 가능', () {
      final pet = Pet(
        petId: 'test-1',
        name: 'TestDog',
        breed: 'Golden Retriever',
        color: 'golden',
        accessory: PetAccessory.none,
        happiness: 100,
        treats: 10,
        level: 1,
        experience: 0,
        stepsToday: 0,
        totalSteps: 0,
        lastUpdate: DateTime.now(),
        personality: PetPersonality.cheerful,
        isActive: true,
        createdAt: DateTime.now(),
        consecutiveDays: 0,
        bestStreak: 0,
        avgDailySteps: 0.0,
      );

      expect(pet.color, equals('golden'));
      expect(pet.personality, equals(PetPersonality.cheerful));
      expect(pet.breed, equals('Golden Retriever'));
    });

    test('기존 Pet 데이터와 호환됨 (다른 색상/성격 값도 허용)', () {
      // 기존에 brown/calm으로 생성된 펫도 정상 로드 가능
      final legacyPet = Pet(
        petId: 'legacy-1',
        name: 'OldDog',
        breed: '골든 리트리버',
        color: 'brown',
        accessory: PetAccessory.bandana,
        happiness: 50,
        treats: 5,
        level: 3,
        experience: 300,
        stepsToday: 500,
        totalSteps: 10000,
        lastUpdate: DateTime.now(),
        personality: PetPersonality.calm,
        isActive: true,
        createdAt: DateTime.now(),
        consecutiveDays: 3,
        bestStreak: 7,
        avgDailySteps: 3000.0,
      );

      expect(legacyPet.color, equals('brown'));
      expect(legacyPet.personality, equals(PetPersonality.calm));
    });
  });

  // ==========================================================================
  // 6. 커스터마이즈 화면: 품종 역매핑 완전성
  // ==========================================================================
  group('커스터마이즈 화면 - 품종 역매핑', () {
    test('_reverseMapBreed 메서드가 존재함', () {
      expect(
        customizeSource.contains('_reverseMapBreed'),
        isTrue,
        reason: '품종 역매핑 메서드가 존재해야 함',
      );
    });

    // 역매핑에 8개 품종의 영어 값이 모두 포함되는지 확인
    final expectedEnglishBreeds = [
      'Golden Retriever',
      'Labrador',
      'Shiba Inu',
      'Pomeranian',
      'Husky',
      'Beagle',
      'Bulldog',
      'Poodle',
    ];

    for (final breed in expectedEnglishBreeds) {
      test('역매핑에 "$breed" 포함됨', () {
        expect(
          customizeSource.contains("'$breed'"),
          isTrue,
          reason: '$breed이 역매핑에 존재해야 함',
        );
      });
    }

    test('역매핑이 8개 l10n 키를 모두 사용함', () {
      final reverseMapSection = customizeSource.substring(
        customizeSource.indexOf('_reverseMapBreed'),
        customizeSource.indexOf(
          '}',
          customizeSource.indexOf('_reverseMapBreed') + 200,
        ),
      );
      final l10nCount = RegExp(r'l10n\.breed\w+')
          .allMatches(reverseMapSection)
          .length;
      expect(l10nCount, equals(8), reason: '8개 l10n 품종 키가 모두 사용되어야 함');
    });

    test('_breeds 리스트와 역매핑의 영어 값이 일치함', () {
      // _breeds 리스트의 value 값 추출
      final breedsValues = RegExp(r"'value': '([^']+)'")
          .allMatches(customizeSource)
          .map((m) => m.group(1))
          .toList();

      for (final breed in expectedEnglishBreeds) {
        expect(
          breedsValues.contains(breed),
          isTrue,
          reason: '_breeds 리스트에 $breed이 존재해야 함',
        );
      }
    });
  });

  // ==========================================================================
  // 7. 커스터마이즈 화면: 초기화 로직
  // ==========================================================================
  group('커스터마이즈 화면 - 품종 초기화', () {
    test('_breedInitialized 플래그가 존재함', () {
      expect(
        customizeSource.contains('_breedInitialized'),
        isTrue,
        reason: '초기화 플래그가 존재해야 함',
      );
    });

    test('초기화가 최초 1회만 실행됨 (플래그 체크)', () {
      expect(
        customizeSource.contains('!_breedInitialized'),
        isTrue,
        reason: '초기화 전 플래그 체크가 있어야 함',
      );
    });

    test('petAsync 데이터가 있을 때만 초기화됨', () {
      expect(
        customizeSource.contains('petAsync.hasValue'),
        isTrue,
        reason: 'pet 데이터 유효성 확인 후 초기화해야 함',
      );
    });

    test('null pet일 때 초기화하지 않음', () {
      expect(
        customizeSource.contains('petAsync.value != null'),
        isTrue,
        reason: 'pet이 null이면 초기화하지 않아야 함',
      );
    });

    test('기본 breed 값이 Golden Retriever로 변경됨', () {
      expect(
        customizeSource.contains("String _breed = 'Golden Retriever'"),
        isTrue,
        reason: '기본 breed가 온보딩 기본 품종(Golden Retriever)과 일치해야 함',
      );
    });
  });

  // ==========================================================================
  // 8. 홈 화면 아바타: 성격 텍스트 제거 확인
  // ==========================================================================
  group('홈 화면 아바타 - 성격 표시 제거', () {
    test('_getPersonalityText 메서드가 제거됨', () {
      expect(
        petAvatarSource.contains('_getPersonalityText'),
        isFalse,
        reason: '성격 텍스트 변환 메서드가 제거되어야 함',
      );
    });

    test('petPersonality 변수가 제거됨', () {
      expect(
        petAvatarSource.contains('petPersonality'),
        isFalse,
        reason: '성격 텍스트 변수가 제거되어야 함',
      );
    });

    test('펫 설명에 bullet separator(•)가 제거됨', () {
      expect(
        petAvatarSource.contains('•'),
        isFalse,
        reason: '품종•성격 구분자가 제거되어야 함',
      );
    });

    test('petBreed만 단독으로 표시됨', () {
      // petBreed, 가 Text 위젯에 전달됨
      expect(
        petAvatarSource.contains('petBreed,'),
        isTrue,
        reason: '품종만 표시되어야 함',
      );
    });

    test('personalityCheerfulDesc 참조가 제거됨', () {
      expect(
        petAvatarSource.contains('personalityCheerfulDesc'),
        isFalse,
        reason: '성격 설명 참조가 제거되어야 함',
      );
    });
  });

  // ==========================================================================
  // 9. 보안: 입력 검증
  // ==========================================================================
  group('보안 - 입력 검증', () {
    test('이름 입력에 validator가 존재함', () {
      expect(
        petCreationSource.contains('validator:'),
        isTrue,
        reason: '이름 입력에 검증 로직이 있어야 함',
      );
    });

    test('빈 이름을 거부함', () {
      expect(
        petCreationSource.contains('trim().isEmpty'),
        isTrue,
        reason: '빈 이름이 거부되어야 함',
      );
    });

    test('이름 길이 제한이 있음', () {
      expect(
        petCreationSource.contains('length > 10'),
        isTrue,
        reason: '이름 길이 제한이 있어야 함',
      );
    });

    test('품종 값은 고정 목록에서만 선택됨 (사용자 입력 불가)', () {
      // DropdownButtonFormField 사용 = 고정 목록에서만 선택
      expect(
        petCreationSource.contains('DropdownButtonFormField'),
        isTrue,
        reason: '품종은 드롭다운에서만 선택 가능해야 함',
      );
      // TextFormField는 이름 입력에만 사용
      final textFormFieldCount = RegExp(r'TextFormField')
          .allMatches(petCreationSource)
          .length;
      expect(
        textFormFieldCount,
        equals(1),
        reason: '자유 입력 필드는 이름 1개뿐이어야 함',
      );
    });
  });
}
