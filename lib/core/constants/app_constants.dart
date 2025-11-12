/// WalkDog 앱 전반에서 사용되는 상수들을 정의합니다.
class AppConstants {
  AppConstants._();

  // 앱 정보
  static const String appName = 'WalkDog';
  static const String appVersion = '1.0.0';

  // 걸음수 관련
  static const int dailyStepGoal = 8000;
  static const int maxHappiness = 100;
  static const int minHappiness = 0;
  static const int stepsPerHappiness = 100;
  static const int minWalkDurationSeconds = 10; // 최소 산책 시간 (초)

  // 보상 시스템
  static const int stepsPerTreat = 300; // 300걸음 = 1간식
  static const int treatsPerWalk = 3; // 기본 산책 보상
  static const int happinessPerTreat = 10; // 간식 1개당 행복도 증가
  static const int maxTreats = 999; // 최대 간식 보유량
  static const int happinessDecayPerDay = 5; // 일일 행복도 자연 감소량
  static const int outdoorBonusMultiplier = 2; // 실외 산책 보너스 배수
  static const int minStepsForReward = 100; // 최소 보상 받을 걸음수

  // 레벨 시스템
  static const int stepsPerExperience = 50; // 50걸음 = 1경험치
  static const int distancePerExperience = 100; // 100m = 1경험치
  static const int baseExperiencePerLevel = 100; // 레벨1->2 필요 경험치
  static const double experienceScalingFactor = 1.5; // 레벨당 경험치 증가율
  static const int maxLevel = 100; // 최대 레벨
  static const int levelUpTreatsReward = 5; // 레벨업 시 간식 보상
  static const int levelUpHappinessReward = 20; // 레벨업 시 행복도 보상

  // 애니메이션 시간
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // UI 관련
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 48.0;

  // AI 관련
  static const int maxDialogueLength = 100;
  static const int dialogueTimeoutSeconds = 30;
  static const String defaultModelPath = 'assets/models/qwen2.5-3b-q4.bin';

  // 캐시 관련
  static const int imageCacheMaxAge = 7; // 일
  static const int maxCachedImages = 50;

  // 위치 관련 (GPS/실외 감지)
  static const double outdoorAccuracyThreshold = 30.0; // 미터 - 실외 판정 정확도 임계값
  static const double outdoorSpeedThreshold = 1.0; // m/s - 실외 판정 속도 임계값
  static const int locationDistanceFilter = 5; // 미터 - 위치 업데이트 최소 거리
  static const double maxReasonableSpeed = 15.0; // m/s - 합리적 최대 속도 (54km/h)
  static const double maxReasonableDistancePerSample = 100.0; // 미터 - 샘플간 최대 거리
  static const double minOutdoorRatioForBonus = 0.5; // 실외 보너스를 위한 최소 실외 비율
  static const int minValidSamplesForOutdoor = 5; // 실외 판정을 위한 최소 샘플 수

  // 데이터베이스
  static const String isarDatabaseName = 'walkdog.isar';
  static const int databaseVersion = 1;
  static const int settingsId = 1; // Settings는 단일 레코드 (Singleton)

  // 통계 기간
  static const int weeklyStatisticsDays = 7; // 주간 통계 일수
  static const int monthlyStatisticsDays = 30; // 월간 통계 일수
  static const int streakMaxDays = 90; // 연속 산책 일수 조회 최대 일수
}