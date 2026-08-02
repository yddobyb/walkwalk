// lib/presentation/widgets/accessory_badge.dart
import 'package:flutter/material.dart';

import '../../core/utils/accessory_assets.dart';
import '../../domain/entities/pet.dart';

/// 펫이 착용 중인 액세서리 뱃지 (Phase 29-1).
///
/// 아바타 위에 겹쳐 놓는 작은 칩. **"그려진 액세서리"가 아니라 "장착 표시"**로
/// 읽히게 디자인한 이유:
/// 생성된 스티커에는 *생성 당시* 액세서리가 이미 그려져 있는데, 그 뒤 이용자가
/// 다른 액세서리로 바꾸면 스티커는 옛것 그대로다(다시 생성하려면 하루 한도를
/// 써야 한다). 이때 액세서리를 펫 몸 위에 덧그리면 모자가 두 개로 보인다.
/// 뱃지는 "지금 장착한 것"을 말할 뿐이라 그 충돌이 없다.
///
/// [PetAccessory.none]이면 아무것도 그리지 않는다.
class AccessoryBadge extends StatelessWidget {
  const AccessoryBadge({
    super.key,
    required this.accessory,
    this.size = 34,
  });

  final PetAccessory accessory;

  /// 뱃지 지름(px). 아바타 크기에 맞춰 조절한다.
  final double size;

  @override
  Widget build(BuildContext context) {
    if (accessory == PetAccessory.none) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          AccessoryAssets.emojiFor(accessory),
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
