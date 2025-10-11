# WalkDog 데이터베이스 스키마 (2025년 9월 업데이트)

## ⚠️ 현재 구현 상태

**현재 MVP 단계로 5/6 Collection이 구현되었습니다:**
- ✅ **Pet Collection** (완료)
- ✅ **WalkLog Collection** (완료)
- ✅ **Achievement Collection** (완료)
- ✅ **Settings Collection** (완료)
- ✅ **Mission Collection** (완료)
- ⏸️ **DialogueHistory Collection** (Week 3 AI 통합 시 구현 예정)

**실제 Isar 버전**: 3.1.0+1 (문서는 4.0+ 기준)

---

## Isar 3.1+ 데이터베이스 구조

### 1. Pet Collection
```dart
import 'package:isar/isar.dart';

part 'pet_model.g.dart';

@collection
class PetModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String petId;  // UUID
  
  late String name;
  late String breed;
  late String color;
  
  @enumerated
  late PetAccessory accessory;
  
  late int happiness;  // 0-100
  late int treats;     // 보유 간식 수
  late int stepsToday;
  late int totalSteps;
  late DateTime lastUpdate;
  
  // 이미지 경로
  String? stickerPath;      // 생성된 스티커 로컬 경로
  String? stickerUrl;        // 클라우드 URL (캐시용)
  DateTime? stickerGeneratedAt;
  
  // 성격 설정 (AI 대화용)
  @enumerated
  late PetPersonality personality;
  
  // 상태
  late bool isActive;
  late DateTime createdAt;
  
  // 통계
  late int consecutiveDays;  // 연속 산책 일수
  late int bestStreak;       // 최고 연속 기록
  late double avgDailySteps; // 일평균 걸음수
}

enum PetAccessory {
  none,
  bandana,
  glasses,
  bowtie,
  hat,
  collar
}

enum PetPersonality {
  cheerful,   // 명랑한
  calm,       // 차분한
  energetic,  // 활발한
  shy,        // 수줍은
  playful     // 장난기 많은
}
```

### 2. WalkLog Collection
```dart
@collection
class WalkLogModel {
  Id id = Isar.autoIncrement;
  
  late String sessionId;  // UUID
  late DateTime startTime;
  late DateTime endTime;
  
  // 기본 데이터
  late int totalSteps;
  late int duration;      // 초 단위
  late double distance;   // 미터 단위
  late double avgSpeed;   // km/h
  
  // 실외 모드 데이터
  late bool isOutdoor;
  late int validOutdoorSamples;  // 유효 GPS 샘플 수
  
  @embedded
  late List<LocationSample> locationSamples;
  
  // 보상
  late int treatsEarned;
  late int happinessGained;
  
  @embedded
  late List<MissionCompleted> missionsCompleted;
  
  // 메타데이터
  String? weatherCondition;  // 날씨 (선택)
  double? airQuality;        // 공기질 지수 (선택)
}

@embedded
class LocationSample {
  late double latitude;
  late double longitude;
  late DateTime timestamp;
  late double accuracy;  // 미터 단위
  late double speed;     // m/s
}

@embedded
class MissionCompleted {
  late String missionId;
  late String missionType;
  late int rewardAmount;
  late DateTime completedAt;
}
```

### 3. Achievement Collection
```dart
@collection
class AchievementModel {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String code;  // STEPS_1K, STREAK_7, etc.
  
  late String title;
  late String description;
  late String iconPath;
  
  @enumerated
  late AchievementTier tier;
  
  late bool isUnlocked;
  DateTime? unlockedAt;
  
  // 진행도
  late int currentProgress;
  late int targetProgress;
  
  // 보상
  late int treatReward;
  late int happinessReward;
}

enum AchievementTier {
  bronze,
  silver,
  gold,
  platinum
}
```

### 4. Settings Collection
```dart
@collection
class SettingsModel {
  Id id = 1;  // 단일 레코드
  
  // 게임플레이 설정
  late bool isOutdoorModeEnabled;
  late int stepPerTreat;         // 간식당 필요 걸음수
  late double outdoorBonus;      // 실외 보너스 배수
  late int dailyHappinessDecay;  // 일일 행복도 감소
  
  // AI 설정
  late bool localLLMEnabled;
  late bool cloudImageEnabled;
  late String llmModelPath;      // 로컬 모델 경로
  late int maxTokens;            // 최대 응답 토큰
  
  // 알림 설정
  late bool notificationsEnabled;
  late bool morningReminderEnabled;
  late bool eveningReminderEnabled;
  late String morningReminderTime;   // "09:00"
  late String eveningReminderTime;   // "18:00"
  
  // 프라이버시
  late bool analyticsEnabled;
  late bool crashReportingEnabled;
  
  // UI 설정
  late bool darkModeEnabled;
  late String locale;  // "ko", "en", etc.
  
  // 캐시 설정
  late int imageCacheSizeMB;
  late int llmCacheSizeMB;
  
  // 기타
  late DateTime lastSyncTime;
  late String appVersion;
}
```

