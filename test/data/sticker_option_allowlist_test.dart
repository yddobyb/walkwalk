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
