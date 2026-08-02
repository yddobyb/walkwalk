// test/data/sticker_option_allowlist_test.dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 클라이언트가 보내는 커스터마이즈 옵션이 서버 allowlist에 전부 있는지 검사한다.
///
/// 왜 필요한가: 서버(`functions/src/utils/stickerPrompt.ts`)는 목록에 없는 값을
/// **거부하지 않고 조용히 기본값으로 바꾼다**(프롬프트 인젝션 방어). 그래서
/// 클라이언트에만 옵션을 추가하면 에러도 로그도 없이 "골랐는데 결과가 안 바뀌는"
/// 상태가 되고, 아무도 눈치채지 못한다.
///
/// Phase 29-2에서 실제로 그 계열의 버그를 발견했다 — `generatePrompt`가 style을
/// 인자로 받고도 쓰지 않아, 무료·프리미엄 양쪽에서 Flat/3D/Realistic 선택이
/// 전부 같은 결과를 냈다.
void main() {
  late String serverSource;
  late String stickerRequestSource;
  late String customizeSource;

  setUpAll(() {
    serverSource =
        File('functions/src/utils/stickerPrompt.ts').readAsStringSync();
    stickerRequestSource =
        File('lib/data/models/sticker_request.dart').readAsStringSync();
    customizeSource =
        File('lib/presentation/screens/customize/customize_screen.dart')
            .readAsStringSync();
  });

  /// 서버의 `export const NAME = [ ... ];`에서 문자열 값 추출
  Set<String> serverAllowlist(String name) {
    final start = serverSource.indexOf('export const $name = [');
    expect(start, greaterThanOrEqualTo(0), reason: '$name을 찾지 못함');
    final end = serverSource.indexOf('];', start);
    return RegExp(r'"([^"]+)"')
        .allMatches(serverSource.substring(start, end))
        .map((m) => m.group(1)!)
        .toSet();
  }

  /// Dart enum 블록 안의 `@JsonValue("...")` 값 추출
  Set<String> enumJsonValues(String enumName) {
    final start = stickerRequestSource.indexOf('enum $enumName {');
    expect(start, greaterThanOrEqualTo(0), reason: '$enumName을 찾지 못함');
    final end = stickerRequestSource.indexOf('\n}', start);
    return RegExp(r'@JsonValue\("([^"]+)"\)')
        .allMatches(stickerRequestSource.substring(start, end))
        .map((m) => m.group(1)!)
        .toSet();
  }

  /// customize_screen의 `_breeds` / `_colors` 리스트에서 'value' 추출
  Set<String> listValues(String listName) {
    final start = customizeSource.indexOf('$listName = [');
    expect(start, greaterThanOrEqualTo(0), reason: '$listName을 찾지 못함');
    final end = customizeSource.indexOf('];', start);
    return RegExp(r"'value': '([^']+)'")
        .allMatches(customizeSource.substring(start, end))
        .map((m) => m.group(1)!)
        .toSet();
  }

  void expectCovered(String label, Set<String> client, Set<String> server) {
    expect(client, isNotEmpty, reason: '$label 파싱 실패 — 테스트가 무의미해짐');
    expect(
      client.difference(server),
      isEmpty,
      reason: '$label: 클라이언트에만 있는 값은 서버가 조용히 기본값으로 '
          '대체해서, 이용자가 골라도 반영되지 않는다',
    );
  }

  test('액세서리가 서버 allowlist에 모두 있음', () {
    expectCovered('accessory', enumJsonValues('StickerAccessory'),
        serverAllowlist('ALLOWED_ACCESSORIES'));
  });

  test('스타일이 서버 allowlist에 모두 있음', () {
    expectCovered('style', enumJsonValues('StickerStyle'),
        serverAllowlist('ALLOWED_STYLES'));
  });

  test('배경이 서버 allowlist에 모두 있음', () {
    expectCovered('background', enumJsonValues('StickerBackground'),
        serverAllowlist('ALLOWED_BGS'));
  });

  test('품종이 서버 allowlist에 모두 있음', () {
    expectCovered('breed', listValues('_breeds'),
        serverAllowlist('ALLOWED_BREEDS'));
  });

  test('색상이 서버 allowlist에 모두 있음', () {
    expectCovered('color', listValues('_colors'),
        serverAllowlist('ALLOWED_COLORS'));
  });

  test('모든 스타일이 프롬프트 조각을 가짐', () {
    // 매핑이 없으면 sticker-flat으로 떨어져 선택이 무의미해진다.
    for (final style in enumJsonValues('StickerStyle')) {
      expect(
        serverSource.contains('"$style":'),
        isTrue,
        reason: 'STYLE_PROMPTS에 $style 항목이 없다',
      );
    }
  });

  test('모든 배경이 프롬프트 조각을 가짐', () {
    for (final bg in enumJsonValues('StickerBackground')) {
      expect(
        RegExp('\\b$bg:').hasMatch(serverSource),
        isTrue,
        reason: 'BG_PROMPTS에 $bg 항목이 없다',
      );
    }
  });

  // ---- 무료/프리미엄 구분 (Phase 29-3) ----
  //
  // 두 쪽이 어긋나면 이용자에겐 열려 보이는데 서버가 기본값으로 바꿔버린다
  // (또는 반대로, 결제한 기능이 잠겨 보인다). 둘 다 조용해서 알아채기 어렵다.

  /// 서버 `FREE_*` 집합
  Set<String> serverFreeSet(String name) => serverAllowlist(name);

  /// 클라이언트 `CosmeticTiers`의 free 집합에서 enum 멤버명 추출
  Set<String> clientFreeMembers(String field, String enumName) {
    final source =
        File('lib/core/constants/cosmetic_tiers.dart').readAsStringSync();
    final start = source.indexOf('$field = {');
    expect(start, greaterThanOrEqualTo(0), reason: '$field를 찾지 못함');
    final end = source.indexOf('};', start);
    return RegExp('$enumName\\.(\\w+)')
        .allMatches(source.substring(start, end))
        .map((m) => m.group(1)!)
        .toSet();
  }

  /// Dart enum 멤버명 → @JsonValue 문자열
  Map<String, String> memberToJsonValue(String enumName) {
    final start = stickerRequestSource.indexOf('enum $enumName {');
    final end = stickerRequestSource.indexOf('\n}', start);
    final block = stickerRequestSource.substring(start, end);
    final out = <String, String>{};
    for (final m
        in RegExp(r'@JsonValue\("([^"]+)"\)\s*\n\s*(\w+),').allMatches(block)) {
      out[m.group(2)!] = m.group(1)!;
    }
    return out;
  }

  void expectFreeSetsMatch(
    String label,
    Set<String> clientMembers,
    Map<String, String> toJson,
    Set<String> serverFree,
  ) {
    final clientJson = clientMembers.map((m) {
      final v = toJson[m];
      expect(v, isNotNull, reason: '$label: $m의 JsonValue를 찾지 못함');
      return v!;
    }).toSet();

    expect(clientJson, isNotEmpty, reason: '$label 파싱 실패');
    expect(
      clientJson,
      equals(serverFree),
      reason: '$label: 무료 집합이 클라이언트와 서버에서 다르다 — '
          '한쪽에만 열려 있으면 이용자가 골라도 서버가 기본값으로 바꾸거나, '
          '결제한 기능이 잠겨 보인다',
    );
  }

  test('무료 액세서리 집합이 서버와 일치', () {
    expectFreeSetsMatch(
      'accessory',
      clientFreeMembers('freeAccessories', 'PetAccessory'),
      // PetAccessory는 도메인 enum이라 JsonValue가 없다 — 이름이 곧 전송값
      {
        for (final m in clientFreeMembers('freeAccessories', 'PetAccessory'))
          m: m
      },
      serverFreeSet('FREE_ACCESSORIES'),
    );
  });

  test('무료 스타일 집합이 서버와 일치', () {
    expectFreeSetsMatch(
      'style',
      clientFreeMembers('freeStyles', 'StickerStyle'),
      memberToJsonValue('StickerStyle'),
      serverFreeSet('FREE_STYLES'),
    );
  });

  test('무료 배경 집합이 서버와 일치', () {
    expectFreeSetsMatch(
      'background',
      clientFreeMembers('freeBackgrounds', 'StickerBackground'),
      memberToJsonValue('StickerBackground'),
      serverFreeSet('FREE_BGS'),
    );
  });

  test('무료 집합은 전체 allowlist의 부분집합', () {
    expect(
      serverFreeSet('FREE_ACCESSORIES')
          .difference(serverAllowlist('ALLOWED_ACCESSORIES')),
      isEmpty,
    );
    expect(
      serverFreeSet('FREE_STYLES').difference(serverAllowlist('ALLOWED_STYLES')),
      isEmpty,
    );
    expect(
      serverFreeSet('FREE_BGS').difference(serverAllowlist('ALLOWED_BGS')),
      isEmpty,
    );
  });

  // ---- 품종·색상 잠금 (Phase 29-5) ----
  //
  // 이 둘은 **클라이언트 전용 잠금**이다. 펫이 Isar(로컬)에만 있어 서버가
  // "이 이용자의 원래 품종"을 알 수 없고, 모른 채 강등하면 온보딩에서
  // Husky를 고른 정당한 이용자의 개가 Shiba Inu로 바뀐다.
  // 그래서 서버엔 FREE_BREEDS/FREE_COLORS가 없고, 대신 아래 불변식을 지킨다.

  Set<String> clientFreeStrings(String field) {
    final source =
        File('lib/core/constants/cosmetic_tiers.dart').readAsStringSync();
    final start = source.indexOf('$field = {');
    expect(start, greaterThanOrEqualTo(0), reason: '$field를 찾지 못함');
    final end = source.indexOf('};', start);
    return RegExp(r"'([^']+)'")
        .allMatches(source.substring(start, end))
        .map((m) => m.group(1)!)
        .toSet();
  }

  test('무료 품종이 전체 품종 목록의 부분집합', () {
    final free = clientFreeStrings('freeBreeds');
    expect(free, isNotEmpty);
    expect(free.difference(listValues('_breeds')), isEmpty,
        reason: '목록에 없는 품종을 무료로 열어봐야 화면에 뜨지 않는다');
  });

  test('무료 색상이 전체 색상 목록의 부분집합', () {
    final free = clientFreeStrings('freeColors');
    expect(free, isNotEmpty);
    expect(free.difference(listValues('_colors')), isEmpty);
  });

  test('서버 기본 품종은 무료여야 한다', () {
    // genStickerFree가 알 수 없는 품종을 이 값으로 대체한다.
    // 이게 잠겨 있으면 강등된 이용자가 **선택할 수도 없는 품종**에 갇힌다.
    expect(
      clientFreeStrings('freeBreeds'),
      contains('Shiba Inu'),
      reason: '서버 fallback 품종이 무료 집합에 없다',
    );
  });

  test('UI 기본 색상은 무료여야 한다', () {
    // customize_screen의 `_color` 초기값. 잠겨 있으면 신규 무료 이용자가
    // 시작부터 잠긴 색을 선택한 상태가 된다.
    final source =
        File('lib/presentation/screens/customize/customize_screen.dart')
            .readAsStringSync();
    final m = RegExp(r"String _color = '(\w+)'").firstMatch(source);
    expect(m, isNotNull, reason: '_color 기본값을 파싱하지 못함');
    expect(clientFreeStrings('freeColors'), contains(m!.group(1)));
  });

  test('none을 뺀 모든 액세서리가 프롬프트 조각을 가짐', () {
    for (final a in enumJsonValues('StickerAccessory')) {
      if (a == 'none') continue;
      expect(
        RegExp('\\b$a:').hasMatch(serverSource),
        isTrue,
        reason: 'ACCESSORY_PROMPTS에 $a 항목이 없다 — 조용히 액세서리 없이 생성된다',
      );
    }
  });
}