### 5. Mission Collection
```dart
@collection
class MissionModel {
  Id id = Isar.autoIncrement;
  
  late String missionId;
  late String type;  // daily, weekly, special
  late String title;
  late String description;
  
  // 조건
  late int targetSteps;
  late int targetDuration;  // 초
  late double targetDistance;  // 미터
  
  // 보상
  late int treatReward;
  late int happinessReward;
  String? badgeCode;  // 연결된 배지
  
  // 상태
  late bool isActive;
  late bool isCompleted;
  late DateTime? completedAt;
  late DateTime expiresAt;
  
  // 진행도
  late int currentProgress;
}
```

### 6. DialogueHistory Collection (⏸️ Week 3에 구현 예정)

**상태**: AI 통합과 함께 구현 예정

```dart
@collection
class DialogueHistoryModel {
  Id id = Isar.autoIncrement;
  
  late DateTime timestamp;
  late String context;  // 대화 발생 컨텍스트
  late String userAction;  // 사용자 행동
  late String aiResponse;  // AI 응답
  late int happinessLevel;  // 당시 행복도
  late int responseTimeMs;  // 응답 시간
  
  // 메타데이터
  late bool isOfflineFallback;  // 오프라인 규칙봇 응답 여부
  late String modelVersion;  // 사용된 모델 버전
}
```

## 인덱스 전략

### 주요 인덱스
```dart
// Pet
- petId (unique)
- isActive

// WalkLog  
- startTime
- petId + startTime (복합)

// Achievement
- code (unique)
- isUnlocked + tier (복합)

// Mission
- isActive + expiresAt (복합)
- type + isCompleted (복합)

// DialogueHistory
- timestamp
- context
```

## 데이터 마이그레이션

### 버전 관리
```dart
class DatabaseMigration {
  static const int currentVersion = 1;
  
  static Future<void> migrate(Isar isar, int oldVersion, int newVersion) async {
    if (oldVersion < 1 && newVersion >= 1) {
      // v1 초기 스키마
    }
    
    if (oldVersion < 2 && newVersion >= 2) {
      // v2 마이그레이션 로직
      // 예: 새 필드 추가, 기본값 설정
    }
  }
}
```

## 데이터 초기화

### 초기 데이터 설정
```dart
class DatabaseInitializer {
  static Future<void> initializeDefaults(Isar isar) async {
    await isar.writeTxn(() async {
      // 기본 설정
      final settings = SettingsModel()
        ..isOutdoorModeEnabled = false
        ..stepPerTreat = 300
        ..outdoorBonus = 1.2
        ..dailyHappinessDecay = 10
        ..localLLMEnabled = true
        ..cloudImageEnabled = true
        ..maxTokens = 60
        ..notificationsEnabled = true
        ..morningReminderEnabled = false
        ..eveningReminderEnabled = false
        ..morningReminderTime = "09:00"
        ..eveningReminderTime = "18:00"
        ..analyticsEnabled = false
        ..crashReportingEnabled = true
        ..darkModeEnabled = false
        ..locale = "ko"
        ..imageCacheSizeMB = 100
        ..llmCacheSizeMB = 50
        ..lastSyncTime = DateTime.now()
        ..appVersion = "1.0.0";
      
      await isar.settingsModels.put(settings);
      
      // 기본 배지 데이터
      final achievements = [
        AchievementModel()
          ..code = "FIRST_WALK"
          ..title = "첫 산책"
          ..description = "첫 번째 산책을 완료했어요!"
          ..iconPath = "assets/badges/first_walk.png"
          ..tier = AchievementTier.bronze
          ..isUnlocked = false
          ..currentProgress = 0
          ..targetProgress = 1
          ..treatReward = 5
          ..happinessReward = 10,
        
        AchievementModel()
          ..code = "STEPS_1K"
          ..title = "천 걸음"
          ..description = "누적 1,000걸음 달성!"
          ..iconPath = "assets/badges/steps_1k.png"
          ..tier = AchievementTier.bronze
          ..isUnlocked = false
          ..currentProgress = 0
          ..targetProgress = 1000
          ..treatReward = 10
          ..happinessReward = 15,
        
        // ... 더 많은 배지
      ];
      
      await isar.achievementModels.putAll(achievements);
    });
  }
}
```

