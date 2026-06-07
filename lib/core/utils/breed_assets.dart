// lib/core/utils/breed_assets.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../l10n/app_localizations.dart';

/// 품종 → 플랫 아이콘(SVG) 에셋 매핑 유틸
///
/// `pet.breed`는 생성 시점/로케일에 따라 품종 키('goldenRetriever'),
/// 영문 표준명('Golden Retriever'), 또는 현재 로케일 표시명('골든 리트리버')
/// 중 하나로 저장될 수 있어 셋 다 처리한다.
class BreedAssets {
  BreedAssets._();

  /// 품종 키 → SVG 에셋 경로
  static const Map<String, String> _keyToAsset = {
    'goldenRetriever': 'assets/breeds/golden_retriever.svg',
    'labrador': 'assets/breeds/labrador.svg',
    'shiba': 'assets/breeds/shiba.svg',
    'pomeranian': 'assets/breeds/pomeranian.svg',
    'husky': 'assets/breeds/husky.svg',
    'beagle': 'assets/breeds/beagle.svg',
    'bulldog': 'assets/breeds/bulldog.svg',
    'poodle': 'assets/breeds/poodle.svg',
  };

  /// 영문 표준 품종명 → 품종 키
  static const Map<String, String> _enNameToKey = {
    'Golden Retriever': 'goldenRetriever',
    'Labrador': 'labrador',
    'Shiba Inu': 'shiba',
    'Pomeranian': 'pomeranian',
    'Husky': 'husky',
    'Beagle': 'beagle',
    'Bulldog': 'bulldog',
    'Poodle': 'poodle',
  };

  /// 품종 키로 에셋 경로 조회
  static String? assetForKey(String? key) =>
      (key == null) ? null : _keyToAsset[key];

  /// 저장된 breed 값(키 / 영문명 / 현재 로케일 표시명) → 에셋 경로
  static String? assetForBreed(String? breed, AppLocalizations l10n) {
    if (breed == null || breed.isEmpty) return null;

    // 1) 품종 키 직접 매칭
    final byKey = _keyToAsset[breed];
    if (byKey != null) return byKey;

    // 2) 영문 표준명
    final enKey = _enNameToKey[breed];
    if (enKey != null) return _keyToAsset[enKey];

    // 3) 현재 로케일 표시명
    final localeToKey = <String, String>{
      l10n.breedGoldenRetriever: 'goldenRetriever',
      l10n.breedLabrador: 'labrador',
      l10n.breedShiba: 'shiba',
      l10n.breedPomeranian: 'pomeranian',
      l10n.breedHusky: 'husky',
      l10n.breedBeagle: 'beagle',
      l10n.breedBulldog: 'bulldog',
      l10n.breedPoodle: 'poodle',
    };
    final localeKey = localeToKey[breed];
    if (localeKey != null) return _keyToAsset[localeKey];

    return null;
  }

  /// 품종 키로 아이콘 위젯 (에셋 없으면 null)
  static Widget? iconForKey(String? key, {double size = 120}) {
    final asset = assetForKey(key);
    if (asset == null) return null;
    return SvgPicture.asset(asset, width: size, height: size);
  }

  /// 저장된 breed 값으로 아이콘 위젯 (에셋 없으면 null)
  static Widget? iconForBreed(String? breed, AppLocalizations l10n,
      {double size = 120}) {
    final asset = assetForBreed(breed, l10n);
    if (asset == null) return null;
    return SvgPicture.asset(asset, width: size, height: size);
  }
}
