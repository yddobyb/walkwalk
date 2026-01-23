// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'WalkDog';

  @override
  String get appDescription => '가상 반려견과 산책하며 건강해지세요!';

  @override
  String get settings => '설정';

  @override
  String get gameSettings => '게임 설정';

  @override
  String get outdoorMode => '실외 모드';

  @override
  String get outdoorModeDescription => 'GPS를 사용한 실외 산책 감지';

  @override
  String get dailyGoal => '일일 목표';

  @override
  String dailyGoalSteps(int steps) {
    return '$steps걸음';
  }

  @override
  String get badgesAndAchievements => '배지 및 업적';

  @override
  String get badgesDescription => '획득한 배지 확인';

  @override
  String get aiSettings => 'AI 설정';

  @override
  String get localAIChat => '로컬 AI 대화';

  @override
  String get localAIChatDescription => '기기 내에서 실행되는 AI 대화';

  @override
  String get cloudImageGeneration => '클라우드 이미지 생성';

  @override
  String get cloudImageGenerationDescription => '온라인 AI를 통한 스티커 생성';

  @override
  String get aiModelManagement => 'AI 모델 관리';

  @override
  String get aiModelManagementDescription => '로컬 AI 모델 다운로드 및 관리';

  @override
  String get notifications => '알림';

  @override
  String get notificationsDescription => '산책 리마인더 및 알림';

  @override
  String get notificationTime => '알림 시간 설정';

  @override
  String get notificationTimeDescription => '아침 09:00, 저녁 18:00';

  @override
  String get appSettings => '앱 설정';

  @override
  String get darkMode => '다크 모드';

  @override
  String get darkModeDescription => '어두운 테마 사용';

  @override
  String get language => '언어';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => 'English';

  @override
  String get cacheManagement => '캐시 관리';

  @override
  String get cacheManagementDescription => '이미지 및 데이터 캐시 정리';

  @override
  String get information => '정보';

  @override
  String get appInfo => '앱 정보';

  @override
  String appInfoVersion(String version) {
    return 'Version $version';
  }

  @override
  String get help => '도움말';

  @override
  String get helpDescription => '사용법 및 FAQ';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyDescription => '데이터 처리 및 개인정보 보호';

  @override
  String get comingSoon => '곧 구현될 예정입니다!';

  @override
  String get cancel => '취소';

  @override
  String get ok => '확인';

  @override
  String get confirm => '확인';

  @override
  String get dailyGoalDialogTitle => '일일 목표 설정';

  @override
  String get dailyGoalDialogDescription => '목표 걸음수를 설정하세요';

  @override
  String get dailyGoalDialogRange => '(1,000 ~ 30,000 걸음)';

  @override
  String get dailyGoalDialogLabel => '걸음수';

  @override
  String get dailyGoalDialogSuffix => '걸음';

  @override
  String get dailyGoalErrorEmpty => '걸음수를 입력해주세요';

  @override
  String get dailyGoalErrorInvalid => '올바른 숫자를 입력해주세요';

  @override
  String get dailyGoalErrorRange => '1,000 ~ 30,000 사이의 값을 입력해주세요';

  @override
  String dailyGoalUpdated(int steps) {
    return '일일 목표가 $steps걸음으로 설정되었습니다';
  }

  @override
  String dailyGoalUpdateError(String error) {
    return '목표 설정 중 오류가 발생했습니다: $error';
  }

  @override
  String get cacheDialogTitle => '캐시 정리';

  @override
  String get cacheDialogDescription => '이미지 캐시와 임시 데이터를 정리하시겠습니까?';

  @override
  String get cacheCleared => '캐시가 정리되었습니다!';

  @override
  String get languageDialogTitle => '언어 선택';

  @override
  String languageUpdated(String language) {
    return '언어가 $language(으)로 변경되었습니다';
  }

  @override
  String get createPet => '펫 만들기';

  @override
  String get petName => '이름';

  @override
  String get petNameHint => '펫의 이름을 입력하세요';

  @override
  String get petNameError => '이름을 입력해주세요';

  @override
  String get petNameLengthError => '이름은 10자 이하로 입력해주세요';

  @override
  String get petBreed => '품종';

  @override
  String get petColor => '색상';

  @override
  String get petPersonality => '성격';

  @override
  String get noName => '이름 없음';

  @override
  String petCreationError(String error) {
    return '펫 생성 중 오류가 발생했습니다: $error';
  }

  @override
  String get breedGoldenRetriever => '골든 리트리버';

  @override
  String get breedLabrador => '래브라도';

  @override
  String get breedShiba => '시바견';

  @override
  String get breedPomeranian => '포메라니안';

  @override
  String get breedHusky => '허스키';

  @override
  String get breedBeagle => '비글';

  @override
  String get breedBulldog => '불독';

  @override
  String get breedPoodle => '푸들';

  @override
  String get colorGolden => '골든';

  @override
  String get colorBrown => '브라운';

  @override
  String get colorBlack => '블랙';

  @override
  String get colorWhite => '화이트';

  @override
  String get colorGray => '그레이';

  @override
  String get colorCream => '크림';

  @override
  String get personalityCheerful => '명랑한';

  @override
  String get personalityCalm => '차분한';

  @override
  String get personalityEnergetic => '활발한';

  @override
  String get personalityShy => '수줍은';

  @override
  String get personalityPlayful => '장난기 많은';

  @override
  String get streakTitle => '연속 산책 기록';

  @override
  String get daysInARow => '일 연속';

  @override
  String get longestStreak => '최장 기록';

  @override
  String streakDays(int days) {
    return '$days일';
  }

  @override
  String get lastWalk => '마지막 산책';

  @override
  String get noRecord => '기록 없음';

  @override
  String get dataLoadError => '데이터를 불러올 수 없습니다';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String daysAgo(int days) {
    return '$days일 전';
  }

  @override
  String get streakEncouragement0 => '오늘 산책을 시작하고 연속 기록을 세워보세요!';

  @override
  String get streakEncouragement1 => '좋은 시작이에요! 내일도 계속해보세요! 💪';

  @override
  String get streakEncouragementUnder7 => '멋져요! 일주일 연속을 향해 달려가고 있어요! 🔥';

  @override
  String get streakEncouragement7 => '와! 일주일 연속 달성! 정말 대단해요! 🎉';

  @override
  String streakEncouragementUnder30(int days) {
    return '놀라워요! 한 달 연속까지 $days일 남았어요! 🌟';
  }

  @override
  String get streakEncouragement30Plus => '전설이에요! 한 달 이상 연속 산책 중! 👑';

  @override
  String nextGoal3Days(int remaining) {
    return '3일 연속까지 $remaining일 남았어요!';
  }

  @override
  String nextGoalWeek(int remaining) {
    return '일주일 연속까지 $remaining일 남았어요!';
  }

  @override
  String nextGoalTwoWeeks(int remaining) {
    return '2주 연속까지 $remaining일 남았어요!';
  }

  @override
  String nextGoalMonth(int remaining) {
    return '한 달 연속까지 $remaining일 남았어요!';
  }

  @override
  String get keepGoingMessage => '계속 이 기록을 유지해보세요!';

  @override
  String get walkEndWalk => '산책 종료하기';

  @override
  String get walkStartWalk => '산책 시작하기';

  @override
  String get walkEndWalkDescription => '산책을 종료하고 보상을 받아보세요';

  @override
  String get walkStartWalkDescription => '펫과 함께 건강한 산책을 시작해보세요';

  @override
  String get walkEndButton => '산책 종료';

  @override
  String get walkIndoor => '실내 산책';

  @override
  String get walkOutdoor => '실외 산책';

  @override
  String get walkingNow => '산책 중입니다! 걸음수가 실시간으로 기록되고 있어요.';

  @override
  String get walkOutdoorBonus => '실외 산책 시 보너스 간식을 더 많이 획득할 수 있어요!';

  @override
  String get walkSensorInitializing => '걸음수 센서 초기화 중...';

  @override
  String get walkSensorUnavailable => '걸음수 센서를 사용할 수 없습니다';

  @override
  String get walkPermissionRequired => '설정에서 활동 권한을 허용해주세요';

  @override
  String get walkStartedOutdoor => '실외 산책을 시작합니다! 🌳\n위치 권한을 허용해주세요.';

  @override
  String get walkStartedIndoor => '실내 산책을 시작합니다! 🏠';

  @override
  String get walkStartFailed => '산책을 시작할 수 없습니다. 권한을 확인해주세요.';

  @override
  String get walkEndingMessage => '산책을 종료하는 중입니다...\n걸음수가 반영될 때까지 잠시만 기다려주세요';

  @override
  String walkCompleted(int steps, int treats, int happiness) {
    return '산책 완료! $steps걸음 기록됨 🎉\n간식 $treats개, 행복도 +$happiness';
  }

  @override
  String walkLevelUp(int levelBefore, int levelAfter) {
    return '🎊 레벨 업! LV $levelBefore → LV $levelAfter';
  }

  @override
  String walkLevelUpMultiple(int levels) {
    return '(+$levels레벨)';
  }

  @override
  String get walkEndError => '산책 종료 중 오류가 발생했습니다.';

  @override
  String errorOccurred(String error) {
    return '오류가 발생했습니다: $error';
  }

  @override
  String get close => '닫기';

  @override
  String get congratulations => '축하합니다! 🎉';

  @override
  String get tabHome => '홈';

  @override
  String get tabWalk => '산책';

  @override
  String get tabCustomize => '커스터마이즈';

  @override
  String get tabSettings => '설정';

  @override
  String get notificationComingSoon => '알림 기능은 곧 구현될 예정입니다!';

  @override
  String get petStatus => '펫 상태';

  @override
  String get happiness => '행복도';

  @override
  String get experience => '경험치';

  @override
  String get treats => '간식';

  @override
  String treatsCount(int count) {
    return '$count개';
  }

  @override
  String get giveTreat => '간식 주기';

  @override
  String get statusVeryHappy => '아주 행복해해요! 😆';

  @override
  String get statusHappy => '기분이 좋아 보여요! 😊';

  @override
  String get statusNeutral => '보통이에요 😐';

  @override
  String get statusSad => '조금 우울해 보여요 😔';

  @override
  String get statusVerySad => '많이 슬퍼해요 😢';

  @override
  String get statusDepressed => '매우 우울해해요... 😭';

  @override
  String get petInfoLoadError => '펫 정보를 불러올 수 없습니다';

  @override
  String get treatFeedSuccess => '냠냠! 맛있어! 🐕 (행복도 +10)';

  @override
  String get treatFeedError => '간식을 줄 수 없습니다';

  @override
  String errorWithMessage(String message) {
    return '오류: $message';
  }

  @override
  String get personalityCheerfulDesc => '명랑한 성격';

  @override
  String get personalityCalmDesc => '차분한 성격';

  @override
  String get personalityEnergeticDesc => '활발한 성격';

  @override
  String get personalityShyDesc => '수줍은 성격';

  @override
  String get personalityPlayfulDesc => '장난기 많은 성격';

  @override
  String get defaultPetName => '멍멍이';

  @override
  String get defaultPetBreed => '골든 리트리버';

  @override
  String get tapPetToChat => '펫을 터치해서 대화해보세요!';

  @override
  String get customizeTitle => '커스터마이즈';

  @override
  String get accessoriesTitle => '액세서리';

  @override
  String get aiStickerGeneration => 'AI 스티커 생성';

  @override
  String get aiStickerDescription => 'AI가 생성한 나만의 펫 스티커를 만들어보세요!';

  @override
  String get generateSticker => '스티커 생성하기';

  @override
  String get accessoryNone => '없음';

  @override
  String get accessoryBandana => '반다나';

  @override
  String get accessoryGlasses => '안경';

  @override
  String get accessoryBowtie => '나비넥타이';

  @override
  String get accessoryHat => '모자';

  @override
  String get accessoryCollar => '목걸이';

  @override
  String get applyAccessoryTitle => '액세서리 적용';

  @override
  String applyAccessoryConfirm(String accessoryName) {
    return '$accessoryName을(를) 적용하시겠습니까?';
  }

  @override
  String accessoryAppliedSuccess(String accessoryName) {
    return '$accessoryName이(가) 적용되었습니다!';
  }

  @override
  String get apply => '적용';

  @override
  String get styleTitle => '스타일';

  @override
  String get styleFlat => '플랫 2D';

  @override
  String get style3d => '3D';

  @override
  String get styleRealistic => '리얼리스틱';

  @override
  String get backgroundTitle => '배경';

  @override
  String get bgTransparent => '투명';

  @override
  String get bgWhite => '흰색';

  @override
  String get bgGradient => '그라데이션';

  @override
  String get stickerComingSoon => 'AI 스티커 생성 기능은 곧 구현될 예정입니다! 🎨';

  @override
  String get walkTitle => '산책';

  @override
  String get todaySteps => '오늘의 걸음수';

  @override
  String get stepsUnit => 'steps';

  @override
  String get walkGuideTitle => '산책 가이드';

  @override
  String get guideAutoRecording => '폰을 들고 걷기만 하면 자동으로 걸음수가 기록됩니다';

  @override
  String get guideTreatReward => '300걸음마다 간식 1개를 획득할 수 있습니다';

  @override
  String get guideHappinessIncrease => '걸을수록 펫의 행복도가 올라갑니다';

  @override
  String get guideMissionReward => '미션을 완료하면 추가 보상을 받을 수 있습니다';

  @override
  String get comingSoonTitle => '곧 추가될 기능';

  @override
  String get featureGPSTracking => '실시간 GPS 트래킹';

  @override
  String get featureWalkHistory => '산책 기록 저장 및 조회';

  @override
  String get featureOutdoorBonus => '실외 보너스 시스템';

  @override
  String get featureMissionProgress => '산책 중 미션 진행도 표시';

  @override
  String get featureStatistics => '산책 통계 및 그래프';

  @override
  String get badgeWeek3 => 'Week 3';

  @override
  String get badgeWeek4 => 'Week 4';

  @override
  String get achievementsTitle => '배지';

  @override
  String get viewAll => '전체보기';

  @override
  String get firstBadgePrompt => '첫 번째 배지를 획득해보세요!';

  @override
  String get badgesWalkHint => '산책을 시작하면 배지를 얻을 수 있어요';

  @override
  String get badgesLoadError => '배지 정보를 불러올 수 없어요';

  @override
  String settingsLoadError(String error) {
    return '설정을 불러올 수 없습니다: $error';
  }

  @override
  String get notificationTimeHint => '아침과 저녁 알림 시간을 설정하세요';

  @override
  String languageChangeError(String error) {
    return '언어 변경 중 오류가 발생했습니다: $error';
  }

  @override
  String get badgesCollectionTitle => '배지 모음';

  @override
  String get badgesCollectionStatus => '배지 수집 현황';

  @override
  String badgesAchieved(int unlockedCount, int totalCount) {
    return '$unlockedCount / $totalCount 개 달성';
  }

  @override
  String achievementUnlockedDate(String date) {
    return '달성일: $date';
  }

  @override
  String get noBadgesYet => '아직 배지가 없어요';

  @override
  String get startWalkingForFirstBadge => '산책을 시작해서 첫 번째 배지를 획득해보세요!';

  @override
  String get tryAgainLater => '잠시 후 다시 시도해주세요';

  @override
  String get tierBronze => '브론즈';

  @override
  String get tierSilver => '실버';

  @override
  String get tierGold => '골드';

  @override
  String get tierPlatinum => '플래티넘';

  @override
  String get welcomeHeadline => '나만의 가상 반려견과\n함께 걸어보세요!';

  @override
  String get featureStepTrackingTitle => '걸음수 트래킹';

  @override
  String get featureStepTrackingDesc => '산책할 때마다 펫이 행복해해요';

  @override
  String get featureRewardSystemTitle => '보상 시스템';

  @override
  String get featureRewardSystemDesc => '걸음수에 따라 간식과 배지를 획득';

  @override
  String get featureAiChatTitle => 'AI 대화';

  @override
  String get featureAiChatDesc => '펫과 실시간으로 대화하고 교감';

  @override
  String get loadExistingPet => '기존 펫 불러오기';

  @override
  String get missionCompleted => '완료';

  @override
  String get missionProgress => '진행도';

  @override
  String missionTreatsCount(int count) {
    return '$count개';
  }

  @override
  String get missionTreatsLabel => '간식';

  @override
  String get missionHappinessLabel => '행복도';

  @override
  String get missionExpired => '만료됨';

  @override
  String missionDaysRemaining(int days) {
    return '$days일 남음';
  }

  @override
  String missionHoursRemaining(int hours) {
    return '$hours시간 남음';
  }

  @override
  String missionMinutesRemaining(int minutes) {
    return '$minutes분 남음';
  }

  @override
  String missionStepsUnit(int steps) {
    return '$steps걸음';
  }

  @override
  String missionMinutesUnit(int minutes) {
    return '$minutes분';
  }

  @override
  String get missionComplete => '미션 완료!';

  @override
  String get todaysMissions => '오늘의 미션';

  @override
  String moreAvailable(int count) {
    return '$count개 더 있음';
  }

  @override
  String get cannotLoadMissions => '미션을 불러올 수 없습니다';

  @override
  String get newMissionsComingSoon => '새로운 미션이 곧 생성됩니다!';

  @override
  String get missions => '미션';

  @override
  String get stepsUnitLabel => '걸음';

  @override
  String get minutesUnitLabel => '분';

  @override
  String get rewardsEarned => '획득한 보상';

  @override
  String get todaysActivity => '오늘의 활동';

  @override
  String get goalAchieved => '목표 달성! 🎉';

  @override
  String stepsToGoal(int steps) {
    return '목표까지 $steps걸음';
  }

  @override
  String get distance => '거리';

  @override
  String get activeTime => '활동 시간';

  @override
  String get loadingSteps => '걸음수 데이터를 불러오는 중...';

  @override
  String get cannotLoadSteps => '걸음수 데이터를 불러올 수 없습니다';

  @override
  String get checkActivityPermissions => '설정에서 활동 권한을 확인해주세요';

  @override
  String get trackingStateMonitoring => '모니터링';

  @override
  String get trackingStateWalking => '산책 중';

  @override
  String get trackingStateStopped => '중지됨';

  @override
  String get trackingStateError => '오류';

  @override
  String get streakMessageZero => '오늘 산책을 시작하고 연속 기록을 세워보세요!';

  @override
  String get streakMessageOne => '좋은 시작! 내일도 계속해보세요!';

  @override
  String streakMessageActive(int days, int remaining) {
    return '$days일 연속 달성 중! 일주일까지 $remaining일 남았어요!';
  }

  @override
  String streakMessageLong(int days) {
    return '$days일 연속 달성 중! 계속 화이팅!';
  }

  @override
  String get weeklyActivity => '주간 활동';

  @override
  String get last7Days => '최근 7일';

  @override
  String chartTooltipTotal(int steps) {
    return '전체: $steps걸음';
  }

  @override
  String chartTooltipAppWalk(int steps) {
    return '앱 산책: $steps걸음';
  }

  @override
  String get average => '평균';

  @override
  String get maximum => '최고';

  @override
  String get cannotLoadData => '데이터를 불러올 수 없습니다';

  @override
  String get noRecordsYet => '아직 기록이 없습니다';

  @override
  String get mondayShort => '월';

  @override
  String get tuesdayShort => '화';

  @override
  String get wednesdayShort => '수';

  @override
  String get thursdayShort => '목';

  @override
  String get fridayShort => '금';

  @override
  String get saturdayShort => '토';

  @override
  String get sundayShort => '일';

  @override
  String get monthlyTrend => '월간 추세';

  @override
  String get last30Days => '최근 30일';

  @override
  String get totalSteps => '총 걸음';

  @override
  String get dailyAverage => '일평균';

  @override
  String get dogBark => '멍멍! 왈왈!';

  @override
  String get loadingDogInfo => '강아지 정보를 불러오는 중...';

  @override
  String get gpsStatus => 'GPS 상태';

  @override
  String get gpsTracking => 'GPS 추적중';

  @override
  String get gpsWaiting => 'GPS 대기';

  @override
  String get indoorMode => '실내 모드';

  @override
  String get detecting => '감지 중...';

  @override
  String get errorStatus => '오류';

  @override
  String get searchingGpsSignal => 'GPS 신호를 찾는 중...';

  @override
  String get locationSamples => '위치 샘플';

  @override
  String countItems(int count) {
    return '$count개';
  }

  @override
  String get outdoorSignals => '실외 신호';

  @override
  String get outdoorRatio => '실외 비율';

  @override
  String get doubleBonusApplied => '2배 보너스 적용!';

  @override
  String get outdoorBonusRequirement => '실외 50% 이상 시 2배 보너스';

  @override
  String locationPermissionError(String error) {
    return '위치 권한 요청 중 오류가 발생했습니다: $error';
  }

  @override
  String get gpsOutdoorMode => 'GPS 실외 모드';

  @override
  String get locationPermissionGranted => '위치 권한 허용됨';

  @override
  String get locationPermissionGrantedDesc =>
      'GPS를 사용하여 실외 산책을 자동으로 감지하고 보너스 보상을 받을 수 있습니다.';

  @override
  String get locationPermissionRequired => '위치 권한 필요';

  @override
  String get locationPermissionRequiredDesc =>
      '실외 산책 감지와 보너스 보상을 위해 위치 권한이 필요합니다.';

  @override
  String get locationPermissionDenied => '위치 권한 거부됨';

  @override
  String get locationPermissionDeniedDesc => '설정에서 직접 위치 권한을 허용해주세요.';

  @override
  String get checkingPermissionStatus => '권한 상태 확인 중...';

  @override
  String get outdoorModeBenefits => '실외 모드 혜택';

  @override
  String get doubleReward => '2배 보상';

  @override
  String get doubleRewardDesc => '실외 산책 시 간식과 행복도를 2배로 획득';

  @override
  String get accurateDistanceTracking => '정확한 거리 측정';

  @override
  String get accurateDistanceTrackingDesc => 'GPS로 실제 이동 거리와 속도를 정확히 측정';

  @override
  String get specialBadges => '특별 배지';

  @override
  String get specialBadgesDesc => '실외 산책 전용 배지와 업적 해제 가능';

  @override
  String get refreshPermissionStatus => '권한 상태 새로고침';

  @override
  String get allowPermissionInSettings => '설정에서 권한 허용';

  @override
  String get requestingPermission => '권한 요청 중...';

  @override
  String get activateGpsOutdoorMode => 'GPS 실외 모드 활성화';

  @override
  String get daily => '일일';

  @override
  String get weekly => '주간';

  @override
  String get noDailyMissions => '오늘의 미션이 없습니다';

  @override
  String get errorLoadingDailyMissions => '일일 미션을 불러오는 중 오류가 발생했습니다';

  @override
  String get noWeeklyMissions => '이번 주 미션이 없습니다';

  @override
  String get newWeeklyMissionsComingSoon => '새로운 주간 미션이 곧 생성됩니다!';

  @override
  String get errorLoadingWeeklyMissions => '주간 미션을 불러오는 중 오류가 발생했습니다';

  @override
  String get noCompletedMissions => '완료된 미션이 없습니다';

  @override
  String get completeToGetRewards => '미션을 완료하여 보상을 받아보세요!';

  @override
  String get errorLoadingCompletedMissions => '완료된 미션을 불러오는 중 오류가 발생했습니다';

  @override
  String get loadingMissions => '미션을 불러오는 중...';

  @override
  String get retry => '다시 시도';

  @override
  String get dailyMissionType => '일일 미션';

  @override
  String get weeklyMissionType => '주간 미션';

  @override
  String get specialMissionType => '특별 미션';

  @override
  String get rewardsLabel => '보상';

  @override
  String get targetLabel => '목표';

  @override
  String percentComplete(int percent) {
    return '$percent% 완료';
  }

  @override
  String get missionInfoTitle => '미션 정보';

  @override
  String get expiryTime => '만료 일시';

  @override
  String get remainingTime => '남은 시간';

  @override
  String get completionTime => '완료 일시';

  @override
  String get daysUnit => '일';

  @override
  String get hoursUnit => '시간';

  @override
  String get badgeAchieved => '배지 달성!';

  @override
  String get petCreationComingSoon => '곧 펫 생성 화면이 준비될 예정입니다!';

  @override
  String get petLoadingComingSoon => '곧 펫 불러오기 기능이 준비될 예정입니다!';

  @override
  String get missionDailyStepsTitle => '오늘의 걸음수 목표';

  @override
  String missionDailyStepsDescription(int steps) {
    return '$steps걸음 걷기';
  }

  @override
  String get missionWeeklyStepsTitle => '이번 주 걸음수 챌린지';

  @override
  String missionWeeklyStepsDescription(int steps) {
    return '$steps걸음 걷기';
  }

  @override
  String get missionActiveWeekTitle => '활동적인 한 주';

  @override
  String get missionActiveWeekDescription => '총 180분 산책하기';

  @override
  String get missionQuickWalkTitle => '빠른 걸음으로';

  @override
  String get missionQuickWalkDescription => '30분 연속 산책하기';

  @override
  String get missionDistanceChallengeTitle => '거리 도전';

  @override
  String get missionEarlyAchievementTitle => '조기 달성';

  @override
  String get missionConsistentExerciseTitle => '꾸준한 운동';

  @override
  String get missionDistanceChallengeDescription => '2km 이상 걷기';

  @override
  String get missionEarlyAchievementDescription => '3000걸음 조기 달성';

  @override
  String get missionConsistentExerciseDescription => '45분 활동하기';

  @override
  String get achievementFirstWalkTitle => '첫 산책';

  @override
  String get achievementFirstWalkDescription => '첫 번째 산책을 완료했어요!';

  @override
  String get achievementSteps1kTitle => '천 걸음';

  @override
  String get achievementSteps1kDescription => '누적 1,000걸음 달성!';

  @override
  String get achievementSteps5kTitle => '오천 걸음';

  @override
  String get achievementSteps5kDescription => '누적 5,000걸음 달성!';

  @override
  String get achievementSteps10kTitle => '만 걸음';

  @override
  String get achievementSteps10kDescription => '누적 10,000걸음 달성!';

  @override
  String get achievementStreak3Title => '3일 연속';

  @override
  String get achievementStreak3Description => '3일 연속 산책 완료!';

  @override
  String get achievementStreak7Title => '1주일 연속';

  @override
  String get achievementStreak7Description => '7일 연속 산책 완료!';

  @override
  String get achievementOutdoorFirstTitle => '첫 실외 산책';

  @override
  String get achievementOutdoorFirstDescription => '첫 번째 실외 산책을 완료했어요!';

  @override
  String get achievementHappy100Title => '최고 행복도';

  @override
  String get achievementHappy100Description => '행복도 100에 도달했어요!';

  @override
  String get achievementTreats100Title => '간식 부자';

  @override
  String get achievementTreats100Description => '간식 100개를 모았어요!';

  @override
  String get achievementDistance1kmTitle => '1km 달성';

  @override
  String get achievementDistance1kmDescription => '누적 1km 산책 완료!';
}
