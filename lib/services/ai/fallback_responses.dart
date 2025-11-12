// lib/services/ai/fallback_responses.dart

import 'dart:math';

/// 오프라인 또는 API 에러 시 사용하는 규칙 기반 응답
///
/// Week 3: OpenRouter API가 실패할 경우 폴백 시스템
/// - 5가지 컨텍스트별 미리 정의된 응답
/// - 랜덤 선택으로 반복 방지
/// - 컨텍스트 데이터 기반 동적 응답
class FallbackResponses {
  final Random _random = Random();
  final Set<String> _fallbackResponsesSet = {};

  /// 컨텍스트 기반 응답 가져오기
  ///
  /// [context]: 대화 컨텍스트 (walk_complete, mission_complete, feed, level_up, low_happiness, greeting, greeting_static)
  /// [contextData]: 컨텍스트별 추가 데이터 (걸음수, 레벨 등)
  /// [locale]: 언어 설정 ('ko' 또는 'en')
  String getResponse(String context, Map<String, dynamic>? contextData, String locale) {
    switch (context) {
      case 'walk_complete':
        return _getWalkCompleteResponse(contextData, locale);
      case 'mission_complete':
        return _getMissionCompleteResponse(contextData, locale);
      case 'feed':
        return _getFeedResponse(contextData, locale);
      case 'level_up':
        return _getLevelUpResponse(contextData, locale);
      case 'low_happiness':
        return _getLowHappinessResponse(locale);
      case 'greeting':
        return _getGreetingResponse(locale);
      case 'greeting_static':
        return _getGreetingStaticResponse(locale);
      default:
        return _getDefaultResponse(locale);
    }
  }

