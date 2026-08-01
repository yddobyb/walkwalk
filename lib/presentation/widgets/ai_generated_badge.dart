// lib/presentation/widgets/ai_generated_badge.dart

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// AI 생성물 표시 위젯 모음.
///
/// Phase 27: 인공지능 기본법 제31조 ②항 — 생성형 AI로 만든 결과물은 그 사실을
/// 표시해야 한다. 시행령상 게임·애니메이션류 콘텐츠는 기계판독 표시만으로도
/// 가능하지만, 그 경우에도 "생성형 AI에 의해 생성되었다"는 안내를 1회 이상
/// 제공해야 한다. 여기서는 **가시적 배지 + 안내 문구**를 함께 써서
/// 해석 여지 없이 충족시킨다.

/// 이미지 위에 얹는 "AI 생성" 배지.
///
/// 반투명 검정 배경 + 흰 글씨라 밝은/어두운 이미지 어디에서도 읽힌다.
class AiGeneratedBadge extends StatelessWidget {
  const AiGeneratedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 11, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context).aiGeneratedBadge,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// [child] 이미지의 우하단에 [AiGeneratedBadge]를 겹쳐 표시한다.
class AiGeneratedImageFrame extends StatelessWidget {
  const AiGeneratedImageFrame({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const Positioned(
          right: 8,
          bottom: 8,
          child: AiGeneratedBadge(),
        ),
      ],
    );
  }
}

/// 이미지 아래에 붙는 "이 이미지는 생성형 AI로 만들어졌습니다" 안내 문구.
class AiGeneratedImageNotice extends StatelessWidget {
  const AiGeneratedImageNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline,
          size: 13,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            AppLocalizations.of(context).aiGeneratedImageNotice,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

/// AI가 만든 텍스트(펫 한마디)에 붙이는 작은 인라인 태그.
class AiGeneratedTextTag extends StatelessWidget {
  const AiGeneratedTextTag({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface.withValues(alpha: 0.45);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, size: 10, color: color),
        const SizedBox(width: 4),
        Text(
          AppLocalizations.of(context).aiGeneratedTextNotice,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontSize: 10,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