## 쿼리 예제

### 자주 사용하는 쿼리
```dart
// 활성 펫 조회
final activePet = await isar.petModels
    .filter()
    .isActiveEqualTo(true)
    .findFirst();

// 오늘 산책 기록
final today = DateTime.now();
final todayLogs = await isar.walkLogModels
    .filter()
    .startTimeBetween(
      DateTime(today.year, today.month, today.day),
      DateTime(today.year, today.month, today.day, 23, 59, 59),
    )
    .findAll();

// 잠금 해제된 배지
final unlockedAchievements = await isar.achievementModels
    .filter()
    .isUnlockedEqualTo(true)
    .sortByTier()
    .thenByUnlockedAtDesc()
    .findAll();

// 활성 미션
final activeMissions = await isar.missionModels
    .filter()
    .isActiveEqualTo(true)
    .expiresAtGreaterThan(DateTime.now())
    .findAll();
```

## 데이터 백업/복원

### 백업
```dart
Future<String> backupDatabase() async {
  final isar = await Isar.open([
    PetModelSchema,
    WalkLogModelSchema,
    AchievementModelSchema,
    SettingsModelSchema,
    MissionModelSchema,
    DialogueHistoryModelSchema,
  ]);
  
  final backup = {
    'pets': await isar.petModels.where().exportJson(),
    'walkLogs': await isar.walkLogModels.where().exportJson(),
    'achievements': await isar.achievementModels.where().exportJson(),
    'settings': await isar.settingsModels.where().exportJson(),
    'missions': await isar.missionModels.where().exportJson(),
    'dialogues': await isar.dialogueHistoryModels.where().exportJson(),
    'version': DatabaseMigration.currentVersion,
    'timestamp': DateTime.now().toIso8601String(),
  };
  
  return jsonEncode(backup);
}
```

### 복원
```dart
Future<void> restoreDatabase(String backupJson) async {
  final backup = jsonDecode(backupJson);
  final isar = await Isar.open([/* schemas */]);
  
  await isar.writeTxn(() async {
    // 기존 데이터 삭제
    await isar.clear();
    
    // 데이터 복원
    await isar.petModels.importJson(backup['pets']);
    await isar.walkLogModels.importJson(backup['walkLogs']);
    await isar.achievementModels.importJson(backup['achievements']);
    await isar.settingsModels.importJson(backup['settings']);
    await isar.missionModels.importJson(backup['missions']);
    await isar.dialogueHistoryModels.importJson(backup['dialogues']);
  });
}
```

## 성능 최적화

### 1. 배치 작업
```dart
// 여러 레코드 한번에 저장
await isar.writeTxn(() async {
  await isar.walkLogModels.putAll(logs);
});
```

### 2. 스트림 사용
```dart
// 실시간 업데이트 감지
Stream<PetModel?> watchActivePet() {
  return isar.petModels
      .filter()
      .isActiveEqualTo(true)
      .watch(fireImmediately: true)
      .map((pets) => pets.firstOrNull);
}
```

### 3. 페이지네이션
```dart
// 대량 데이터 페이징
Future<List<WalkLogModel>> getWalkLogs(int page, int limit) {
  return isar.walkLogModels
      .where()
      .sortByStartTimeDesc()
      .offset(page * limit)
      .limit(limit)
      .findAll();
}
```

## 데이터 정리 정책

### 자동 정리
```dart
class DatabaseCleaner {
  static Future<void> cleanOldData() async {
    final isar = await Isar.open([/* schemas */]);
    final cutoffDate = DateTime.now().subtract(Duration(days: 90));
    
    await isar.writeTxn(() async {
      // 90일 이상 된 대화 기록 삭제
      await isar.dialogueHistoryModels
          .filter()
          .timestampLessThan(cutoffDate)
          .deleteAll();
      
      // 완료된 지 30일 지난 미션 삭제
      final missionCutoff = DateTime.now().subtract(Duration(days: 30));
      await isar.missionModels
          .filter()
          .isCompletedEqualTo(true)
          .completedAtLessThan(missionCutoff)
          .deleteAll();
    });
  }
}
```
