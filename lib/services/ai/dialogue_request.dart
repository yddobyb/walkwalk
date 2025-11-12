// lib/services/ai/dialogue_request.dart

/// 대화 요청 데이터 클래스
///
/// Week 3: ConversationService에 전달할 파라미터
/// Riverpod FutureProvider.family에서 사용
class DialogueRequest {
  final String dogName;
  final String dogBreed;
  final int happinessLevel;
  final String context;
  final Map<String, dynamic>? contextData;
  final String? userMessage;
  final String locale; // 다국어 지원: 'ko' 또는 'en'

  const DialogueRequest({
    required this.dogName,
    required this.dogBreed,
    required this.happinessLevel,
    required this.context,
    this.contextData,
    this.userMessage,
    required this.locale,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DialogueRequest &&
        other.dogName == dogName &&
        other.dogBreed == dogBreed &&
        other.happinessLevel == happinessLevel &&
        other.context == context &&
        _mapEquals(other.contextData, contextData) &&
        other.userMessage == userMessage &&
        other.locale == locale;
  }

  @override
  int get hashCode {
    return Object.hash(
      dogName,
      dogBreed,
      happinessLevel,
      context,
      contextData,
      userMessage,
      locale,
    );
  }

  /// Map equality check
  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }

    return true;
  }

  @override
  String toString() {
    return 'DialogueRequest(dogName: $dogName, breed: $dogBreed, happiness: $happinessLevel, context: $context, locale: $locale)';
  }

  /// 복사 생성자
  DialogueRequest copyWith({
    String? dogName,
    String? dogBreed,
    int? happinessLevel,
    String? context,
    Map<String, dynamic>? contextData,
    String? userMessage,
    String? locale,
  }) {
    return DialogueRequest(
      dogName: dogName ?? this.dogName,
      dogBreed: dogBreed ?? this.dogBreed,
      happinessLevel: happinessLevel ?? this.happinessLevel,
      context: context ?? this.context,
      contextData: contextData ?? this.contextData,
      userMessage: userMessage ?? this.userMessage,
      locale: locale ?? this.locale,
    );
  }
}
