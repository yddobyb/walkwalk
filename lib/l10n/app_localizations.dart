import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'WalkDog'**
  String get appName;

  /// The application description
  ///
  /// In en, this message translates to:
  /// **'Walk your virtual pet, stay healthy!'**
  String get appDescription;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Game settings section title
  ///
  /// In en, this message translates to:
  /// **'Game Settings'**
  String get gameSettings;

  /// Outdoor mode
  ///
  /// In en, this message translates to:
  /// **'Outdoor Mode'**
  String get outdoorMode;

  /// Outdoor mode toggle description
  ///
  /// In en, this message translates to:
  /// **'GPS-based outdoor walk detection'**
  String get outdoorModeDescription;

  /// Daily goal label
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// Daily goal with step count
  ///
  /// In en, this message translates to:
  /// **'{steps} steps'**
  String dailyGoalSteps(int steps);

  /// Badges and achievements label
  ///
  /// In en, this message translates to:
  /// **'Badges & Achievements'**
  String get badgesAndAchievements;

  /// Badges description
  ///
  /// In en, this message translates to:
  /// **'View earned badges'**
  String get badgesDescription;

  /// AI settings section title
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get aiSettings;

  /// Local AI chat toggle label
  ///
  /// In en, this message translates to:
  /// **'Local AI Chat'**
  String get localAIChat;

  /// Local AI chat description
  ///
  /// In en, this message translates to:
  /// **'On-device AI conversation'**
  String get localAIChatDescription;

  /// Cloud image generation toggle label
  ///
  /// In en, this message translates to:
  /// **'Cloud Image Generation'**
  String get cloudImageGeneration;

  /// Cloud image generation description
  ///
  /// In en, this message translates to:
  /// **'AI-powered sticker generation online'**
  String get cloudImageGenerationDescription;

  /// AI model management label
  ///
  /// In en, this message translates to:
  /// **'AI Model Management'**
  String get aiModelManagement;

  /// AI model management description
  ///
  /// In en, this message translates to:
  /// **'Download and manage local AI models'**
  String get aiModelManagementDescription;

  /// Notifications section title and toggle label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications toggle description
  ///
  /// In en, this message translates to:
  /// **'Walk reminders and alerts'**
  String get notificationsDescription;

  /// Notification time label
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get notificationTime;

  /// Notification time description
  ///
  /// In en, this message translates to:
  /// **'Morning 09:00, Evening 18:00'**
  String get notificationTimeDescription;

  /// App settings section title
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Dark mode toggle description
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get darkModeDescription;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Korean language option
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Cache management label
  ///
  /// In en, this message translates to:
  /// **'Cache Management'**
  String get cacheManagement;

  /// Cache management description
  ///
  /// In en, this message translates to:
  /// **'Clear image and data cache'**
  String get cacheManagementDescription;

  /// Information section title
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// App info label
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// App version info
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appInfoVersion(String version);

  /// Help label
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Help description
  ///
  /// In en, this message translates to:
  /// **'How to use and FAQ'**
  String get helpDescription;

  /// Privacy policy label
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy description
  ///
  /// In en, this message translates to:
  /// **'Data handling and privacy protection'**
  String get privacyPolicyDescription;

  /// Terms of service label
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service description
  ///
  /// In en, this message translates to:
  /// **'Service usage terms and policies'**
  String get termsOfServiceDescription;

  /// External link open failure message
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get couldNotOpenLink;

  /// Coming soon message
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get comingSoon;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Daily goal dialog title
  ///
  /// In en, this message translates to:
  /// **'Set Daily Goal'**
  String get dailyGoalDialogTitle;

  /// Daily goal dialog description
  ///
  /// In en, this message translates to:
  /// **'Set your target step count'**
  String get dailyGoalDialogDescription;

  /// Daily goal valid range
  ///
  /// In en, this message translates to:
  /// **'(1,000 ~ 30,000 steps)'**
  String get dailyGoalDialogRange;

  /// Daily goal input label
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get dailyGoalDialogLabel;

  /// Daily goal input suffix
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get dailyGoalDialogSuffix;

  /// Error message for empty step count
  ///
  /// In en, this message translates to:
  /// **'Please enter step count'**
  String get dailyGoalErrorEmpty;

  /// Error message for invalid number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get dailyGoalErrorInvalid;

  /// Error message for out of range value
  ///
  /// In en, this message translates to:
  /// **'Please enter a value between 1,000 and 30,000'**
  String get dailyGoalErrorRange;

  /// Daily goal updated success message
  ///
  /// In en, this message translates to:
  /// **'Daily goal set to {steps} steps'**
  String dailyGoalUpdated(int steps);

  /// Daily goal update error message
  ///
  /// In en, this message translates to:
  /// **'Error setting goal: {error}'**
  String dailyGoalUpdateError(String error);

  /// Cache dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get cacheDialogTitle;

  /// Cache dialog description
  ///
  /// In en, this message translates to:
  /// **'Clear image cache and temporary data?'**
  String get cacheDialogDescription;

  /// Cache cleared success message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared!'**
  String get cacheCleared;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageDialogTitle;

  /// Language updated success message
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageUpdated(String language);

  /// Create pet button
  ///
  /// In en, this message translates to:
  /// **'Create Pet'**
  String get createPet;

  /// Pet name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get petName;

  /// Pet name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your pet\'s name'**
  String get petNameHint;

  /// Pet name required error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get petNameError;

  /// Pet name length error message
  ///
  /// In en, this message translates to:
  /// **'Name must be 10 characters or less'**
  String get petNameLengthError;

  /// Pet name invalid characters error message
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, spaces, hyphens allowed'**
  String get petNameInvalidCharsError;

  /// Pet breed label
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get petBreed;

  /// Pet color label
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get petColor;

  /// Pet personality label
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get petPersonality;

  /// Text displayed when name is empty
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noName;

  /// Pet creation error message
  ///
  /// In en, this message translates to:
  /// **'Error creating pet: {error}'**
  String petCreationError(String error);

  /// Breed: Golden Retriever
  ///
  /// In en, this message translates to:
  /// **'Golden Retriever'**
  String get breedGoldenRetriever;

  /// Breed: Labrador
  ///
  /// In en, this message translates to:
  /// **'Labrador'**
  String get breedLabrador;

  /// Breed: Shiba Inu
  ///
  /// In en, this message translates to:
  /// **'Shiba Inu'**
  String get breedShiba;

  /// Breed: Pomeranian
  ///
  /// In en, this message translates to:
  /// **'Pomeranian'**
  String get breedPomeranian;

  /// Breed: Husky
  ///
  /// In en, this message translates to:
  /// **'Husky'**
  String get breedHusky;

  /// Breed: Beagle
  ///
  /// In en, this message translates to:
  /// **'Beagle'**
  String get breedBeagle;

  /// Breed: Bulldog
  ///
  /// In en, this message translates to:
  /// **'Bulldog'**
  String get breedBulldog;

  /// Breed: Poodle
  ///
  /// In en, this message translates to:
  /// **'Poodle'**
  String get breedPoodle;

  /// Color: Golden
  ///
  /// In en, this message translates to:
  /// **'Golden'**
  String get colorGolden;

  /// Color: Brown
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get colorBrown;

  /// Color: Black
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// Color: White
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// Color: Gray
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get colorGray;

  /// Color: Cream
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get colorCream;

  /// Personality: Cheerful
  ///
  /// In en, this message translates to:
  /// **'Cheerful'**
  String get personalityCheerful;

  /// Personality: Calm
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get personalityCalm;

  /// Personality: Energetic
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get personalityEnergetic;

  /// Personality: Shy
  ///
  /// In en, this message translates to:
  /// **'Shy'**
  String get personalityShy;

  /// Personality: Playful
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get personalityPlayful;

  /// Streak widget title
  ///
  /// In en, this message translates to:
  /// **'Walk Streak'**
  String get streakTitle;

  /// Days in a row unit
  ///
  /// In en, this message translates to:
  /// **'days in a row'**
  String get daysInARow;

  /// Longest streak label
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// Streak days display
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String streakDays(int days);

  /// Last walk label
  ///
  /// In en, this message translates to:
  /// **'Last Walk'**
  String get lastWalk;

  /// No walk record
  ///
  /// In en, this message translates to:
  /// **'No Record'**
  String get noRecord;

  /// Data load error message
  ///
  /// In en, this message translates to:
  /// **'Unable to load data'**
  String get dataLoadError;

  /// Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Days ago display
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(int days);

  /// Streak encouragement message for 0 days
  ///
  /// In en, this message translates to:
  /// **'Start walking today and build your streak!'**
  String get streakEncouragement0;

  /// Streak encouragement message for 1 day
  ///
  /// In en, this message translates to:
  /// **'Great start! Keep it up tomorrow! 💪'**
  String get streakEncouragement1;

  /// Streak encouragement message for under 7 days
  ///
  /// In en, this message translates to:
  /// **'Awesome! You\'re on your way to a 7-day streak! 🔥'**
  String get streakEncouragementUnder7;

  /// Streak encouragement message for 7 days
  ///
  /// In en, this message translates to:
  /// **'Wow! 7-day streak achieved! Amazing! 🎉'**
  String get streakEncouragement7;

  /// Streak encouragement message for under 30 days
  ///
  /// In en, this message translates to:
  /// **'Incredible! {days} days until a month streak! 🌟'**
  String streakEncouragementUnder30(int days);

  /// Streak encouragement message for 30+ days
  ///
  /// In en, this message translates to:
  /// **'Legendary! Over a month streak! 👑'**
  String get streakEncouragement30Plus;

  /// Next goal message for 3 days
  ///
  /// In en, this message translates to:
  /// **'{remaining} days until 3-day streak!'**
  String nextGoal3Days(int remaining);

  /// Next goal message for 1 week
  ///
  /// In en, this message translates to:
  /// **'{remaining} days until 1-week streak!'**
  String nextGoalWeek(int remaining);

  /// Next goal message for 2 weeks
  ///
  /// In en, this message translates to:
  /// **'{remaining} days until 2-week streak!'**
  String nextGoalTwoWeeks(int remaining);

  /// Next goal message for 1 month
  ///
  /// In en, this message translates to:
  /// **'{remaining} days until 1-month streak!'**
  String nextGoalMonth(int remaining);

  /// Keep going message for 30+ days
  ///
  /// In en, this message translates to:
  /// **'Keep up this amazing streak!'**
  String get keepGoingMessage;

  /// End walk button title
  ///
  /// In en, this message translates to:
  /// **'End Walk'**
  String get walkEndWalk;

  /// Start walk button title
  ///
  /// In en, this message translates to:
  /// **'Start Walk'**
  String get walkStartWalk;

  /// End walk button description
  ///
  /// In en, this message translates to:
  /// **'End your walk and get rewards'**
  String get walkEndWalkDescription;

  /// Start walk button description
  ///
  /// In en, this message translates to:
  /// **'Start a healthy walk with your pet'**
  String get walkStartWalkDescription;

  /// End walk button label
  ///
  /// In en, this message translates to:
  /// **'End Walk'**
  String get walkEndButton;

  /// Indoor walk button
  ///
  /// In en, this message translates to:
  /// **'Indoor Walk'**
  String get walkIndoor;

  /// Outdoor walk button
  ///
  /// In en, this message translates to:
  /// **'Outdoor Walk'**
  String get walkOutdoor;

  /// Walking now tip message
  ///
  /// In en, this message translates to:
  /// **'You\'re walking! Steps are being recorded in real-time.'**
  String get walkingNow;

  /// Outdoor walk bonus tip message
  ///
  /// In en, this message translates to:
  /// **'You can earn more bonus treats with outdoor walks!'**
  String get walkOutdoorBonus;

  /// Sensor initialization loading message
  ///
  /// In en, this message translates to:
  /// **'Initializing step sensor...'**
  String get walkSensorInitializing;

  /// Sensor unavailable error title
  ///
  /// In en, this message translates to:
  /// **'Step sensor unavailable'**
  String get walkSensorUnavailable;

  /// Permission required message
  ///
  /// In en, this message translates to:
  /// **'Please allow activity permissions in Settings'**
  String get walkPermissionRequired;

  /// Outdoor walk started success message
  ///
  /// In en, this message translates to:
  /// **'Outdoor walk started! 🌳\nPlease allow location permissions.'**
  String get walkStartedOutdoor;

  /// Indoor walk started success message
  ///
  /// In en, this message translates to:
  /// **'Indoor walk started! 🏠'**
  String get walkStartedIndoor;

  /// Walk start failed error message
  ///
  /// In en, this message translates to:
  /// **'Cannot start walk. Please check permissions.'**
  String get walkStartFailed;

  /// Walk ending in progress message
  ///
  /// In en, this message translates to:
  /// **'Ending walk...\nPlease wait while steps are being recorded'**
  String get walkEndingMessage;

  /// Walk completed success message
  ///
  /// In en, this message translates to:
  /// **'Walk complete! {steps} steps recorded 🎉\n{treats} treats, happiness +{happiness}'**
  String walkCompleted(int steps, int treats, int happiness);

  /// Level up notification message
  ///
  /// In en, this message translates to:
  /// **'🎊 Level Up! LV {levelBefore} → LV {levelAfter}'**
  String walkLevelUp(int levelBefore, int levelAfter);

  /// Multiple level up indicator
  ///
  /// In en, this message translates to:
  /// **'(+{levels} levels)'**
  String walkLevelUpMultiple(int levels);

  /// Walk end failed error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred while ending walk.'**
  String get walkEndError;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(String error);

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Congratulations message
  ///
  /// In en, this message translates to:
  /// **'Congratulations! 🎉'**
  String get congratulations;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// Walk tab label
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get tabWalk;

  /// Customize tab label
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get tabCustomize;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// Notification feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Notification feature coming soon!'**
  String get notificationComingSoon;

  /// Pet status section title
  ///
  /// In en, this message translates to:
  /// **'Pet Status'**
  String get petStatus;

  /// Happiness label
  ///
  /// In en, this message translates to:
  /// **'Happiness'**
  String get happiness;

  /// Experience label
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// Treats label
  ///
  /// In en, this message translates to:
  /// **'Treats'**
  String get treats;

  /// Treats count
  ///
  /// In en, this message translates to:
  /// **'{count} treats'**
  String treatsCount(int count);

  /// Give treat button
  ///
  /// In en, this message translates to:
  /// **'Give Treat'**
  String get giveTreat;

  /// Pet status message - very happy (90+)
  ///
  /// In en, this message translates to:
  /// **'Very happy! 😆'**
  String get statusVeryHappy;

  /// Pet status message - happy (80-89)
  ///
  /// In en, this message translates to:
  /// **'Feeling good! 😊'**
  String get statusHappy;

  /// Pet status message - neutral (60-79)
  ///
  /// In en, this message translates to:
  /// **'Feeling okay 😐'**
  String get statusNeutral;

  /// Pet status message - a bit sad (40-59)
  ///
  /// In en, this message translates to:
  /// **'Looks a bit sad 😔'**
  String get statusSad;

  /// Pet status message - very sad (20-39)
  ///
  /// In en, this message translates to:
  /// **'Very sad 😢'**
  String get statusVerySad;

  /// Pet status message - depressed (0-19)
  ///
  /// In en, this message translates to:
  /// **'Deeply depressed... 😭'**
  String get statusDepressed;

  /// Pet information loading failure message
  ///
  /// In en, this message translates to:
  /// **'Unable to load pet information'**
  String get petInfoLoadError;

  /// Treat feeding success message
  ///
  /// In en, this message translates to:
  /// **'Yum! Delicious! 🐕 (Happiness +10)'**
  String get treatFeedSuccess;

  /// Treat feeding failure message
  ///
  /// In en, this message translates to:
  /// **'Cannot give treat'**
  String get treatFeedError;

  /// Error message (with exception)
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// Personality description - cheerful
  ///
  /// In en, this message translates to:
  /// **'Cheerful personality'**
  String get personalityCheerfulDesc;

  /// Personality description - calm
  ///
  /// In en, this message translates to:
  /// **'Calm personality'**
  String get personalityCalmDesc;

  /// Personality description - energetic
  ///
  /// In en, this message translates to:
  /// **'Energetic personality'**
  String get personalityEnergeticDesc;

  /// Personality description - shy
  ///
  /// In en, this message translates to:
  /// **'Shy personality'**
  String get personalityShyDesc;

  /// Personality description - playful
  ///
  /// In en, this message translates to:
  /// **'Playful personality'**
  String get personalityPlayfulDesc;

  /// Default pet name
  ///
  /// In en, this message translates to:
  /// **'Doggy'**
  String get defaultPetName;

  /// Default pet breed
  ///
  /// In en, this message translates to:
  /// **'Golden Retriever'**
  String get defaultPetBreed;

  /// Pet interaction hint message
  ///
  /// In en, this message translates to:
  /// **'Tap your pet to chat!'**
  String get tapPetToChat;

  /// Customize screen title
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get customizeTitle;

  /// Accessories section title
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessoriesTitle;

  /// AI sticker generation section title
  ///
  /// In en, this message translates to:
  /// **'AI Sticker Generation'**
  String get aiStickerGeneration;

  /// AI sticker generation description
  ///
  /// In en, this message translates to:
  /// **'Create your own unique pet stickers with AI!'**
  String get aiStickerDescription;

  /// Generate sticker button label
  ///
  /// In en, this message translates to:
  /// **'Generate Sticker'**
  String get generateSticker;

  /// Accessory - None
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get accessoryNone;

  /// Accessory - Bandana
  ///
  /// In en, this message translates to:
  /// **'Bandana'**
  String get accessoryBandana;

  /// Accessory - Glasses
  ///
  /// In en, this message translates to:
  /// **'Glasses'**
  String get accessoryGlasses;

  /// Accessory - Bowtie
  ///
  /// In en, this message translates to:
  /// **'Bowtie'**
  String get accessoryBowtie;

  /// Accessory - Hat
  ///
  /// In en, this message translates to:
  /// **'Hat'**
  String get accessoryHat;

  /// Accessory - Collar
  ///
  /// In en, this message translates to:
  /// **'Collar'**
  String get accessoryCollar;

  /// Apply accessory dialog title
  ///
  /// In en, this message translates to:
  /// **'Apply Accessory'**
  String get applyAccessoryTitle;

  /// Apply accessory confirmation message
  ///
  /// In en, this message translates to:
  /// **'Would you like to apply {accessoryName}?'**
  String applyAccessoryConfirm(String accessoryName);

  /// Accessory applied success message
  ///
  /// In en, this message translates to:
  /// **'{accessoryName} has been applied!'**
  String accessoryAppliedSuccess(String accessoryName);

  /// Apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Style section title
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get styleTitle;

  /// Style - Flat 2D
  ///
  /// In en, this message translates to:
  /// **'Flat 2D'**
  String get styleFlat;

  /// Style - 3D
  ///
  /// In en, this message translates to:
  /// **'3D'**
  String get style3d;

  /// Style - Realistic
  ///
  /// In en, this message translates to:
  /// **'Realistic'**
  String get styleRealistic;

  /// Background section title
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get backgroundTitle;

  /// Background - Transparent
  ///
  /// In en, this message translates to:
  /// **'Transparent'**
  String get bgTransparent;

  /// Background - White
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get bgWhite;

  /// Background - Gradient
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get bgGradient;

  /// AI sticker generation not implemented message
  ///
  /// In en, this message translates to:
  /// **'AI sticker generation feature coming soon! 🎨'**
  String get stickerComingSoon;

  /// Walk screen title
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walkTitle;

  /// Today's steps title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Steps'**
  String get todaySteps;

  /// Steps unit
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get stepsUnit;

  /// Walking guide title
  ///
  /// In en, this message translates to:
  /// **'Walking Guide'**
  String get walkGuideTitle;

  /// Walking guide - auto recording
  ///
  /// In en, this message translates to:
  /// **'Your steps are automatically recorded when you walk with your phone'**
  String get guideAutoRecording;

  /// Walking guide - treat reward
  ///
  /// In en, this message translates to:
  /// **'Earn 1 treat for every 300 steps'**
  String get guideTreatReward;

  /// Walking guide - happiness increase
  ///
  /// In en, this message translates to:
  /// **'Your pet\'s happiness increases as you walk'**
  String get guideHappinessIncrease;

  /// Walking guide - mission reward
  ///
  /// In en, this message translates to:
  /// **'Complete missions to receive additional rewards'**
  String get guideMissionReward;

  /// Coming soon features title
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoonTitle;

  /// Feature - GPS tracking
  ///
  /// In en, this message translates to:
  /// **'Real-time GPS Tracking'**
  String get featureGPSTracking;

  /// Feature - walk history
  ///
  /// In en, this message translates to:
  /// **'Walk History & Records'**
  String get featureWalkHistory;

  /// Feature - outdoor bonus
  ///
  /// In en, this message translates to:
  /// **'Outdoor Bonus System'**
  String get featureOutdoorBonus;

  /// Feature - mission progress
  ///
  /// In en, this message translates to:
  /// **'Mission Progress During Walk'**
  String get featureMissionProgress;

  /// Feature - statistics
  ///
  /// In en, this message translates to:
  /// **'Walk Statistics & Graphs'**
  String get featureStatistics;

  /// Badge - Week 3
  ///
  /// In en, this message translates to:
  /// **'Week 3'**
  String get badgeWeek3;

  /// Badge - Week 4
  ///
  /// In en, this message translates to:
  /// **'Week 4'**
  String get badgeWeek4;

  /// Achievements section title
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get achievementsTitle;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Empty state - first badge prompt
  ///
  /// In en, this message translates to:
  /// **'Earn your first badge!'**
  String get firstBadgePrompt;

  /// Empty state - walking hint
  ///
  /// In en, this message translates to:
  /// **'Start walking to earn badges'**
  String get badgesWalkHint;

  /// Badge load error message
  ///
  /// In en, this message translates to:
  /// **'Unable to load badges'**
  String get badgesLoadError;

  /// Settings load error message
  ///
  /// In en, this message translates to:
  /// **'Unable to load settings: {error}'**
  String settingsLoadError(String error);

  /// Notification time setting hint
  ///
  /// In en, this message translates to:
  /// **'Tap to change morning and evening notification times'**
  String get notificationTimeHint;

  /// Morning notification label
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get notificationMorning;

  /// Evening notification label
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get notificationEvening;

  /// Notification enabled confirmation
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationEnabled;

  /// Notification disabled confirmation
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationDisabled;

  /// Notification permission denied message
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. Please allow in device settings.'**
  String get notificationPermissionDenied;

  /// Notification time update error message
  ///
  /// In en, this message translates to:
  /// **'Error updating notification time'**
  String get notificationTimeUpdateError;

  /// Morning walk notification title
  ///
  /// In en, this message translates to:
  /// **'Time for a walk!'**
  String get notificationMorningTitle;

  /// Morning walk notification body
  ///
  /// In en, this message translates to:
  /// **'Start a healthy walk today!'**
  String get notificationMorningBody;

  /// Evening walk notification title
  ///
  /// In en, this message translates to:
  /// **'Have you walked today?'**
  String get notificationEveningTitle;

  /// Evening walk notification body
  ///
  /// In en, this message translates to:
  /// **'There\'s still time. Start your walk!'**
  String get notificationEveningBody;

  /// Mission expiry notification title
  ///
  /// In en, this message translates to:
  /// **'You have incomplete missions!'**
  String get notificationMissionTitle;

  /// Mission expiry notification body
  ///
  /// In en, this message translates to:
  /// **'Today\'s missions expire in 3 hours. Check them now!'**
  String get notificationMissionBody;

  /// Low happiness notification title
  ///
  /// In en, this message translates to:
  /// **'{petName} is feeling sad 😢'**
  String notificationLowHappinessTitle(String petName);

  /// Low happiness notification body
  ///
  /// In en, this message translates to:
  /// **'Happiness dropped to {happiness}%. Go for a walk or give treats!'**
  String notificationLowHappinessBody(int happiness);

  /// Notification types info text
  ///
  /// In en, this message translates to:
  /// **'Walk reminders (AM/PM)  |  Mission expiry  |  Low happiness alert'**
  String get notificationTypesInfo;

  /// Language change error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred while changing language: {error}'**
  String languageChangeError(String error);

  /// Badge collection screen title
  ///
  /// In en, this message translates to:
  /// **'Badge Collection'**
  String get badgesCollectionTitle;

  /// Badge collection status title
  ///
  /// In en, this message translates to:
  /// **'Badge Collection Status'**
  String get badgesCollectionStatus;

  /// Number of badges achieved
  ///
  /// In en, this message translates to:
  /// **'{unlockedCount} / {totalCount} achieved'**
  String badgesAchieved(int unlockedCount, int totalCount);

  /// Achievement unlock date
  ///
  /// In en, this message translates to:
  /// **'Unlocked: {date}'**
  String achievementUnlockedDate(String date);

  /// Message when no badges
  ///
  /// In en, this message translates to:
  /// **'No badges yet'**
  String get noBadgesYet;

  /// First badge acquisition guide
  ///
  /// In en, this message translates to:
  /// **'Start walking to earn your first badge!'**
  String get startWalkingForFirstBadge;

  /// Retry guidance message
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get tryAgainLater;

  /// Bronze tier
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get tierBronze;

  /// Silver tier
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get tierSilver;

  /// Gold tier
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get tierGold;

  /// Platinum tier
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get tierPlatinum;

  /// Welcome screen headline
  ///
  /// In en, this message translates to:
  /// **'Walk together with\nyour virtual pet!'**
  String get welcomeHeadline;

  /// Step tracking feature title
  ///
  /// In en, this message translates to:
  /// **'Step Tracking'**
  String get featureStepTrackingTitle;

  /// Step tracking feature description
  ///
  /// In en, this message translates to:
  /// **'Your pet gets happier with every walk'**
  String get featureStepTrackingDesc;

  /// Reward system feature title
  ///
  /// In en, this message translates to:
  /// **'Reward System'**
  String get featureRewardSystemTitle;

  /// Reward system feature description
  ///
  /// In en, this message translates to:
  /// **'Earn treats and badges based on your steps'**
  String get featureRewardSystemDesc;

  /// AI chat feature title
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get featureAiChatTitle;

  /// AI chat feature description
  ///
  /// In en, this message translates to:
  /// **'Chat and connect with your pet in real-time'**
  String get featureAiChatDesc;

  /// Load existing pet button
  ///
  /// In en, this message translates to:
  /// **'Load Existing Pet'**
  String get loadExistingPet;

  /// Mission completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get missionCompleted;

  /// Mission progress label
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get missionProgress;

  /// Treats count
  ///
  /// In en, this message translates to:
  /// **'{count} treats'**
  String missionTreatsCount(int count);

  /// Treats label
  ///
  /// In en, this message translates to:
  /// **'Treats'**
  String get missionTreatsLabel;

  /// Happiness label
  ///
  /// In en, this message translates to:
  /// **'Happiness'**
  String get missionHappinessLabel;

  /// Mission expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get missionExpired;

  /// Mission days remaining
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String missionDaysRemaining(int days);

  /// Mission hours remaining
  ///
  /// In en, this message translates to:
  /// **'{hours} hours left'**
  String missionHoursRemaining(int hours);

  /// Mission minutes remaining
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String missionMinutesRemaining(int minutes);

  /// Steps unit
  ///
  /// In en, this message translates to:
  /// **'{steps} steps'**
  String missionStepsUnit(int steps);

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String missionMinutesUnit(int minutes);

  /// Mission completion notification title
  ///
  /// In en, this message translates to:
  /// **'Mission Complete!'**
  String get missionComplete;

  /// Today's missions title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Missions'**
  String get todaysMissions;

  /// Indicates more items available
  ///
  /// In en, this message translates to:
  /// **'{count} more available'**
  String moreAvailable(int count);

  /// Error message when missions cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Cannot load missions'**
  String get cannotLoadMissions;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'New missions coming soon!'**
  String get newMissionsComingSoon;

  /// Missions title
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// Steps unit label
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get stepsUnitLabel;

  /// Minutes unit label
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesUnitLabel;

  /// Rewards earned title
  ///
  /// In en, this message translates to:
  /// **'Rewards Earned'**
  String get rewardsEarned;

  /// Today's activity title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get todaysActivity;

  /// Goal achieved message
  ///
  /// In en, this message translates to:
  /// **'Goal Achieved! 🎉'**
  String get goalAchieved;

  /// Steps remaining to goal
  ///
  /// In en, this message translates to:
  /// **'{steps} steps to goal'**
  String stepsToGoal(int steps);

  /// Distance label
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// Active time label
  ///
  /// In en, this message translates to:
  /// **'Active Time'**
  String get activeTime;

  /// Loading step data message
  ///
  /// In en, this message translates to:
  /// **'Loading step data...'**
  String get loadingSteps;

  /// Cannot load step data error message
  ///
  /// In en, this message translates to:
  /// **'Cannot load step data'**
  String get cannotLoadSteps;

  /// Activity permission check message
  ///
  /// In en, this message translates to:
  /// **'Please check activity permissions in Settings'**
  String get checkActivityPermissions;

  /// Tracking state - monitoring
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get trackingStateMonitoring;

  /// Tracking state - walking
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get trackingStateWalking;

  /// Tracking state - stopped
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get trackingStateStopped;

  /// Tracking state - error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get trackingStateError;

  /// Streak message for 0 days
  ///
  /// In en, this message translates to:
  /// **'Start walking today and build your streak!'**
  String get streakMessageZero;

  /// Streak message for 1 day
  ///
  /// In en, this message translates to:
  /// **'Great start! Keep it up tomorrow! 💪'**
  String get streakMessageOne;

  /// Streak message for active streak under 7 days
  ///
  /// In en, this message translates to:
  /// **'You\'ve achieved {days} days in a row! {remaining} days until a week!'**
  String streakMessageActive(int days, int remaining);

  /// Streak message for long streak (7+ days)
  ///
  /// In en, this message translates to:
  /// **'Wow! {days} days in a row! Amazing! 🎊'**
  String streakMessageLong(int days);

  /// Weekly activity title
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// Last 7 days label
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// Chart tooltip total steps
  ///
  /// In en, this message translates to:
  /// **'Total: {steps} steps'**
  String chartTooltipTotal(int steps);

  /// Chart tooltip app walk steps
  ///
  /// In en, this message translates to:
  /// **'App walk: {steps} steps'**
  String chartTooltipAppWalk(int steps);

  /// Average label
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// Maximum/peak label
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// Cannot load data error message
  ///
  /// In en, this message translates to:
  /// **'Cannot load data'**
  String get cannotLoadData;

  /// No records yet message
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get noRecordsYet;

  /// Monday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// Tuesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// Wednesday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// Thursday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// Friday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// Saturday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// Sunday abbreviation
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// Monthly trend title
  ///
  /// In en, this message translates to:
  /// **'Monthly Trend'**
  String get monthlyTrend;

  /// Last 30 days label
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// Total steps label
  ///
  /// In en, this message translates to:
  /// **'Total Steps'**
  String get totalSteps;

  /// Daily average label
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// Dog bark fallback message
  ///
  /// In en, this message translates to:
  /// **'Woof! Bark!'**
  String get dogBark;

  /// Loading dog information message
  ///
  /// In en, this message translates to:
  /// **'Loading dog information...'**
  String get loadingDogInfo;

  /// GPS status title
  ///
  /// In en, this message translates to:
  /// **'GPS Status'**
  String get gpsStatus;

  /// GPS tracking active
  ///
  /// In en, this message translates to:
  /// **'GPS Tracking'**
  String get gpsTracking;

  /// GPS waiting
  ///
  /// In en, this message translates to:
  /// **'GPS Standby'**
  String get gpsWaiting;

  /// Indoor mode
  ///
  /// In en, this message translates to:
  /// **'Indoor Mode'**
  String get indoorMode;

  /// Detecting status
  ///
  /// In en, this message translates to:
  /// **'Detecting...'**
  String get detecting;

  /// Error status
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorStatus;

  /// Searching for GPS signal
  ///
  /// In en, this message translates to:
  /// **'Searching for GPS signal...'**
  String get searchingGpsSignal;

  /// Location samples label
  ///
  /// In en, this message translates to:
  /// **'Location Samples'**
  String get locationSamples;

  /// Count items
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String countItems(int count);

  /// Outdoor signals label
  ///
  /// In en, this message translates to:
  /// **'Outdoor Signals'**
  String get outdoorSignals;

  /// Outdoor ratio label
  ///
  /// In en, this message translates to:
  /// **'Outdoor Ratio'**
  String get outdoorRatio;

  /// Double bonus applied message
  ///
  /// In en, this message translates to:
  /// **'2x Bonus Applied!'**
  String get doubleBonusApplied;

  /// Outdoor bonus requirement message
  ///
  /// In en, this message translates to:
  /// **'2x bonus for 50%+ outdoor'**
  String get outdoorBonusRequirement;

  /// Location permission request error
  ///
  /// In en, this message translates to:
  /// **'Error requesting location permission: {error}'**
  String locationPermissionError(String error);

  /// GPS outdoor mode
  ///
  /// In en, this message translates to:
  /// **'GPS Outdoor Mode'**
  String get gpsOutdoorMode;

  /// Location permission granted
  ///
  /// In en, this message translates to:
  /// **'Location Permission Granted'**
  String get locationPermissionGranted;

  /// Location permission granted description
  ///
  /// In en, this message translates to:
  /// **'GPS can automatically detect outdoor walks and earn bonus rewards.'**
  String get locationPermissionGrantedDesc;

  /// Location permission required
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionRequired;

  /// Location permission required description
  ///
  /// In en, this message translates to:
  /// **'Location permission is required for outdoor walk detection and bonus rewards.'**
  String get locationPermissionRequiredDesc;

  /// Location permission denied
  ///
  /// In en, this message translates to:
  /// **'Location Permission Denied'**
  String get locationPermissionDenied;

  /// Location permission denied description
  ///
  /// In en, this message translates to:
  /// **'Please allow location permission in Settings.'**
  String get locationPermissionDeniedDesc;

  /// Checking permission status
  ///
  /// In en, this message translates to:
  /// **'Checking permission status...'**
  String get checkingPermissionStatus;

  /// Outdoor mode benefits title
  ///
  /// In en, this message translates to:
  /// **'Outdoor Mode Benefits'**
  String get outdoorModeBenefits;

  /// Double reward
  ///
  /// In en, this message translates to:
  /// **'2x Rewards'**
  String get doubleReward;

  /// Double reward description
  ///
  /// In en, this message translates to:
  /// **'Get double treats and happiness during outdoor walks'**
  String get doubleRewardDesc;

  /// Accurate distance tracking
  ///
  /// In en, this message translates to:
  /// **'Accurate Distance Tracking'**
  String get accurateDistanceTracking;

  /// Accurate distance tracking description
  ///
  /// In en, this message translates to:
  /// **'Precisely measure actual distance and speed with GPS'**
  String get accurateDistanceTrackingDesc;

  /// Special badges
  ///
  /// In en, this message translates to:
  /// **'Special Badges'**
  String get specialBadges;

  /// Special badges description
  ///
  /// In en, this message translates to:
  /// **'Unlock exclusive outdoor walk badges and achievements'**
  String get specialBadgesDesc;

  /// Refresh permission status button
  ///
  /// In en, this message translates to:
  /// **'Refresh Permission Status'**
  String get refreshPermissionStatus;

  /// Allow permission in settings button
  ///
  /// In en, this message translates to:
  /// **'Allow Permission in Settings'**
  String get allowPermissionInSettings;

  /// Requesting permission message
  ///
  /// In en, this message translates to:
  /// **'Requesting permission...'**
  String get requestingPermission;

  /// Activate GPS outdoor mode button
  ///
  /// In en, this message translates to:
  /// **'Activate GPS Outdoor Mode'**
  String get activateGpsOutdoorMode;

  /// Daily mission tab label
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly mission tab label
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Empty state message for daily missions
  ///
  /// In en, this message translates to:
  /// **'No daily missions today'**
  String get noDailyMissions;

  /// Error message when daily missions fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading daily missions'**
  String get errorLoadingDailyMissions;

  /// Empty state message for weekly missions
  ///
  /// In en, this message translates to:
  /// **'No missions this week'**
  String get noWeeklyMissions;

  /// Empty state subtitle for weekly missions
  ///
  /// In en, this message translates to:
  /// **'New weekly missions coming soon!'**
  String get newWeeklyMissionsComingSoon;

  /// Error message when weekly missions fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading weekly missions'**
  String get errorLoadingWeeklyMissions;

  /// Empty state message for completed missions
  ///
  /// In en, this message translates to:
  /// **'No completed missions'**
  String get noCompletedMissions;

  /// Empty state subtitle for completed missions
  ///
  /// In en, this message translates to:
  /// **'Complete missions to get rewards!'**
  String get completeToGetRewards;

  /// Error message when completed missions fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading completed missions'**
  String get errorLoadingCompletedMissions;

  /// Loading message for missions
  ///
  /// In en, this message translates to:
  /// **'Loading missions...'**
  String get loadingMissions;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Daily mission type label
  ///
  /// In en, this message translates to:
  /// **'Daily Mission'**
  String get dailyMissionType;

  /// Weekly mission type label
  ///
  /// In en, this message translates to:
  /// **'Weekly Mission'**
  String get weeklyMissionType;

  /// Special mission type label
  ///
  /// In en, this message translates to:
  /// **'Special Mission'**
  String get specialMissionType;

  /// Rewards section label
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsLabel;

  /// Target section label
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get targetLabel;

  /// Progress percentage label
  ///
  /// In en, this message translates to:
  /// **'{percent}% Complete'**
  String percentComplete(int percent);

  /// Mission information section title
  ///
  /// In en, this message translates to:
  /// **'Mission Info'**
  String get missionInfoTitle;

  /// Mission expiry time label
  ///
  /// In en, this message translates to:
  /// **'Expiry Time'**
  String get expiryTime;

  /// Mission remaining time label
  ///
  /// In en, this message translates to:
  /// **'Remaining Time'**
  String get remainingTime;

  /// Mission completion time label
  ///
  /// In en, this message translates to:
  /// **'Completion Time'**
  String get completionTime;

  /// Days unit label
  ///
  /// In en, this message translates to:
  /// **'day(s)'**
  String get daysUnit;

  /// Hours unit label
  ///
  /// In en, this message translates to:
  /// **'hour(s)'**
  String get hoursUnit;

  /// Badge achievement notification title
  ///
  /// In en, this message translates to:
  /// **'Badge Achieved!'**
  String get badgeAchieved;

  /// Pet creation coming soon message
  ///
  /// In en, this message translates to:
  /// **'Pet creation screen coming soon!'**
  String get petCreationComingSoon;

  /// Pet loading coming soon message
  ///
  /// In en, this message translates to:
  /// **'Pet loading feature coming soon!'**
  String get petLoadingComingSoon;

  /// Daily steps mission title
  ///
  /// In en, this message translates to:
  /// **'Daily Step Goal'**
  String get missionDailyStepsTitle;

  /// Daily steps mission description
  ///
  /// In en, this message translates to:
  /// **'Walk {steps} steps'**
  String missionDailyStepsDescription(int steps);

  /// Weekly steps mission title
  ///
  /// In en, this message translates to:
  /// **'Weekly Steps Challenge'**
  String get missionWeeklyStepsTitle;

  /// Weekly steps mission description
  ///
  /// In en, this message translates to:
  /// **'Walk {steps} steps'**
  String missionWeeklyStepsDescription(int steps);

  /// Active week mission title
  ///
  /// In en, this message translates to:
  /// **'Active Week'**
  String get missionActiveWeekTitle;

  /// Active week mission description
  ///
  /// In en, this message translates to:
  /// **'Walk for 180 minutes total'**
  String get missionActiveWeekDescription;

  /// Quick walk mission title
  ///
  /// In en, this message translates to:
  /// **'Quick Walk'**
  String get missionQuickWalkTitle;

  /// Quick walk mission description
  ///
  /// In en, this message translates to:
  /// **'Walk for 30 minutes continuously'**
  String get missionQuickWalkDescription;

  /// Distance challenge mission title
  ///
  /// In en, this message translates to:
  /// **'Distance Challenge'**
  String get missionDistanceChallengeTitle;

  /// Early achievement mission title
  ///
  /// In en, this message translates to:
  /// **'Early Achiever'**
  String get missionEarlyAchievementTitle;

  /// Consistent exercise mission title
  ///
  /// In en, this message translates to:
  /// **'Consistent Exercise'**
  String get missionConsistentExerciseTitle;

  /// Distance challenge mission description
  ///
  /// In en, this message translates to:
  /// **'Walk more than 2km'**
  String get missionDistanceChallengeDescription;

  /// Early achievement mission description
  ///
  /// In en, this message translates to:
  /// **'Achieve 3000 steps early'**
  String get missionEarlyAchievementDescription;

  /// Consistent exercise mission description
  ///
  /// In en, this message translates to:
  /// **'Stay active for 45 minutes'**
  String get missionConsistentExerciseDescription;

  /// First walk achievement title
  ///
  /// In en, this message translates to:
  /// **'First Walk'**
  String get achievementFirstWalkTitle;

  /// First walk achievement description
  ///
  /// In en, this message translates to:
  /// **'Completed your first walk!'**
  String get achievementFirstWalkDescription;

  /// 1,000 steps achievement title
  ///
  /// In en, this message translates to:
  /// **'1,000 Steps'**
  String get achievementSteps1kTitle;

  /// 1,000 steps achievement description
  ///
  /// In en, this message translates to:
  /// **'Reached 1,000 cumulative steps!'**
  String get achievementSteps1kDescription;

  /// 5,000 steps achievement title
  ///
  /// In en, this message translates to:
  /// **'5,000 Steps'**
  String get achievementSteps5kTitle;

  /// 5,000 steps achievement description
  ///
  /// In en, this message translates to:
  /// **'Reached 5,000 cumulative steps!'**
  String get achievementSteps5kDescription;

  /// 10,000 steps achievement title
  ///
  /// In en, this message translates to:
  /// **'10,000 Steps'**
  String get achievementSteps10kTitle;

  /// 10,000 steps achievement description
  ///
  /// In en, this message translates to:
  /// **'Reached 10,000 cumulative steps!'**
  String get achievementSteps10kDescription;

  /// 3-day streak achievement title
  ///
  /// In en, this message translates to:
  /// **'3-Day Streak'**
  String get achievementStreak3Title;

  /// 3-day streak achievement description
  ///
  /// In en, this message translates to:
  /// **'Walked for 3 days in a row!'**
  String get achievementStreak3Description;

  /// 7-day streak achievement title
  ///
  /// In en, this message translates to:
  /// **'1-Week Streak'**
  String get achievementStreak7Title;

  /// 7-day streak achievement description
  ///
  /// In en, this message translates to:
  /// **'Walked for 7 days in a row!'**
  String get achievementStreak7Description;

  /// First outdoor walk achievement title
  ///
  /// In en, this message translates to:
  /// **'First Outdoor Walk'**
  String get achievementOutdoorFirstTitle;

  /// First outdoor walk achievement description
  ///
  /// In en, this message translates to:
  /// **'Completed your first outdoor walk!'**
  String get achievementOutdoorFirstDescription;

  /// Max happiness achievement title
  ///
  /// In en, this message translates to:
  /// **'Maximum Happiness'**
  String get achievementHappy100Title;

  /// Max happiness achievement description
  ///
  /// In en, this message translates to:
  /// **'Reached happiness level 100!'**
  String get achievementHappy100Description;

  /// 100 treats achievement title
  ///
  /// In en, this message translates to:
  /// **'Treat Collector'**
  String get achievementTreats100Title;

  /// 100 treats achievement description
  ///
  /// In en, this message translates to:
  /// **'Collected 100 treats!'**
  String get achievementTreats100Description;

  /// 1km distance achievement title
  ///
  /// In en, this message translates to:
  /// **'1km Achievement'**
  String get achievementDistance1kmTitle;

  /// 1km distance achievement description
  ///
  /// In en, this message translates to:
  /// **'Walked 1km in total!'**
  String get achievementDistance1kmDescription;

  /// Elapsed time label on walk screen
  ///
  /// In en, this message translates to:
  /// **'Elapsed Time'**
  String get walkScreenElapsedTime;

  /// Session steps label on walk screen
  ///
  /// In en, this message translates to:
  /// **'Session Steps'**
  String get walkScreenSessionSteps;

  /// Outdoor badge label on walk screen
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get walkScreenOutdoorBadge;

  /// Indoor badge label on walk screen
  ///
  /// In en, this message translates to:
  /// **'Indoor'**
  String get walkScreenIndoorBadge;

  /// Motivational message during walk
  ///
  /// In en, this message translates to:
  /// **'Keep going! Every step earns rewards!'**
  String get walkScreenMotivation;

  /// Prompt to start walking
  ///
  /// In en, this message translates to:
  /// **'Ready to walk? Choose your mode!'**
  String get walkScreenStartPrompt;

  /// All missions completed message
  ///
  /// In en, this message translates to:
  /// **'All missions completed!'**
  String get walkScreenAllMissionsDone;

  /// Help screen title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpScreenTitle;

  /// Getting started section title
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get helpGettingStarted;

  /// Getting started content
  ///
  /// In en, this message translates to:
  /// **'WalkDog is an app that makes walking with your dog more fun. When you start a walk, your steps are automatically tracked and you can give treats and happiness to your virtual pet.'**
  String get helpGettingStartedContent;

  /// How to walk section title
  ///
  /// In en, this message translates to:
  /// **'How to Walk'**
  String get helpHowToWalk;

  /// How to walk content
  ///
  /// In en, this message translates to:
  /// **'1. Tap \'Indoor\' or \'Outdoor\' on the home screen or walk tab to start a walk.\n2. Outdoor walks activate GPS for bonus rewards.\n3. During the walk, your steps and time are shown in real-time.\n4. When you end the walk, rewards are automatically calculated.'**
  String get helpHowToWalkContent;

  /// Rewards section title
  ///
  /// In en, this message translates to:
  /// **'Reward System'**
  String get helpRewards;

  /// Rewards content
  ///
  /// In en, this message translates to:
  /// **'Walking earns treats and happiness points based on your steps. Use these rewards to level up your virtual pet and unlock new achievements. Outdoor walks earn 1.5x bonus rewards.'**
  String get helpRewardsContent;

  /// Missions section title
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get helpMissions;

  /// Missions content
  ///
  /// In en, this message translates to:
  /// **'New missions are generated daily. Complete various missions like reaching your daily step goal or maintaining a walking streak to earn extra rewards.'**
  String get helpMissionsContent;

  /// Achievements section title
  ///
  /// In en, this message translates to:
  /// **'Achievements & Badges'**
  String get helpAchievements;

  /// Achievements content
  ///
  /// In en, this message translates to:
  /// **'Earn badges by reaching special milestones. There are Bronze, Silver, Gold, and Platinum tier badges. Check your badge collection in Settings.'**
  String get helpAchievementsContent;

  /// AI features section title
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get helpAIFeatures;

  /// AI features content
  ///
  /// In en, this message translates to:
  /// **'The app includes AI-powered conversation features. Your pet will chat based on walking situations, and AI image generation can create pet stickers. You can toggle local AI and cloud image generation in Settings.'**
  String get helpAIFeaturesContent;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get helpContact;

  /// Contact content
  ///
  /// In en, this message translates to:
  /// **'If you encounter any issues or have suggestions, please contact the development team through Settings > App Info.'**
  String get helpContactContent;

  /// Privacy policy screen title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyScreenTitle;

  /// Privacy policy effective date
  ///
  /// In en, this message translates to:
  /// **'Effective Date: January 1, 2025'**
  String get privacyEffectiveDate;

  /// Privacy overview section title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get privacyOverview;

  /// Privacy overview content
  ///
  /// In en, this message translates to:
  /// **'WalkDog (the \'App\') values your privacy and protects personal information in accordance with applicable laws. This policy explains what information we collect and how we use it.'**
  String get privacyOverviewContent;

  /// Data collection section title
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacyDataCollection;

  /// Data collection content
  ///
  /// In en, this message translates to:
  /// **'• Step Data: Collected through the pedometer sensor.\n• Location Data: Collected via GPS during outdoor walks only. Not collected in indoor mode.\n• Account Info: Only minimal information required for login (email, nickname).\n• Pet Data: Virtual pet game data including level, experience, and happiness.'**
  String get privacyDataCollectionContent;

  /// Data usage section title
  ///
  /// In en, this message translates to:
  /// **'How We Use Information'**
  String get privacyDataUsage;

  /// Data usage content
  ///
  /// In en, this message translates to:
  /// **'• Walk tracking and reward calculation\n• Game progress saving and synchronization\n• Mission and achievement system operation\n• AI-powered pet conversations and image generation\n• App service improvement and bug fixes'**
  String get privacyDataUsageContent;

  /// Data storage section title
  ///
  /// In en, this message translates to:
  /// **'Data Storage & Security'**
  String get privacyDataStorage;

  /// Data storage content
  ///
  /// In en, this message translates to:
  /// **'User data is securely stored in Firebase Cloud. Some data is stored locally on your device for offline use. All data transfers are encrypted.'**
  String get privacyDataStorageContent;

  /// Third party services section title
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get privacyThirdParty;

  /// Third party services content
  ///
  /// In en, this message translates to:
  /// **'• Firebase (Google): Authentication, data storage, cloud functions\n• AI Image Generation: Pet sticker creation (optional)\n• These services are governed by their respective privacy policies.'**
  String get privacyThirdPartyContent;

  /// User rights section title
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacyUserRights;

  /// User rights content
  ///
  /// In en, this message translates to:
  /// **'You can request access, modification, or deletion of your data at any time. All personal data is permanently deleted upon account deletion. Location and notification permissions can be managed in your device settings.'**
  String get privacyUserRightsContent;

  /// Policy changes section title
  ///
  /// In en, this message translates to:
  /// **'Policy Changes'**
  String get privacyChanges;

  /// Policy changes content
  ///
  /// In en, this message translates to:
  /// **'This privacy policy may be updated. Significant changes will be communicated through in-app notifications.'**
  String get privacyChangesContent;

  /// Paywall screen title
  ///
  /// In en, this message translates to:
  /// **'Premium Subscription'**
  String get paywallTitle;

  /// Paywall header title
  ///
  /// In en, this message translates to:
  /// **'WalkDog Premium'**
  String get paywallHeaderTitle;

  /// Paywall header subtitle
  ///
  /// In en, this message translates to:
  /// **'Enjoy high-quality AI images and more benefits'**
  String get paywallHeaderSubtitle;

  /// Premium benefit - image quality
  ///
  /// In en, this message translates to:
  /// **'High-quality AI images (Gemini)'**
  String get paywallBenefitQuality;

  /// Premium benefit - quota
  ///
  /// In en, this message translates to:
  /// **'5 images per day'**
  String get paywallBenefitQuota;

  /// Premium benefit - no ads
  ///
  /// In en, this message translates to:
  /// **'Ad-free experience'**
  String get paywallBenefitAds;

  /// Premium benefit - speed
  ///
  /// In en, this message translates to:
  /// **'Faster generation speed'**
  String get paywallBenefitSpeed;

  /// Per month label
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get paywallPricePerMonth;

  /// Subscribe button
  ///
  /// In en, this message translates to:
  /// **'Start Subscription'**
  String get paywallSubscribeButton;

  /// Restore purchases button
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get paywallRestoreButton;

  /// Terms and conditions note
  ///
  /// In en, this message translates to:
  /// **'You can cancel your subscription anytime. Payment is processed through your Apple/Google account.'**
  String get paywallTermsNote;

  /// Subscription success message
  ///
  /// In en, this message translates to:
  /// **'Premium subscription activated!'**
  String get paywallSuccess;

  /// Store not configured message
  ///
  /// In en, this message translates to:
  /// **'Available after store account setup'**
  String get paywallNotConfigured;

  /// Product not found message
  ///
  /// In en, this message translates to:
  /// **'Unable to load product information'**
  String get paywallProductNotFound;

  /// No subscription to restore message
  ///
  /// In en, this message translates to:
  /// **'No subscription to restore'**
  String get paywallRestoreNotFound;

  /// Subscription settings section title
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionSection;

  /// Premium settings title
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// Premium active subtitle
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get premiumActiveSubtitle;

  /// Premium inactive subtitle
  ///
  /// In en, this message translates to:
  /// **'Upgrade for high-quality AI images'**
  String get premiumInactiveSubtitle;

  /// Premium active badge text
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get premiumActiveBadge;

  /// Sticker generate button loading state
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get stickerGenerating;

  /// Cached sticker header label
  ///
  /// In en, this message translates to:
  /// **'Cached Sticker'**
  String get stickerCached;

  /// New sticker header label
  ///
  /// In en, this message translates to:
  /// **'New Sticker'**
  String get stickerNew;

  /// Apply button loading state
  ///
  /// In en, this message translates to:
  /// **'Applying...'**
  String get stickerApplying;

  /// Apply sticker button text
  ///
  /// In en, this message translates to:
  /// **'Apply This Sticker'**
  String get stickerApplyButton;

  /// Sticker loading overlay message
  ///
  /// In en, this message translates to:
  /// **'Generating sticker...'**
  String get stickerLoadingMessage;

  /// Sticker loading time hint
  ///
  /// In en, this message translates to:
  /// **'Takes approximately 5-8 seconds'**
  String get stickerLoadingTime;

  /// Default error message in sticker area
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get stickerErrorDefault;

  /// Snackbar when sticker applied successfully
  ///
  /// In en, this message translates to:
  /// **'Sticker applied!'**
  String get stickerAppliedSuccess;

  /// Snackbar when sticker apply fails
  ///
  /// In en, this message translates to:
  /// **'Failed to apply sticker.'**
  String get stickerApplyFailed;

  /// Quota remaining today label
  ///
  /// In en, this message translates to:
  /// **'Remaining Today'**
  String get quotaRemainingToday;

  /// Quota reset timer label
  ///
  /// In en, this message translates to:
  /// **'Resets in {time}'**
  String quotaResetsIn(String time);

  /// Quota loading state
  ///
  /// In en, this message translates to:
  /// **'Checking quota...'**
  String get quotaChecking;

  /// Quota load error message
  ///
  /// In en, this message translates to:
  /// **'Cannot load quota information'**
  String get quotaLoadError;

  /// Tier quality badge label
  ///
  /// In en, this message translates to:
  /// **'{tierName} Quality'**
  String tierQualityLabel(String tierName);

  /// Premium upgrade banner title
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get premiumUpgradeTitle;

  /// Premium upgrade banner benefits list
  ///
  /// In en, this message translates to:
  /// **'• High-quality AI images (Gemini)\n• 5 generations per day\n• Ad-free experience\n• Faster generation speed'**
  String get premiumUpgradeBenefits;

  /// Premium upgrade banner button text
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get premiumUpgradeButton;

  /// Free tier display name
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get tierNameFree;

  /// Account settings section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// Sign in title
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Back up data and sync across devices'**
  String get signInSubtitle;

  /// Google sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Apple sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// Sign in success message
  ///
  /// In en, this message translates to:
  /// **'Sign in successful'**
  String get signInSuccess;

  /// Sign in failed message
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get signInFailed;

  /// Account connected status
  ///
  /// In en, this message translates to:
  /// **'Account connected'**
  String get accountConnected;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Sign out confirmation message
  ///
  /// In en, this message translates to:
  /// **'Signing out will switch to anonymous mode. Continue?'**
  String get signOutConfirm;

  /// Per-card hint: this mission counts total (Health) steps
  ///
  /// In en, this message translates to:
  /// **'Counts your total steps'**
  String get missionStepsMetricHint;

  /// Per-card hint: this mission counts in-app walk sessions
  ///
  /// In en, this message translates to:
  /// **'Counts your in-app walks'**
  String get missionWalkMetricHint;

  /// Header of the mission-complete celebration toast
  ///
  /// In en, this message translates to:
  /// **'🎉 Mission complete!'**
  String get missionCompleteCelebration;

  /// Celebration line showing the steps already achieved
  ///
  /// In en, this message translates to:
  /// **'Already {steps} steps!'**
  String missionAchievedSteps(String steps);

  /// Speech bubble from the newly created pet on the permission priming screen
  ///
  /// In en, this message translates to:
  /// **'Let\'s walk together!'**
  String get permissionPrimingBubble;

  /// Title of the permission priming screen
  ///
  /// In en, this message translates to:
  /// **'Two quick things\nbefore our first walk'**
  String get permissionPrimingTitle;

  /// Title of the step permission card
  ///
  /// In en, this message translates to:
  /// **'Step tracking'**
  String get permissionStepsTitle;

  /// Description of the step permission card
  ///
  /// In en, this message translates to:
  /// **'Every step you take makes {petName} happier and helps them grow'**
  String permissionStepsDesc(String petName);

  /// Badge on the step permission card
  ///
  /// In en, this message translates to:
  /// **'Health Connect · read-only'**
  String get permissionStepsBadge;

  /// Title of the notification permission card
  ///
  /// In en, this message translates to:
  /// **'Walk reminders'**
  String get permissionNotifTitle;

  /// Description of the notification permission card
  ///
  /// In en, this message translates to:
  /// **'A gentle nudge when it\'s a great time for a walk'**
  String get permissionNotifDesc;

  /// Badge on the notification permission card
  ///
  /// In en, this message translates to:
  /// **'1–2 a day'**
  String get permissionNotifBadge;

  /// Privacy microcopy on the permission priming screen
  ///
  /// In en, this message translates to:
  /// **'Step data never leaves your phone'**
  String get permissionPrivacyNote;

  /// Primary CTA that triggers the OS permission dialogs
  ///
  /// In en, this message translates to:
  /// **'Let\'s walk! 🐾'**
  String get permissionPrimingCta;

  /// Skip link on the permission priming screen
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get permissionPrimingSkip;

  /// Home steps card subtitle when health permission is missing
  ///
  /// In en, this message translates to:
  /// **'Activity permission is off'**
  String get stepPermissionOffDesc;

  /// Button label to (re)request the step/health permission
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get stepPermissionEnableCta;

  /// Snackbar shown after the step permission is granted
  ///
  /// In en, this message translates to:
  /// **'Step tracking is on! 🎉'**
  String get stepPermissionGranted;

  /// Snackbar when the in-app request is blocked and the user must use OS settings
  ///
  /// In en, this message translates to:
  /// **'Turn on the activity (steps) permission in Settings'**
  String get stepPermissionDeniedHint;

  /// Snackbar action that opens the OS app settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Settings section header for permissions/linking
  ///
  /// In en, this message translates to:
  /// **'Permissions & linking'**
  String get stepLinkSectionTitle;

  /// Settings tile title for the step/health link
  ///
  /// In en, this message translates to:
  /// **'Step tracking'**
  String get stepLinkTitle;

  /// Settings tile subtitle when step permission is granted
  ///
  /// In en, this message translates to:
  /// **'Connected to health data'**
  String get stepLinkConnectedSubtitle;

  /// Settings tile subtitle when step permission is missing
  ///
  /// In en, this message translates to:
  /// **'Not connected — tap to turn on'**
  String get stepLinkDisconnectedSubtitle;

  /// Snackbar when tapping the step link tile while already connected
  ///
  /// In en, this message translates to:
  /// **'Already connected'**
  String get stepLinkAlreadyConnected;

  /// Dialog title when a free user runs out of daily image quota
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all your free images today'**
  String get outOfQuotaTitle;

  /// Dialog body offering a rewarded ad for one more image
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to create 1 more sticker today.'**
  String get outOfQuotaAdMessage;

  /// Button to watch a rewarded ad for one more image
  ///
  /// In en, this message translates to:
  /// **'Watch ad for +1'**
  String get outOfQuotaWatchAd;

  /// Button to open the paywall from the out-of-quota dialog
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get outOfQuotaUpgrade;

  /// Snackbar when a rewarded ad is not loaded yet
  ///
  /// In en, this message translates to:
  /// **'The ad isn\'t ready yet. Please try again in a moment.'**
  String get adNotReady;

  /// Out-of-quota sheet title, free user with ad bonus available
  ///
  /// In en, this message translates to:
  /// **'You\'ve used today\'s free stickers'**
  String get outOfQuotaFreeAdTitle;

  /// Out-of-quota sheet body, free user with ad bonus available
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to make one more'**
  String get outOfQuotaFreeAdBody;

  /// Remaining rewarded-ad bonus count caption
  ///
  /// In en, this message translates to:
  /// **'{count} more available via ads today'**
  String outOfQuotaAdRemaining(int count);

  /// Out-of-quota sheet title, free user fully maxed (no ads left)
  ///
  /// In en, this message translates to:
  /// **'You\'re out of stickers for today'**
  String get outOfQuotaMaxedTitle;

  /// Out-of-quota sheet title for premium users
  ///
  /// In en, this message translates to:
  /// **'All {count} made for today! 🐾'**
  String outOfQuotaPremiumTitle(int count);

  /// Out-of-quota sheet body for premium users
  ///
  /// In en, this message translates to:
  /// **'Refills in {time} — see you tomorrow!'**
  String outOfQuotaPremiumBody(String time);

  /// Premium upsell benefits one-liner
  ///
  /// In en, this message translates to:
  /// **'No ads · High quality · 5 per day'**
  String get outOfQuotaUpgradeBenefits;

  /// Link-account sheet title for premium users
  ///
  /// In en, this message translates to:
  /// **'Keep your Premium safe'**
  String get linkAccountTitlePremium;

  /// Link-account sheet body for premium users
  ///
  /// In en, this message translates to:
  /// **'Link an account so your Premium stays with you across reinstalls and new devices.'**
  String get linkAccountBodyPremium;

  /// Link-account sheet title for non-premium users
  ///
  /// In en, this message translates to:
  /// **'Link your account'**
  String get linkAccountTitleDefault;

  /// Link-account sheet body for non-premium users
  ///
  /// In en, this message translates to:
  /// **'Back up your data and continue on any device.'**
  String get linkAccountBodyDefault;

  /// Dismiss button on the link-account sheet
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get linkAccountLater;

  /// Settings account tile title shown to anonymous premium users
  ///
  /// In en, this message translates to:
  /// **'Protect your Premium'**
  String get protectPremiumTileTitle;

  /// Settings account tile subtitle shown to anonymous premium users
  ///
  /// In en, this message translates to:
  /// **'Link an account to keep it across devices'**
  String get protectPremiumTileSubtitle;

  /// Settings section title for AI disclosure and consent
  ///
  /// In en, this message translates to:
  /// **'AI features'**
  String get aiSectionTitle;

  /// Settings tile opening the AI disclosure sheet
  ///
  /// In en, this message translates to:
  /// **'About AI features'**
  String get aiDisclosureTileTitle;

  /// Settings tile subtitle for the AI disclosure sheet
  ///
  /// In en, this message translates to:
  /// **'See how this app uses AI'**
  String get aiDisclosureTileSubtitle;

  /// Title of the AI disclosure sheet
  ///
  /// In en, this message translates to:
  /// **'This service uses AI'**
  String get aiDisclosureTitle;

  /// Intro line of the AI disclosure sheet
  ///
  /// In en, this message translates to:
  /// **'The following WalkDog features are powered by generative artificial intelligence.'**
  String get aiDisclosureIntro;

  /// AI disclosure sheet: sticker feature heading
  ///
  /// In en, this message translates to:
  /// **'AI sticker generation'**
  String get aiDisclosureStickerTitle;

  /// AI disclosure sheet: sticker feature body
  ///
  /// In en, this message translates to:
  /// **'AI creates a new pet image from the breed, color and style you pick. These are not real photographs.'**
  String get aiDisclosureStickerBody;

  /// AI disclosure sheet: dialogue feature heading
  ///
  /// In en, this message translates to:
  /// **'Pet remarks'**
  String get aiDisclosureDialogueTitle;

  /// AI disclosure sheet: dialogue feature body
  ///
  /// In en, this message translates to:
  /// **'AI writes what your pet says after a walk, a treat and other moments. These lines are not written by a person.'**
  String get aiDisclosureDialogueBody;

  /// AI disclosure sheet: limitations heading
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get aiDisclosureLimitTitle;

  /// AI disclosure sheet: limitations body
  ///
  /// In en, this message translates to:
  /// **'AI output can be inaccurate or unexpected. Do not rely on it for medical or health decisions.'**
  String get aiDisclosureLimitBody;

  /// Close button on the AI disclosure sheet
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get aiDisclosureClose;

  /// Title of the third-party AI data sharing consent sheet
  ///
  /// In en, this message translates to:
  /// **'Allow AI features?'**
  String get aiConsentTitle;

  /// Intro line of the AI consent sheet
  ///
  /// In en, this message translates to:
  /// **'To create AI stickers and pet remarks, the information below is sent to external AI services.'**
  String get aiConsentIntro;

  /// AI consent sheet: shared data heading
  ///
  /// In en, this message translates to:
  /// **'What is sent'**
  String get aiConsentSentTitle;

  /// AI consent sheet: list of shared data
  ///
  /// In en, this message translates to:
  /// **'• Pet name, breed, color and style choices\n• Happiness level and walk/mission progress\n• Account identifier (UID)'**
  String get aiConsentSentItems;

  /// AI consent sheet: excluded data heading
  ///
  /// In en, this message translates to:
  /// **'What is never sent'**
  String get aiConsentNotSentTitle;

  /// AI consent sheet: list of excluded data
  ///
  /// In en, this message translates to:
  /// **'• Location (GPS) data\n• Step counts and other health data\n• Contacts, photos and other on-device personal data'**
  String get aiConsentNotSentItems;

  /// AI consent sheet: third-party recipients heading
  ///
  /// In en, this message translates to:
  /// **'Who receives it'**
  String get aiConsentThirdPartyTitle;

  /// AI consent sheet: list of third-party AI recipients
  ///
  /// In en, this message translates to:
  /// **'Cloudflare Workers AI, OpenAI, Google Gemini, OpenRouter, Groq'**
  String get aiConsentThirdPartyItems;

  /// AI consent sheet: overseas transfer heading
  ///
  /// In en, this message translates to:
  /// **'Cross-border transfer'**
  String get aiConsentOverseasTitle;

  /// AI consent sheet: overseas transfer body
  ///
  /// In en, this message translates to:
  /// **'These services run on servers outside your country, including in the United States, so your information is transferred abroad. It is transferred to generate AI output and is retained or deleted under each provider\'s own policy. See our Privacy Policy for details.'**
  String get aiConsentOverseasBody;

  /// AI consent sheet: note that consent is optional and revocable
  ///
  /// In en, this message translates to:
  /// **'You can still use walks, missions, stats and everything else without agreeing. You can withdraw consent at any time in Settings.'**
  String get aiConsentWithdrawNote;

  /// Link to the privacy policy from the AI consent sheet
  ///
  /// In en, this message translates to:
  /// **'View Privacy Policy'**
  String get aiConsentViewPolicy;

  /// Accept button on the AI consent sheet
  ///
  /// In en, this message translates to:
  /// **'Agree and continue'**
  String get aiConsentAgree;

  /// Decline button on the AI consent sheet
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get aiConsentDecline;

  /// Snackbar shown when an AI feature is used without consent
  ///
  /// In en, this message translates to:
  /// **'AI features need your consent to share data.'**
  String get aiConsentRequiredMessage;

  /// Settings tile for managing AI data sharing consent
  ///
  /// In en, this message translates to:
  /// **'AI data sharing'**
  String get aiConsentTileTitle;

  /// Settings tile subtitle when AI consent is granted
  ///
  /// In en, this message translates to:
  /// **'Allowed · tap to withdraw'**
  String get aiConsentTileOn;

  /// Settings tile subtitle when AI consent is not granted
  ///
  /// In en, this message translates to:
  /// **'Not allowed · tap to allow'**
  String get aiConsentTileOff;

  /// Title of the consent withdrawal dialog
  ///
  /// In en, this message translates to:
  /// **'Withdraw consent?'**
  String get aiConsentWithdrawTitle;

  /// Body of the consent withdrawal dialog
  ///
  /// In en, this message translates to:
  /// **'AI sticker generation and pet remarks will stop working. Stickers you already made are kept.'**
  String get aiConsentWithdrawBody;

  /// Confirm button on the consent withdrawal dialog
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get aiConsentWithdrawConfirm;

  /// Snackbar confirming consent withdrawal
  ///
  /// In en, this message translates to:
  /// **'AI data sharing consent withdrawn'**
  String get aiConsentWithdrawn;

  /// Snackbar confirming consent was granted
  ///
  /// In en, this message translates to:
  /// **'AI data sharing allowed'**
  String get aiConsentGranted;

  /// Generic cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Badge overlaid on AI-generated images
  ///
  /// In en, this message translates to:
  /// **'AI-generated'**
  String get aiGeneratedBadge;

  /// Notice shown under an AI-generated image
  ///
  /// In en, this message translates to:
  /// **'This image was created with generative AI.'**
  String get aiGeneratedImageNotice;

  /// Label marking AI-generated pet dialogue
  ///
  /// In en, this message translates to:
  /// **'Written by AI'**
  String get aiGeneratedTextNotice;

  /// Button that opens the content report sheet
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportContentButton;

  /// Title of the content report sheet
  ///
  /// In en, this message translates to:
  /// **'Report inappropriate content'**
  String get reportContentTitle;

  /// Body of the content report sheet
  ///
  /// In en, this message translates to:
  /// **'Is something wrong with this AI output? Pick a reason. We review every report.'**
  String get reportContentBody;

  /// Report reason option
  ///
  /// In en, this message translates to:
  /// **'Inappropriate or offensive'**
  String get reportReasonInappropriate;

  /// Report reason option
  ///
  /// In en, this message translates to:
  /// **'Violent or hateful'**
  String get reportReasonViolent;

  /// Report reason option
  ///
  /// In en, this message translates to:
  /// **'Sexual content'**
  String get reportReasonSexual;

  /// Report reason option
  ///
  /// In en, this message translates to:
  /// **'Misleading or false'**
  String get reportReasonMisleading;

  /// Report reason option
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reportReasonOther;

  /// Submit button on the content report sheet
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get reportSubmit;

  /// Snackbar confirming a report was submitted
  ///
  /// In en, this message translates to:
  /// **'Report received. We\'ll review it shortly.'**
  String get reportSubmitted;

  /// Snackbar shown when submitting a report fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the report. Please try again.'**
  String get reportFailed;

  /// Settings tile title for the location-based services terms
  ///
  /// In en, this message translates to:
  /// **'Location-Based Services Terms'**
  String get locationTermsTitle;

  /// Settings tile subtitle for the location-based services terms
  ///
  /// In en, this message translates to:
  /// **'Terms for using location information'**
  String get locationTermsDescription;

  /// Tip shown where location features are unavailable (e.g. South Korea)
  ///
  /// In en, this message translates to:
  /// **'Walks are tracked by step count. No location data is used.'**
  String get walkStepsOnlyTip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