  /// 랜덤 응답 (컨텍스트 없이 호출 시)
  String getRandomResponse() {
    final responses = [
      '멍멍! 반가워요!',
      '오늘도 좋은 하루예요! 왈왈!',
      '같이 산책 갈까요? 멍멍!',
      '행복해요! 왈왈!',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // ==========================================================================
  // 1. 산책 완료 응답
  // ==========================================================================
  String _getWalkCompleteResponse(Map<String, dynamic>? data, String locale) {
    final steps = data?['steps'] ?? 0;
    final duration = data?['duration'] ?? 0; // 초 단위
    final isOutdoor = data?['isOutdoor'] ?? false;

    if (locale == 'ko') {
      final responses = <String>[
        // 높은 걸음수 (10,000+)
        if (steps > 10000) ...[
          '와! 오늘 정말 많이 걸었네요! 최고예요! 멍멍!',
          '10,000걸음 넘었어요! 대단해요! 왈왈!',
          '이렇게 많이 걸은 건 처음이에요! 행복해요!',
          '정말 멋진 산책이었어요! 고마워요! 멍멍!',
        ],
        // 중간 걸음수 (5,000~10,000)
        if (steps >= 5000 && steps <= 10000) ...[
          '산책 정말 좋았어요! 다음에 또 가요! 멍멍!',
          '오늘도 수고했어요! 기분이 좋아요! 왈왈!',
          '건강해지는 기분이에요! 고마워요!',
          '신나는 산책이었어요! 멍멍!',
        ],
        // 낮은 걸음수 (<5,000)
        if (steps < 5000) ...[
          '산책했어요! 감사해요! 멍멍!',
          '밖에 나가니까 좋았어요! 왈왈!',
          '짧지만 즐거운 산책이었어요!',
          '산책 고마워요! 멍멍!',
        ],
        // 실외 보너스
        if (isOutdoor) ...[
          '밖 공기가 정말 좋았어요! 왈왈!',
          '실외 산책 최고예요! 멍멍!',
          '다음에도 밖으로 나가요!',
        ],
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      // 영어
      final responses = <String>[
        // 높은 걸음수 (10,000+)
        if (steps > 10000) ...[
          'Wow! We walked so much today! Amazing! Woof!',
          'Over 10,000 steps! You\'re awesome! Bark!',
          'This is the most we\'ve ever walked! So happy!',
          'That was such a great walk! Thank you! Woof!',
        ],
        // 중간 걸음수 (5,000~10,000)
        if (steps >= 5000 && steps <= 10000) ...[
          'Great walk! Let\'s do it again! Woof!',
          'Good job today! Feeling great! Bark!',
          'Feeling healthier! Thank you!',
          'That was fun! Woof!',
        ],
        // 낮은 걸음수 (<5,000)
        if (steps < 5000) ...[
          'We walked! Thank you! Woof!',
          'Nice to be outside! Bark!',
          'Short but fun walk!',
          'Thanks for the walk! Woof!',
        ],
        // 실외 보너스
        if (isOutdoor) ...[
          'Fresh air feels great! Bark!',
          'Outdoor walks are the best! Woof!',
          'Let\'s go outside again!',
        ],
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }

  // ==========================================================================
  // 2. 미션 완료 응답
  // ==========================================================================
  String _getMissionCompleteResponse(Map<String, dynamic>? data, String locale) {
    final missionTitle = data?['title'] ?? (locale == 'ko' ? '미션' : 'Mission');
    final treatReward = data?['treatReward'] ?? 0;

    if (locale == 'ko') {
      final responses = [
        '미션 완료! 정말 대단해요! 멍멍!',
        '$missionTitle 달성! 최고예요! 왈왈!',
        '해냈어요! 정말 자랑스러워요!',
        '미션 성공! 간식 $treatReward개 받았어요! 멍멍!',
        '와! 미션 완료했어요! 고마워요!',
        '목표 달성! 정말 멋져요! 왈왈!',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      // 영어
      final responses = [
        'Mission complete! You\'re amazing! Woof!',
        '$missionTitle achieved! Awesome! Bark!',
        'We did it! So proud!',
        'Mission success! Got $treatReward treats! Woof!',
        'Wow! Mission completed! Thank you!',
        'Goal achieved! You\'re great! Bark!',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }

  // ==========================================================================
  // 3. 간식 먹기 응답
  // ==========================================================================
  String _getFeedResponse(Map<String, dynamic>? data, String locale) {
    final treatCount = data?['treatCount'] ?? 0;

    if (locale == 'ko') {
      final responses = <String>[
        // 많은 간식
        if (treatCount > 50) ...[
          '간식이 정말 많아요! 행복해요! 멍멍!',
          '이렇게 많은 간식! 감사해요! 왈왈!',
          '간식 부자예요! 기분 최고!',
        ],
        // 적당한 간식
        if (treatCount > 10 && treatCount <= 50) ...[
          '맛있어요! 고마워요! 멍멍!',
          '간식 냠냠! 정말 맛있어요! 왈왈!',
          '행복한 간식 시간이에요!',
          '간식 더 주세요! 멍멍!',
        ],
        // 적은 간식
        if (treatCount <= 10) ...[
          '간식이 필요해요! 멍멍!',
          '산책하면 간식 받을 수 있어요! 왈왈!',
          '간식 더 모으러 가요!',
        ],
        // 일반
        '맛있어요! 멍멍!',
        '냠냠! 고마워요! 왈왈!',
        '간식 최고예요!',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      // 영어
      final responses = <String>[
        // 많은 간식
        if (treatCount > 50) ...[
          'So many treats! So happy! Woof!',
          'This many treats! Thank you! Bark!',
          'Treat rich! Feeling great!',
        ],
        // 적당한 간식
        if (treatCount > 10 && treatCount <= 50) ...[
          'Yummy! Thank you! Woof!',
          'Treats nom nom! So delicious! Bark!',
          'Happy treat time!',
          'More treats please! Woof!',
        ],
        // 적은 간식
        if (treatCount <= 10) ...[
          'Need treats! Woof!',
          'Can get treats from walking! Bark!',
          'Let\'s collect more treats!',
        ],
        // 일반
        'Delicious! Woof!',
        'Nom nom! Thank you! Bark!',
        'Treats are the best!',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }

  // ==========================================================================
  // 4. 레벨업 응답
  // ==========================================================================
  String _getLevelUpResponse(Map<String, dynamic>? data, String locale) {
    final newLevel = data?['level'] ?? 1;
    final experience = data?['experience'] ?? 0;

    if (locale == 'ko') {
      final responses = [
        '레벨업! 레벨 $newLevel이 됐어요! 멍멍!',
        '와! 레벨 $newLevel! 정말 대단해요! 왈왈!',
        '성장했어요! 레벨 $newLevel 달성!',
        '레벨업! 더 강해진 기분이에요! 멍멍!',
        '와! 레벨 $newLevel! 고마워요!',
        '레벨업! 계속 함께 성장해요! 왈왈!',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      // 영어
      final responses = [
        'Level up! I\'m level $newLevel now! Woof!',
        'Wow! Level $newLevel! Amazing! Bark!',
        'I grew! Level $newLevel achieved!',
        'Level up! Feeling stronger! Woof!',
        'Wow! Level $newLevel! Thank you!',
        'Level up! Let\'s keep growing together! Bark!',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }

  // ==========================================================================
  // 5. 행복도 낮음 응답
  // ==========================================================================
  String _getLowHappinessResponse(String locale) {
    if (locale == 'ko') {
      final responses = [
        '조금 외로워요... 산책 갈까요? 멍멍...',
        '기분이 별로예요... 같이 놀아요? 왈왈...',
        '산책하고 싶어요... 나가요? 멍멍...',
        '심심해요... 간식 줄래요? 왈왈...',
        '같이 시간 보내요... 멍멍...',
        '밖에 나가고 싶어요... 왈왈...',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      // 영어
      final responses = [
        'Feeling lonely... Shall we walk? Woof...',
        'Not feeling great... Play with me? Bark...',
        'Want to walk... Go outside? Woof...',
        'Bored... Can I have a treat? Bark...',
        'Let\'s spend time together... Woof...',
        'Want to go outside... Bark...',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }

  // ==========================================================================
  // 6. 인사 응답 (탭용 - 4가지 랜덤)
  // ==========================================================================
  String _getGreetingResponse(String locale) {
    if (locale == 'ko') {
      final responses = [
        '멍멍! 반가워요!',
        '오늘도 좋은 하루예요! 왈왈!',
        '같이 산책 갈까요? 멍멍!',
        '행복해요! 왈왈!',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      // 영어
      final responses = [
        'Woof! Nice to see you!',
        'Have a great day! Bark!',
        'Shall we walk together? Woof!',
        'So happy! Bark!',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }

  // ==========================================================================
  // 7. 정적 인사 응답 (홈 화면용 - 시간대별)
  // ==========================================================================
  String _getGreetingStaticResponse(String locale) {
    final hour = DateTime.now().hour;

    if (locale == 'ko') {
      if (hour < 12) {
        return '좋은 아침이에요! 오늘도 산책 갈까요? 멍멍!';
      } else if (hour < 18) {
        return '좋은 오후예요! 신나는 하루 보내요! 왈왈!';
      } else {
        return '좋은 저녁이에요! 오늘 하루 어땠어요? 멍멍!';
      }
    } else {
      // 영어
      if (hour < 12) {
        return 'Good morning! Shall we walk today? Woof!';
      } else if (hour < 18) {
        return 'Good afternoon! Have a great day! Bark!';
      } else {
        return 'Good evening! How was your day? Woof!';
      }
    }
  }

  // ==========================================================================
  // 8. 기본 응답 (알 수 없는 컨텍스트)
  // ==========================================================================
  String _getDefaultResponse(String locale) {
    if (locale == 'ko') {
      final responses = [
        '멍멍! 무슨 말인지 모르겠지만 반가워요!',
        '왈왈! 같이 놀아요!',
        '멍멍! 산책 가고 싶어요!',
        '행복해요! 왈왈!',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      // 영어
      final responses = [
        'Woof! Not sure what you mean but nice!',
        'Bark! Let\'s play!',
        'Woof! Want to walk!',
        'So happy! Bark!',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }

  // ==========================================================================
  // Analytics 지원 메서드
  // ==========================================================================

  /// 응답이 폴백에서 왔는지 확인
  ///
  /// Analytics를 위해 응답이 LLM이 아닌 폴백에서 왔는지 확인
  ///
  /// NOTE: 이 방법은 완벽하지 않지만, 폴백 응답은 대부분 "멍멍", "왈왈"을
  /// 포함하므로 높은 정확도로 폴백 여부를 판단할 수 있습니다.
  bool isFromFallback(String response) {
    // 폴백 응답의 특징: "멍멍", "왈왈" 포함
    // LLM 응답도 이를 포함할 수 있지만, 폴백 추적을 위해 사용
    final containsDogSound = response.contains('멍멍') ||
                              response.contains('왈왈') ||
                              response.contains('멍멍!') ||
                              response.contains('왈왈!');

    // 짧은 응답 (< 50자)이면서 강아지 소리 포함 시 폴백으로 간주
    if (containsDogSound && response.length < 50) {
      return true;
    }

    // 저장된 폴백 응답 set에서 확인 (더 정확한 방법)
    return _fallbackResponsesSet.contains(response);
  }

  /// 응답을 폴백 set에 추가 (생성 시 호출)
  void _addToFallbackSet(String response) {
    _fallbackResponsesSet.add(response);
  }
}
