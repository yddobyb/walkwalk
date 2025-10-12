// lib/presentation/screens/home/widgets/conditional_low_happiness_dialogue.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/tracking/step_tracking_service.dart';
import 'pet_dialogue_widget.dart';

/// 조건부 low_happiness 대화 위젯
///
/// Week 3 Phase 4: 행복도가 낮을 때만 대화 표시
/// - happiness < 40일 때만 PetDialogueWidget 표시
/// - 그 외에는 아무것도 표시하지 않음
class ConditionalLowHappinessDialogue extends ConsumerWidget {
  const ConditionalLowHappinessDialogue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pet 정보 가져오기
    final petAsync = ref.watch(petTrackingProvider);

    return petAsync.when(
      data: (pet) {
        // Pet이 null이거나 행복도가 40 이상이면 표시하지 않음
        if (pet == null || pet.happiness >= 40) {
          return const SizedBox.shrink();
        }

        // 행복도가 40 미만이면 low_happiness 대화 표시
        return const PetDialogueWidget(
          context: 'low_happiness',
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
