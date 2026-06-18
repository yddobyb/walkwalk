// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'WalkDog';

  @override
  String get appDescription => 'Walk your virtual pet, stay healthy!';

  @override
  String get settings => 'Settings';

  @override
  String get gameSettings => 'Game Settings';

  @override
  String get outdoorMode => 'Outdoor Mode';

  @override
  String get outdoorModeDescription => 'GPS-based outdoor walk detection';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String dailyGoalSteps(int steps) {
    return '$steps steps';
  }

  @override
  String get badgesAndAchievements => 'Badges & Achievements';

  @override
  String get badgesDescription => 'View earned badges';

  @override
  String get aiSettings => 'AI Settings';

  @override
  String get localAIChat => 'Local AI Chat';

  @override
  String get localAIChatDescription => 'On-device AI conversation';

  @override
  String get cloudImageGeneration => 'Cloud Image Generation';

  @override
  String get cloudImageGenerationDescription =>
      'AI-powered sticker generation online';

  @override
  String get aiModelManagement => 'AI Model Management';

  @override
  String get aiModelManagementDescription =>
      'Download and manage local AI models';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDescription => 'Walk reminders and alerts';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String get notificationTimeDescription => 'Morning 09:00, Evening 18:00';

  @override
  String get appSettings => 'App Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDescription => 'Use dark theme';

  @override
  String get language => 'Language';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageEnglish => 'English';

  @override
  String get cacheManagement => 'Cache Management';

  @override
  String get cacheManagementDescription => 'Clear image and data cache';

  @override
  String get information => 'Information';

  @override
  String get appInfo => 'App Info';

  @override
  String appInfoVersion(String version) {
    return 'Version $version';
  }

  @override
  String get help => 'Help';

  @override
  String get helpDescription => 'How to use and FAQ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDescription => 'Data handling and privacy protection';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceDescription => 'Service usage terms and policies';

  @override
  String get couldNotOpenLink => 'Could not open link';

  @override
  String get comingSoon => 'Coming soon!';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirm';

  @override
  String get dailyGoalDialogTitle => 'Set Daily Goal';

  @override
  String get dailyGoalDialogDescription => 'Set your target step count';

  @override
  String get dailyGoalDialogRange => '(1,000 ~ 30,000 steps)';

  @override
  String get dailyGoalDialogLabel => 'Steps';

  @override
  String get dailyGoalDialogSuffix => 'steps';

  @override
  String get dailyGoalErrorEmpty => 'Please enter step count';

  @override
  String get dailyGoalErrorInvalid => 'Please enter a valid number';

  @override
  String get dailyGoalErrorRange =>
      'Please enter a value between 1,000 and 30,000';

  @override
  String dailyGoalUpdated(int steps) {
    return 'Daily goal set to $steps steps';
  }

  @override
  String dailyGoalUpdateError(String error) {
    return 'Error setting goal: $error';
  }

  @override
  String get cacheDialogTitle => 'Clear Cache';

  @override
  String get cacheDialogDescription => 'Clear image cache and temporary data?';

  @override
  String get cacheCleared => 'Cache cleared!';

  @override
  String get languageDialogTitle => 'Select Language';

  @override
  String languageUpdated(String language) {
    return 'Language changed to $language';
  }

  @override
  String get createPet => 'Create Pet';

  @override
  String get petName => 'Name';

  @override
  String get petNameHint => 'Enter your pet\'s name';

  @override
  String get petNameError => 'Please enter a name';

  @override
  String get petNameLengthError => 'Name must be 10 characters or less';

  @override
  String get petNameInvalidCharsError =>
      'Only letters, numbers, spaces, hyphens allowed';

  @override
  String get petBreed => 'Breed';

  @override
  String get petColor => 'Color';

  @override
  String get petPersonality => 'Personality';

  @override
  String get noName => 'No Name';

  @override
  String petCreationError(String error) {
    return 'Error creating pet: $error';
  }

  @override
  String get breedGoldenRetriever => 'Golden Retriever';

  @override
  String get breedLabrador => 'Labrador';

  @override
  String get breedShiba => 'Shiba Inu';

  @override
  String get breedPomeranian => 'Pomeranian';

  @override
  String get breedHusky => 'Husky';

  @override
  String get breedBeagle => 'Beagle';

  @override
  String get breedBulldog => 'Bulldog';

  @override
  String get breedPoodle => 'Poodle';

  @override
  String get colorGolden => 'Golden';

  @override
  String get colorBrown => 'Brown';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorWhite => 'White';

  @override
  String get colorGray => 'Gray';

  @override
  String get colorCream => 'Cream';

  @override
  String get personalityCheerful => 'Cheerful';

  @override
  String get personalityCalm => 'Calm';

  @override
  String get personalityEnergetic => 'Energetic';

  @override
  String get personalityShy => 'Shy';

  @override
  String get personalityPlayful => 'Playful';

  @override
  String get streakTitle => 'Walk Streak';

  @override
  String get daysInARow => 'days in a row';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String streakDays(int days) {
    return '$days days';
  }

  @override
  String get lastWalk => 'Last Walk';

  @override
  String get noRecord => 'No Record';

  @override
  String get dataLoadError => 'Unable to load data';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get streakEncouragement0 =>
      'Start walking today and build your streak!';

  @override
  String get streakEncouragement1 => 'Great start! Keep it up tomorrow! 💪';

  @override
  String get streakEncouragementUnder7 =>
      'Awesome! You\'re on your way to a 7-day streak! 🔥';

  @override
  String get streakEncouragement7 => 'Wow! 7-day streak achieved! Amazing! 🎉';

  @override
  String streakEncouragementUnder30(int days) {
    return 'Incredible! $days days until a month streak! 🌟';
  }

  @override
  String get streakEncouragement30Plus => 'Legendary! Over a month streak! 👑';

  @override
  String nextGoal3Days(int remaining) {
    return '$remaining days until 3-day streak!';
  }

  @override
  String nextGoalWeek(int remaining) {
    return '$remaining days until 1-week streak!';
  }

  @override
  String nextGoalTwoWeeks(int remaining) {
    return '$remaining days until 2-week streak!';
  }

  @override
  String nextGoalMonth(int remaining) {
    return '$remaining days until 1-month streak!';
  }

  @override
  String get keepGoingMessage => 'Keep up this amazing streak!';

  @override
  String get walkEndWalk => 'End Walk';

  @override
  String get walkStartWalk => 'Start Walk';

  @override
  String get walkEndWalkDescription => 'End your walk and get rewards';

  @override
  String get walkStartWalkDescription => 'Start a healthy walk with your pet';

  @override
  String get walkEndButton => 'End Walk';

  @override
  String get walkIndoor => 'Indoor Walk';

  @override
  String get walkOutdoor => 'Outdoor Walk';

  @override
  String get walkingNow =>
      'You\'re walking! Steps are being recorded in real-time.';

  @override
  String get walkOutdoorBonus =>
      'You can earn more bonus treats with outdoor walks!';

  @override
  String get walkSensorInitializing => 'Initializing step sensor...';

  @override
  String get walkSensorUnavailable => 'Step sensor unavailable';

  @override
  String get walkPermissionRequired =>
      'Please allow activity permissions in Settings';

  @override
  String get walkStartedOutdoor =>
      'Outdoor walk started! 🌳\nPlease allow location permissions.';

  @override
  String get walkStartedIndoor => 'Indoor walk started! 🏠';

  @override
  String get walkStartFailed => 'Cannot start walk. Please check permissions.';

  @override
  String get walkEndingMessage =>
      'Ending walk...\nPlease wait while steps are being recorded';

  @override
  String walkCompleted(int steps, int treats, int happiness) {
    return 'Walk complete! $steps steps recorded 🎉\n$treats treats, happiness +$happiness';
  }

  @override
  String walkLevelUp(int levelBefore, int levelAfter) {
    return '🎊 Level Up! LV $levelBefore → LV $levelAfter';
  }

  @override
  String walkLevelUpMultiple(int levels) {
    return '(+$levels levels)';
  }

  @override
  String get walkEndError => 'An error occurred while ending walk.';

  @override
  String errorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get close => 'Close';

  @override
  String get congratulations => 'Congratulations! 🎉';

  @override
  String get tabHome => 'Home';

  @override
  String get tabWalk => 'Walk';

  @override
  String get tabCustomize => 'Customize';

  @override
  String get tabSettings => 'Settings';

  @override
  String get notificationComingSoon => 'Notification feature coming soon!';

  @override
  String get petStatus => 'Pet Status';

  @override
  String get happiness => 'Happiness';

  @override
  String get experience => 'Experience';

  @override
  String get treats => 'Treats';

  @override
  String treatsCount(int count) {
    return '$count treats';
  }

  @override
  String get giveTreat => 'Give Treat';

  @override
  String get statusVeryHappy => 'Very happy! 😆';

  @override
  String get statusHappy => 'Feeling good! 😊';

  @override
  String get statusNeutral => 'Feeling okay 😐';

  @override
  String get statusSad => 'Looks a bit sad 😔';

  @override
  String get statusVerySad => 'Very sad 😢';

  @override
  String get statusDepressed => 'Deeply depressed... 😭';

  @override
  String get petInfoLoadError => 'Unable to load pet information';

  @override
  String get treatFeedSuccess => 'Yum! Delicious! 🐕 (Happiness +10)';

  @override
  String get treatFeedError => 'Cannot give treat';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get personalityCheerfulDesc => 'Cheerful personality';

  @override
  String get personalityCalmDesc => 'Calm personality';

  @override
  String get personalityEnergeticDesc => 'Energetic personality';

  @override
  String get personalityShyDesc => 'Shy personality';

  @override
  String get personalityPlayfulDesc => 'Playful personality';

  @override
  String get defaultPetName => 'Doggy';

  @override
  String get defaultPetBreed => 'Golden Retriever';

  @override
  String get tapPetToChat => 'Tap your pet to chat!';

  @override
  String get customizeTitle => 'Customize';

  @override
  String get accessoriesTitle => 'Accessories';

  @override
  String get aiStickerGeneration => 'AI Sticker Generation';

  @override
  String get aiStickerDescription =>
      'Create your own unique pet stickers with AI!';

  @override
  String get generateSticker => 'Generate Sticker';

  @override
  String get accessoryNone => 'None';

  @override
  String get accessoryBandana => 'Bandana';

  @override
  String get accessoryGlasses => 'Glasses';

  @override
  String get accessoryBowtie => 'Bowtie';

  @override
  String get accessoryHat => 'Hat';

  @override
  String get accessoryCollar => 'Collar';

  @override
  String get applyAccessoryTitle => 'Apply Accessory';

  @override
  String applyAccessoryConfirm(String accessoryName) {
    return 'Would you like to apply $accessoryName?';
  }

  @override
  String accessoryAppliedSuccess(String accessoryName) {
    return '$accessoryName has been applied!';
  }

  @override
  String get apply => 'Apply';

  @override
  String get styleTitle => 'Style';

  @override
  String get styleFlat => 'Flat 2D';

  @override
  String get style3d => '3D';

  @override
  String get styleRealistic => 'Realistic';

  @override
  String get backgroundTitle => 'Background';

  @override
  String get bgTransparent => 'Transparent';

  @override
  String get bgWhite => 'White';

  @override
  String get bgGradient => 'Gradient';

  @override
  String get stickerComingSoon =>
      'AI sticker generation feature coming soon! 🎨';

  @override
  String get walkTitle => 'Walk';

  @override
  String get todaySteps => 'Today\'s Steps';

  @override
  String get stepsUnit => 'steps';

  @override
  String get walkGuideTitle => 'Walking Guide';

  @override
  String get guideAutoRecording =>
      'Your steps are automatically recorded when you walk with your phone';

  @override
  String get guideTreatReward => 'Earn 1 treat for every 300 steps';

  @override
  String get guideHappinessIncrease =>
      'Your pet\'s happiness increases as you walk';

  @override
  String get guideMissionReward =>
      'Complete missions to receive additional rewards';

  @override
  String get comingSoonTitle => 'Coming Soon';

  @override
  String get featureGPSTracking => 'Real-time GPS Tracking';

  @override
  String get featureWalkHistory => 'Walk History & Records';

  @override
  String get featureOutdoorBonus => 'Outdoor Bonus System';

  @override
  String get featureMissionProgress => 'Mission Progress During Walk';

  @override
  String get featureStatistics => 'Walk Statistics & Graphs';

  @override
  String get badgeWeek3 => 'Week 3';

  @override
  String get badgeWeek4 => 'Week 4';

  @override
  String get achievementsTitle => 'Badges';

  @override
  String get viewAll => 'View All';

  @override
  String get firstBadgePrompt => 'Earn your first badge!';

  @override
  String get badgesWalkHint => 'Start walking to earn badges';

  @override
  String get badgesLoadError => 'Unable to load badges';

  @override
  String settingsLoadError(String error) {
    return 'Unable to load settings: $error';
  }

  @override
  String get notificationTimeHint =>
      'Tap to change morning and evening notification times';

  @override
  String get notificationMorning => 'Morning';

  @override
  String get notificationEvening => 'Evening';

  @override
  String get notificationEnabled => 'Notifications enabled';

  @override
  String get notificationDisabled => 'Notifications disabled';

  @override
  String get notificationPermissionDenied =>
      'Notification permission denied. Please allow in device settings.';

  @override
  String get notificationTimeUpdateError => 'Error updating notification time';

  @override
  String get notificationMorningTitle => 'Time for a walk!';

  @override
  String get notificationMorningBody => 'Start a healthy walk today!';

  @override
  String get notificationEveningTitle => 'Have you walked today?';

  @override
  String get notificationEveningBody => 'There\'s still time. Start your walk!';

  @override
  String get notificationMissionTitle => 'You have incomplete missions!';

  @override
  String get notificationMissionBody =>
      'Today\'s missions expire in 3 hours. Check them now!';

  @override
  String notificationLowHappinessTitle(String petName) {
    return '$petName is feeling sad 😢';
  }

  @override
  String notificationLowHappinessBody(int happiness) {
    return 'Happiness dropped to $happiness%. Go for a walk or give treats!';
  }

  @override
  String get notificationTypesInfo =>
      'Walk reminders (AM/PM)  |  Mission expiry  |  Low happiness alert';

  @override
  String languageChangeError(String error) {
    return 'Error occurred while changing language: $error';
  }

  @override
  String get badgesCollectionTitle => 'Badge Collection';

  @override
  String get badgesCollectionStatus => 'Badge Collection Status';

  @override
  String badgesAchieved(int unlockedCount, int totalCount) {
    return '$unlockedCount / $totalCount achieved';
  }

  @override
  String achievementUnlockedDate(String date) {
    return 'Unlocked: $date';
  }

  @override
  String get noBadgesYet => 'No badges yet';

  @override
  String get startWalkingForFirstBadge =>
      'Start walking to earn your first badge!';

  @override
  String get tryAgainLater => 'Please try again later';

  @override
  String get tierBronze => 'Bronze';

  @override
  String get tierSilver => 'Silver';

  @override
  String get tierGold => 'Gold';

  @override
  String get tierPlatinum => 'Platinum';

  @override
  String get welcomeHeadline => 'Walk together with\nyour virtual pet!';

  @override
  String get featureStepTrackingTitle => 'Step Tracking';

  @override
  String get featureStepTrackingDesc => 'Your pet gets happier with every walk';

  @override
  String get featureRewardSystemTitle => 'Reward System';

  @override
  String get featureRewardSystemDesc =>
      'Earn treats and badges based on your steps';

  @override
  String get featureAiChatTitle => 'AI Chat';

  @override
  String get featureAiChatDesc => 'Chat and connect with your pet in real-time';

  @override
  String get loadExistingPet => 'Load Existing Pet';

  @override
  String get missionCompleted => 'Completed';

  @override
  String get missionProgress => 'Progress';

  @override
  String missionTreatsCount(int count) {
    return '$count treats';
  }

  @override
  String get missionTreatsLabel => 'Treats';

  @override
  String get missionHappinessLabel => 'Happiness';

  @override
  String get missionExpired => 'Expired';

  @override
  String missionDaysRemaining(int days) {
    return '$days days left';
  }

  @override
  String missionHoursRemaining(int hours) {
    return '$hours hours left';
  }

  @override
  String missionMinutesRemaining(int minutes) {
    return '$minutes min left';
  }

  @override
  String missionStepsUnit(int steps) {
    return '$steps steps';
  }

  @override
  String missionMinutesUnit(int minutes) {
    return '$minutes min';
  }

  @override
  String get missionComplete => 'Mission Complete!';

  @override
  String get todaysMissions => 'Today\'s Missions';

  @override
  String moreAvailable(int count) {
    return '$count more available';
  }

  @override
  String get cannotLoadMissions => 'Cannot load missions';

  @override
  String get newMissionsComingSoon => 'New missions coming soon!';

  @override
  String get missions => 'Missions';

  @override
  String get stepsUnitLabel => 'steps';

  @override
  String get minutesUnitLabel => 'min';

  @override
  String get rewardsEarned => 'Rewards Earned';

  @override
  String get todaysActivity => 'Today\'s Activity';

  @override
  String get goalAchieved => 'Goal Achieved! 🎉';

  @override
  String stepsToGoal(int steps) {
    return '$steps steps to goal';
  }

  @override
  String get distance => 'Distance';

  @override
  String get activeTime => 'Active Time';

  @override
  String get loadingSteps => 'Loading step data...';

  @override
  String get cannotLoadSteps => 'Cannot load step data';

  @override
  String get checkActivityPermissions =>
      'Please check activity permissions in Settings';

  @override
  String get trackingStateMonitoring => 'Monitoring';

  @override
  String get trackingStateWalking => 'Walking';

  @override
  String get trackingStateStopped => 'Stopped';

  @override
  String get trackingStateError => 'Error';

  @override
  String get streakMessageZero => 'Start walking today and build your streak!';

  @override
  String get streakMessageOne => 'Great start! Keep it up tomorrow! 💪';

  @override
  String streakMessageActive(int days, int remaining) {
    return 'You\'ve achieved $days days in a row! $remaining days until a week!';
  }

  @override
  String streakMessageLong(int days) {
    return 'Wow! $days days in a row! Amazing! 🎊';
  }

  @override
  String get weeklyActivity => 'Weekly Activity';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String chartTooltipTotal(int steps) {
    return 'Total: $steps steps';
  }

  @override
  String chartTooltipAppWalk(int steps) {
    return 'App walk: $steps steps';
  }

  @override
  String get average => 'Average';

  @override
  String get maximum => 'Maximum';

  @override
  String get cannotLoadData => 'Cannot load data';

  @override
  String get noRecordsYet => 'No records yet';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get monthlyTrend => 'Monthly Trend';

  @override
  String get last30Days => 'Last 30 Days';

  @override
  String get totalSteps => 'Total Steps';

  @override
  String get dailyAverage => 'Daily Average';

  @override
  String get dogBark => 'Woof! Bark!';

  @override
  String get loadingDogInfo => 'Loading dog information...';

  @override
  String get gpsStatus => 'GPS Status';

  @override
  String get gpsTracking => 'GPS Tracking';

  @override
  String get gpsWaiting => 'GPS Standby';

  @override
  String get indoorMode => 'Indoor Mode';

  @override
  String get detecting => 'Detecting...';

  @override
  String get errorStatus => 'Error';

  @override
  String get searchingGpsSignal => 'Searching for GPS signal...';

  @override
  String get locationSamples => 'Location Samples';

  @override
  String countItems(int count) {
    return '$count items';
  }

  @override
  String get outdoorSignals => 'Outdoor Signals';

  @override
  String get outdoorRatio => 'Outdoor Ratio';

  @override
  String get doubleBonusApplied => '2x Bonus Applied!';

  @override
  String get outdoorBonusRequirement => '2x bonus for 50%+ outdoor';

  @override
  String locationPermissionError(String error) {
    return 'Error requesting location permission: $error';
  }

  @override
  String get gpsOutdoorMode => 'GPS Outdoor Mode';

  @override
  String get locationPermissionGranted => 'Location Permission Granted';

  @override
  String get locationPermissionGrantedDesc =>
      'GPS can automatically detect outdoor walks and earn bonus rewards.';

  @override
  String get locationPermissionRequired => 'Location Permission Required';

  @override
  String get locationPermissionRequiredDesc =>
      'Location permission is required for outdoor walk detection and bonus rewards.';

  @override
  String get locationPermissionDenied => 'Location Permission Denied';

  @override
  String get locationPermissionDeniedDesc =>
      'Please allow location permission in Settings.';

  @override
  String get checkingPermissionStatus => 'Checking permission status...';

  @override
  String get outdoorModeBenefits => 'Outdoor Mode Benefits';

  @override
  String get doubleReward => '2x Rewards';

  @override
  String get doubleRewardDesc =>
      'Get double treats and happiness during outdoor walks';

  @override
  String get accurateDistanceTracking => 'Accurate Distance Tracking';

  @override
  String get accurateDistanceTrackingDesc =>
      'Precisely measure actual distance and speed with GPS';

  @override
  String get specialBadges => 'Special Badges';

  @override
  String get specialBadgesDesc =>
      'Unlock exclusive outdoor walk badges and achievements';

  @override
  String get refreshPermissionStatus => 'Refresh Permission Status';

  @override
  String get allowPermissionInSettings => 'Allow Permission in Settings';

  @override
  String get requestingPermission => 'Requesting permission...';

  @override
  String get activateGpsOutdoorMode => 'Activate GPS Outdoor Mode';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get noDailyMissions => 'No daily missions today';

  @override
  String get errorLoadingDailyMissions => 'Error loading daily missions';

  @override
  String get noWeeklyMissions => 'No missions this week';

  @override
  String get newWeeklyMissionsComingSoon => 'New weekly missions coming soon!';

  @override
  String get errorLoadingWeeklyMissions => 'Error loading weekly missions';

  @override
  String get noCompletedMissions => 'No completed missions';

  @override
  String get completeToGetRewards => 'Complete missions to get rewards!';

  @override
  String get errorLoadingCompletedMissions =>
      'Error loading completed missions';

  @override
  String get loadingMissions => 'Loading missions...';

  @override
  String get retry => 'Retry';

  @override
  String get dailyMissionType => 'Daily Mission';

  @override
  String get weeklyMissionType => 'Weekly Mission';

  @override
  String get specialMissionType => 'Special Mission';

  @override
  String get rewardsLabel => 'Rewards';

  @override
  String get targetLabel => 'Target';

  @override
  String percentComplete(int percent) {
    return '$percent% Complete';
  }

  @override
  String get missionInfoTitle => 'Mission Info';

  @override
  String get expiryTime => 'Expiry Time';

  @override
  String get remainingTime => 'Remaining Time';

  @override
  String get completionTime => 'Completion Time';

  @override
  String get daysUnit => 'day(s)';

  @override
  String get hoursUnit => 'hour(s)';

  @override
  String get badgeAchieved => 'Badge Achieved!';

  @override
  String get petCreationComingSoon => 'Pet creation screen coming soon!';

  @override
  String get petLoadingComingSoon => 'Pet loading feature coming soon!';

  @override
  String get missionDailyStepsTitle => 'Daily Step Goal';

  @override
  String missionDailyStepsDescription(int steps) {
    return 'Walk $steps steps';
  }

  @override
  String get missionWeeklyStepsTitle => 'Weekly Steps Challenge';

  @override
  String missionWeeklyStepsDescription(int steps) {
    return 'Walk $steps steps';
  }

  @override
  String get missionActiveWeekTitle => 'Active Week';

  @override
  String get missionActiveWeekDescription => 'Walk for 180 minutes total';

  @override
  String get missionQuickWalkTitle => 'Quick Walk';

  @override
  String get missionQuickWalkDescription => 'Walk for 30 minutes continuously';

  @override
  String get missionDistanceChallengeTitle => 'Distance Challenge';

  @override
  String get missionEarlyAchievementTitle => 'Early Achiever';

  @override
  String get missionConsistentExerciseTitle => 'Consistent Exercise';

  @override
  String get missionDistanceChallengeDescription => 'Walk more than 2km';

  @override
  String get missionEarlyAchievementDescription => 'Achieve 3000 steps early';

  @override
  String get missionConsistentExerciseDescription =>
      'Stay active for 45 minutes';

  @override
  String get achievementFirstWalkTitle => 'First Walk';

  @override
  String get achievementFirstWalkDescription => 'Completed your first walk!';

  @override
  String get achievementSteps1kTitle => '1,000 Steps';

  @override
  String get achievementSteps1kDescription => 'Reached 1,000 cumulative steps!';

  @override
  String get achievementSteps5kTitle => '5,000 Steps';

  @override
  String get achievementSteps5kDescription => 'Reached 5,000 cumulative steps!';

  @override
  String get achievementSteps10kTitle => '10,000 Steps';

  @override
  String get achievementSteps10kDescription =>
      'Reached 10,000 cumulative steps!';

  @override
  String get achievementStreak3Title => '3-Day Streak';

  @override
  String get achievementStreak3Description => 'Walked for 3 days in a row!';

  @override
  String get achievementStreak7Title => '1-Week Streak';

  @override
  String get achievementStreak7Description => 'Walked for 7 days in a row!';

  @override
  String get achievementOutdoorFirstTitle => 'First Outdoor Walk';

  @override
  String get achievementOutdoorFirstDescription =>
      'Completed your first outdoor walk!';

  @override
  String get achievementHappy100Title => 'Maximum Happiness';

  @override
  String get achievementHappy100Description => 'Reached happiness level 100!';

  @override
  String get achievementTreats100Title => 'Treat Collector';

  @override
  String get achievementTreats100Description => 'Collected 100 treats!';

  @override
  String get achievementDistance1kmTitle => '1km Achievement';

  @override
  String get achievementDistance1kmDescription => 'Walked 1km in total!';

  @override
  String get walkScreenElapsedTime => 'Elapsed Time';

  @override
  String get walkScreenSessionSteps => 'Session Steps';

  @override
  String get walkScreenOutdoorBadge => 'Outdoor';

  @override
  String get walkScreenIndoorBadge => 'Indoor';

  @override
  String get walkScreenMotivation => 'Keep going! Every step earns rewards!';

  @override
  String get walkScreenStartPrompt => 'Ready to walk? Choose your mode!';

  @override
  String get walkScreenAllMissionsDone => 'All missions completed!';

  @override
  String get helpScreenTitle => 'Help';

  @override
  String get helpGettingStarted => 'Getting Started';

  @override
  String get helpGettingStartedContent =>
      'WalkDog is an app that makes walking with your dog more fun. When you start a walk, your steps are automatically tracked and you can give treats and happiness to your virtual pet.';

  @override
  String get helpHowToWalk => 'How to Walk';

  @override
  String get helpHowToWalkContent =>
      '1. Tap \'Indoor\' or \'Outdoor\' on the home screen or walk tab to start a walk.\n2. Outdoor walks activate GPS for bonus rewards.\n3. During the walk, your steps and time are shown in real-time.\n4. When you end the walk, rewards are automatically calculated.';

  @override
  String get helpRewards => 'Reward System';

  @override
  String get helpRewardsContent =>
      'Walking earns treats and happiness points based on your steps. Use these rewards to level up your virtual pet and unlock new achievements. Outdoor walks earn 1.5x bonus rewards.';

  @override
  String get helpMissions => 'Missions';

  @override
  String get helpMissionsContent =>
      'New missions are generated daily. Complete various missions like reaching your daily step goal or maintaining a walking streak to earn extra rewards.';

  @override
  String get helpAchievements => 'Achievements & Badges';

  @override
  String get helpAchievementsContent =>
      'Earn badges by reaching special milestones. There are Bronze, Silver, Gold, and Platinum tier badges. Check your badge collection in Settings.';

  @override
  String get helpAIFeatures => 'AI Features';

  @override
  String get helpAIFeaturesContent =>
      'The app includes AI-powered conversation features. Your pet will chat based on walking situations, and AI image generation can create pet stickers. You can toggle local AI and cloud image generation in Settings.';

  @override
  String get helpContact => 'Contact Us';

  @override
  String get helpContactContent =>
      'If you encounter any issues or have suggestions, please contact the development team through Settings > App Info.';

  @override
  String get privacyScreenTitle => 'Privacy Policy';

  @override
  String get privacyEffectiveDate => 'Effective Date: January 1, 2025';

  @override
  String get privacyOverview => 'Overview';

  @override
  String get privacyOverviewContent =>
      'WalkDog (the \'App\') values your privacy and protects personal information in accordance with applicable laws. This policy explains what information we collect and how we use it.';

  @override
  String get privacyDataCollection => 'Information We Collect';

  @override
  String get privacyDataCollectionContent =>
      '• Step Data: Collected through the pedometer sensor.\n• Location Data: Collected via GPS during outdoor walks only. Not collected in indoor mode.\n• Account Info: Only minimal information required for login (email, nickname).\n• Pet Data: Virtual pet game data including level, experience, and happiness.';

  @override
  String get privacyDataUsage => 'How We Use Information';

  @override
  String get privacyDataUsageContent =>
      '• Walk tracking and reward calculation\n• Game progress saving and synchronization\n• Mission and achievement system operation\n• AI-powered pet conversations and image generation\n• App service improvement and bug fixes';

  @override
  String get privacyDataStorage => 'Data Storage & Security';

  @override
  String get privacyDataStorageContent =>
      'User data is securely stored in Firebase Cloud. Some data is stored locally on your device for offline use. All data transfers are encrypted.';

  @override
  String get privacyThirdParty => 'Third-Party Services';

  @override
  String get privacyThirdPartyContent =>
      '• Firebase (Google): Authentication, data storage, cloud functions\n• AI Image Generation: Pet sticker creation (optional)\n• These services are governed by their respective privacy policies.';

  @override
  String get privacyUserRights => 'Your Rights';

  @override
  String get privacyUserRightsContent =>
      'You can request access, modification, or deletion of your data at any time. All personal data is permanently deleted upon account deletion. Location and notification permissions can be managed in your device settings.';

  @override
  String get privacyChanges => 'Policy Changes';

  @override
  String get privacyChangesContent =>
      'This privacy policy may be updated. Significant changes will be communicated through in-app notifications.';

  @override
  String get paywallTitle => 'Premium Subscription';

  @override
  String get paywallHeaderTitle => 'WalkDog Premium';

  @override
  String get paywallHeaderSubtitle =>
      'Enjoy high-quality AI images and more benefits';

  @override
  String get paywallBenefitQuality => 'High-quality AI images (Gemini)';

  @override
  String get paywallBenefitQuota => '5 images per day';

  @override
  String get paywallBenefitAds => 'Ad-free experience';

  @override
  String get paywallBenefitSpeed => 'Faster generation speed';

  @override
  String get paywallPricePerMonth => 'month';

  @override
  String get paywallSubscribeButton => 'Start Subscription';

  @override
  String get paywallRestoreButton => 'Restore Purchases';

  @override
  String get paywallTermsNote =>
      'You can cancel your subscription anytime. Payment is processed through your Apple/Google account.';

  @override
  String get paywallSuccess => 'Premium subscription activated!';

  @override
  String get paywallNotConfigured => 'Available after store account setup';

  @override
  String get paywallProductNotFound => 'Unable to load product information';

  @override
  String get paywallRestoreNotFound => 'No subscription to restore';

  @override
  String get subscriptionSection => 'Subscription';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveSubtitle => 'Subscribed';

  @override
  String get premiumInactiveSubtitle => 'Upgrade for high-quality AI images';

  @override
  String get premiumActiveBadge => 'Active';

  @override
  String get stickerGenerating => 'Generating...';

  @override
  String get stickerCached => 'Cached Sticker';

  @override
  String get stickerNew => 'New Sticker';

  @override
  String get stickerApplying => 'Applying...';

  @override
  String get stickerApplyButton => 'Apply This Sticker';

  @override
  String get stickerLoadingMessage => 'Generating sticker...';

  @override
  String get stickerLoadingTime => 'Takes approximately 5-8 seconds';

  @override
  String get stickerErrorDefault => 'An error occurred';

  @override
  String get stickerAppliedSuccess => 'Sticker applied!';

  @override
  String get stickerApplyFailed => 'Failed to apply sticker.';

  @override
  String get quotaRemainingToday => 'Remaining Today';

  @override
  String quotaResetsIn(String time) {
    return 'Resets in $time';
  }

  @override
  String get quotaChecking => 'Checking quota...';

  @override
  String get quotaLoadError => 'Cannot load quota information';

  @override
  String tierQualityLabel(String tierName) {
    return '$tierName Quality';
  }

  @override
  String get premiumUpgradeTitle => 'Upgrade to Premium';

  @override
  String get premiumUpgradeBenefits =>
      '• High-quality AI images (Gemini)\n• 5 generations per day\n• Ad-free experience\n• Faster generation speed';

  @override
  String get premiumUpgradeButton => 'Upgrade Now';

  @override
  String get tierNameFree => 'Free';

  @override
  String get accountSection => 'Account';

  @override
  String get signInTitle => 'Sign In';

  @override
  String get signInSubtitle => 'Back up data and sync across devices';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signInSuccess => 'Sign in successful';

  @override
  String get signInFailed => 'Sign in failed';

  @override
  String get accountConnected => 'Account connected';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirm =>
      'Signing out will switch to anonymous mode. Continue?';

  @override
  String get missionStepsMetricHint => 'Counts your total steps';

  @override
  String get missionWalkMetricHint => 'Counts your in-app walks';

  @override
  String get missionCompleteCelebration => '🎉 Mission complete!';

  @override
  String missionAchievedSteps(String steps) {
    return 'Already $steps steps!';
  }

  @override
  String get permissionPrimingBubble => 'Let\'s walk together!';

  @override
  String get permissionPrimingTitle =>
      'Two quick things\nbefore our first walk';

  @override
  String get permissionStepsTitle => 'Step tracking';

  @override
  String permissionStepsDesc(String petName) {
    return 'Every step you take makes $petName happier and helps them grow';
  }

  @override
  String get permissionStepsBadge => 'Health Connect · read-only';

  @override
  String get permissionNotifTitle => 'Walk reminders';

  @override
  String get permissionNotifDesc =>
      'A gentle nudge when it\'s a great time for a walk';

  @override
  String get permissionNotifBadge => '1–2 a day';

  @override
  String get permissionPrivacyNote => 'Step data never leaves your phone';

  @override
  String get permissionPrimingCta => 'Let\'s walk! 🐾';

  @override
  String get permissionPrimingSkip => 'Maybe later';

  @override
  String get stepPermissionOffDesc => 'Activity permission is off';

  @override
  String get stepPermissionEnableCta => 'Turn on';

  @override
  String get stepPermissionGranted => 'Step tracking is on! 🎉';

  @override
  String get stepPermissionDeniedHint =>
      'Turn on the activity (steps) permission in Settings';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get stepLinkSectionTitle => 'Permissions & linking';

  @override
  String get stepLinkTitle => 'Step tracking';

  @override
  String get stepLinkConnectedSubtitle => 'Connected to health data';

  @override
  String get stepLinkDisconnectedSubtitle => 'Not connected — tap to turn on';

  @override
  String get stepLinkAlreadyConnected => 'Already connected';

  @override
  String get outOfQuotaTitle => 'You\'ve used all your free images today';

  @override
  String get outOfQuotaAdMessage =>
      'Watch a short ad to create 1 more sticker today.';

  @override
  String get outOfQuotaWatchAd => 'Watch ad for +1';

  @override
  String get outOfQuotaUpgrade => 'Upgrade to Premium';

  @override
  String get adNotReady =>
      'The ad isn\'t ready yet. Please try again in a moment.';

  @override
  String get outOfQuotaFreeAdTitle => 'You\'ve used today\'s free stickers';

  @override
  String get outOfQuotaFreeAdBody => 'Watch a short ad to make one more';

  @override
  String outOfQuotaAdRemaining(int count) {
    return '$count more available via ads today';
  }

  @override
  String get outOfQuotaMaxedTitle => 'You\'re out of stickers for today';

  @override
  String outOfQuotaPremiumTitle(int count) {
    return 'All $count made for today! 🐾';
  }

  @override
  String outOfQuotaPremiumBody(String time) {
    return 'Refills in $time — see you tomorrow!';
  }

  @override
  String get outOfQuotaUpgradeBenefits => 'No ads · High quality · 5 per day';
}
