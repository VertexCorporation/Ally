import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ku.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('az'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ku'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @ally.
  ///
  /// In en, this message translates to:
  /// **'Ally'**
  String get ally;

  /// No description provided for @motto.
  ///
  /// In en, this message translates to:
  /// **'Your health\'s closest Ally.'**
  String get motto;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @kurdish.
  ///
  /// In en, this message translates to:
  /// **'Kurdish'**
  String get kurdish;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// No description provided for @deutsch.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get deutsch;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @azerbaijani.
  ///
  /// In en, this message translates to:
  /// **'Azerbaijani'**
  String get azerbaijani;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @continueAlly.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAlly;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start!'**
  String get letsStart;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @nowLabel.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get nowLabel;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @of100.
  ///
  /// In en, this message translates to:
  /// **'of 100'**
  String get of100;

  /// No description provided for @outOf100.
  ///
  /// In en, this message translates to:
  /// **'out of 100'**
  String get outOf100;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String hours(Object hours);

  /// No description provided for @hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String hoursMinutes(Object hours, Object minutes);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(Object hours);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(Object count);

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'{bpm} BPM'**
  String bpm(Object bpm);

  /// No description provided for @bpmUnit.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpmUnit;

  /// No description provided for @gramsAmount.
  ///
  /// In en, this message translates to:
  /// **'~{grams}g'**
  String gramsAmount(Object grams);

  /// No description provided for @caloriesAmount.
  ///
  /// In en, this message translates to:
  /// **'~{calories} cal'**
  String caloriesAmount(Object calories);

  /// No description provided for @welcomeToAlly.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ally'**
  String get welcomeToAlly;

  /// No description provided for @welcomeText1.
  ///
  /// In en, this message translates to:
  /// **'Your health\'s'**
  String get welcomeText1;

  /// No description provided for @welcomeText2.
  ///
  /// In en, this message translates to:
  /// **'closest'**
  String get welcomeText2;

  /// No description provided for @welcomeText3.
  ///
  /// In en, this message translates to:
  /// **'Ally'**
  String get welcomeText3;

  /// No description provided for @personalHealthCompanion.
  ///
  /// In en, this message translates to:
  /// **'Your personal health companion'**
  String get personalHealthCompanion;

  /// No description provided for @trackWellnessJourney.
  ///
  /// In en, this message translates to:
  /// **'Track your wellness journey with personalized goals and insights'**
  String get trackWellnessJourney;

  /// No description provided for @firstSteps.
  ///
  /// In en, this message translates to:
  /// **'First Steps'**
  String get firstSteps;

  /// No description provided for @firstStepsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile setup'**
  String get firstStepsDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Journey'**
  String get startJourney;

  /// No description provided for @personalizeJourney.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your journey'**
  String get personalizeJourney;

  /// No description provided for @createPerfectPlan.
  ///
  /// In en, this message translates to:
  /// **'Let\'s create your perfect health plan'**
  String get createPerfectPlan;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @whatsYourAge.
  ///
  /// In en, this message translates to:
  /// **'What\'s your age?'**
  String get whatsYourAge;

  /// No description provided for @whatsYourHeight.
  ///
  /// In en, this message translates to:
  /// **'What\'s your height?'**
  String get whatsYourHeight;

  /// No description provided for @calculateIdealMetrics.
  ///
  /// In en, this message translates to:
  /// **'We\'ll calculate your ideal metrics'**
  String get calculateIdealMetrics;

  /// No description provided for @calculateCalorieNeeds.
  ///
  /// In en, this message translates to:
  /// **'This helps us calculate your daily calorie needs'**
  String get calculateCalorieNeeds;

  /// No description provided for @personalizeHealthGoals.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use this to personalize your health goals'**
  String get personalizeHealthGoals;

  /// No description provided for @determinesCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'This determines your calorie target'**
  String get determinesCalorieTarget;

  /// No description provided for @chooseUnits.
  ///
  /// In en, this message translates to:
  /// **'Choose your units'**
  String get chooseUnits;

  /// No description provided for @selectSystemPrefer.
  ///
  /// In en, this message translates to:
  /// **'Select the system you prefer'**
  String get selectSystemPrefer;

  /// No description provided for @kgCm.
  ///
  /// In en, this message translates to:
  /// **'kg, cm'**
  String get kgCm;

  /// No description provided for @lbsIn.
  ///
  /// In en, this message translates to:
  /// **'lbs, in'**
  String get lbsIn;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'25'**
  String get ageHint;

  /// No description provided for @heightFeetHint.
  ///
  /// In en, this message translates to:
  /// **'5\'9\"'**
  String get heightFeetHint;

  /// No description provided for @weightLbsHint.
  ///
  /// In en, this message translates to:
  /// **'170'**
  String get weightLbsHint;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginDescription;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @continueAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Continue Anonymously'**
  String get continueAnonymously;

  /// No description provided for @continueAsAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Continue as Anonymous'**
  String get continueAsAnonymous;

  /// No description provided for @helloAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Hello, anonymous!'**
  String get helloAnonymous;

  /// No description provided for @anonymousUser.
  ///
  /// In en, this message translates to:
  /// **'Anonymous User'**
  String get anonymousUser;

  /// No description provided for @chooseSignInMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose your sign in method'**
  String get chooseSignInMethod;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get signInWithEmail;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @usernameAtHint.
  ///
  /// In en, this message translates to:
  /// **'@username'**
  String get usernameAtHint;

  /// No description provided for @chooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Choose your username'**
  String get chooseUsername;

  /// No description provided for @legalAgreement.
  ///
  /// In en, this message translates to:
  /// **'By signing in/up, you agree to our Privacy Policy and Terms of Service'**
  String get legalAgreement;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dailyReflection.
  ///
  /// In en, this message translates to:
  /// **'Daily reflection'**
  String get dailyReflection;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @yourHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Your Health Score'**
  String get yourHealthScore;

  /// No description provided for @scoreBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Score Breakdown'**
  String get scoreBreakdown;

  /// No description provided for @todaysOverview.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Overview'**
  String get todaysOverview;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @myActivity.
  ///
  /// In en, this message translates to:
  /// **'My Activity'**
  String get myActivity;

  /// No description provided for @friendsActivity.
  ///
  /// In en, this message translates to:
  /// **'Friends Activity'**
  String get friendsActivity;

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityYet;

  /// No description provided for @startTrackingToSee.
  ///
  /// In en, this message translates to:
  /// **'Start tracking to see your activity'**
  String get startTrackingToSee;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String dayStreak(Object count);

  /// No description provided for @dayStreakMaintained.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak maintained'**
  String dayStreakMaintained(Object count);

  /// No description provided for @tipMaintainStreak.
  ///
  /// In en, this message translates to:
  /// **'Focus on maintaining your exercise streak'**
  String get tipMaintainStreak;

  /// No description provided for @tipDrinkWater.
  ///
  /// In en, this message translates to:
  /// **'Try to drink 2 more glasses of water today'**
  String get tipDrinkWater;

  /// No description provided for @tipBedtimeEarlier.
  ///
  /// In en, this message translates to:
  /// **'Aim for 30 minutes earlier bedtime'**
  String get tipBedtimeEarlier;

  /// No description provided for @setGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Goal'**
  String get setGoal;

  /// No description provided for @setYourGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Your Goal'**
  String get setYourGoal;

  /// No description provided for @setYourGoals.
  ///
  /// In en, this message translates to:
  /// **'Set Your Goals'**
  String get setYourGoals;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Goal'**
  String get editGoal;

  /// No description provided for @goalSet.
  ///
  /// In en, this message translates to:
  /// **'Goal Set'**
  String get goalSet;

  /// No description provided for @goalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal Updated'**
  String get goalUpdated;

  /// No description provided for @dailyGoalSetTo.
  ///
  /// In en, this message translates to:
  /// **'Daily goal set to {value}{unit}'**
  String dailyGoalSetTo(Object unit, Object value);

  /// No description provided for @valueOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{value} of {target}'**
  String valueOfTarget(Object target, Object value);

  /// No description provided for @valueSlashTarget.
  ///
  /// In en, this message translates to:
  /// **'{value}/{target}'**
  String valueSlashTarget(Object target, Object value);

  /// No description provided for @currentSlashTarget.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target}'**
  String currentSlashTarget(Object current, Object target);

  /// No description provided for @ofValueUnit.
  ///
  /// In en, this message translates to:
  /// **'of {value}{unit}'**
  String ofValueUnit(Object unit, Object value);

  /// No description provided for @pedometer.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get pedometer;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} steps'**
  String steps(Object current, Object goal);

  /// No description provided for @stepsLabel.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get stepsLabel;

  /// No description provided for @stepsGoal.
  ///
  /// In en, this message translates to:
  /// **'Steps Goal'**
  String get stepsGoal;

  /// No description provided for @dailyStepGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily step goal'**
  String get dailyStepGoal;

  /// No description provided for @howManySteps.
  ///
  /// In en, this message translates to:
  /// **'How many steps do you want to achieve today?'**
  String get howManySteps;

  /// No description provided for @defaultStepGoal.
  ///
  /// In en, this message translates to:
  /// **'6000'**
  String get defaultStepGoal;

  /// No description provided for @add500Steps.
  ///
  /// In en, this message translates to:
  /// **'Add 500 Steps'**
  String get add500Steps;

  /// No description provided for @add1000Steps.
  ///
  /// In en, this message translates to:
  /// **'Add 1000 Steps'**
  String get add1000Steps;

  /// No description provided for @enableStepTracking.
  ///
  /// In en, this message translates to:
  /// **'Enable Step Tracking'**
  String get enableStepTracking;

  /// No description provided for @stepPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'We need activity recognition permission to count your steps in the background.'**
  String get stepPermissionMessage;

  /// No description provided for @stepTrackingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Step tracking enabled!'**
  String get stepTrackingEnabled;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @serviceControls.
  ///
  /// In en, this message translates to:
  /// **'Service Controls'**
  String get serviceControls;

  /// No description provided for @startService.
  ///
  /// In en, this message translates to:
  /// **'Start Service'**
  String get startService;

  /// No description provided for @restartService.
  ///
  /// In en, this message translates to:
  /// **'Restart Service'**
  String get restartService;

  /// No description provided for @stopService.
  ///
  /// In en, this message translates to:
  /// **'Stop Service'**
  String get stopService;

  /// No description provided for @serviceStarted.
  ///
  /// In en, this message translates to:
  /// **'Service Started'**
  String get serviceStarted;

  /// No description provided for @serviceStartedDesc.
  ///
  /// In en, this message translates to:
  /// **'Step counter service is now running'**
  String get serviceStartedDesc;

  /// No description provided for @serviceRestarted.
  ///
  /// In en, this message translates to:
  /// **'Service Restarted'**
  String get serviceRestarted;

  /// No description provided for @serviceRestartedDesc.
  ///
  /// In en, this message translates to:
  /// **'Step counter service has been restarted'**
  String get serviceRestartedDesc;

  /// No description provided for @serviceStopped.
  ///
  /// In en, this message translates to:
  /// **'Service Stopped'**
  String get serviceStopped;

  /// No description provided for @serviceStoppedDesc.
  ///
  /// In en, this message translates to:
  /// **'Step counter service has been stopped'**
  String get serviceStoppedDesc;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @waterGlasses.
  ///
  /// In en, this message translates to:
  /// **'{current} / {goal} glasses'**
  String waterGlasses(Object current, Object goal);

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glasses;

  /// No description provided for @glassesPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} glasses/day'**
  String glassesPerDay(Object count);

  /// No description provided for @drankGlasses.
  ///
  /// In en, this message translates to:
  /// **'Drank {count} glasses of water'**
  String drankGlasses(Object count);

  /// No description provided for @waterGoal.
  ///
  /// In en, this message translates to:
  /// **'Water Goal'**
  String get waterGoal;

  /// No description provided for @waterGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Water Goal'**
  String get waterGoalLabel;

  /// No description provided for @setWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Your Water Goal'**
  String get setWaterGoal;

  /// No description provided for @editWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Water Goal'**
  String get editWaterGoal;

  /// No description provided for @howMuchWater.
  ///
  /// In en, this message translates to:
  /// **'How much water do you want to drink daily?'**
  String get howMuchWater;

  /// No description provided for @hydrationGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily hydration goal'**
  String get hydrationGoalDesc;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @mealLog.
  ///
  /// In en, this message translates to:
  /// **'Meal Log'**
  String get mealLog;

  /// No description provided for @mealLogged.
  ///
  /// In en, this message translates to:
  /// **'Meal Logged'**
  String get mealLogged;

  /// No description provided for @todaysIntake.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Intake'**
  String get todaysIntake;

  /// No description provided for @todaysMeals.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Meals'**
  String get todaysMeals;

  /// No description provided for @noMealsYet.
  ///
  /// In en, this message translates to:
  /// **'No meals added yet'**
  String get noMealsYet;

  /// No description provided for @noMealsLogged.
  ///
  /// In en, this message translates to:
  /// **'No meals logged yet'**
  String get noMealsLogged;

  /// No description provided for @tapToAddMeal.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first meal'**
  String get tapToAddMeal;

  /// No description provided for @tapPlusButton.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below'**
  String get tapPlusButton;

  /// No description provided for @addNutrition.
  ///
  /// In en, this message translates to:
  /// **'Add Nutrition'**
  String get addNutrition;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @scanWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan with Camera'**
  String get scanWithCamera;

  /// No description provided for @selectPlateType.
  ///
  /// In en, this message translates to:
  /// **'Select Plate Type'**
  String get selectPlateType;

  /// No description provided for @plate.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get plate;

  /// No description provided for @bowl.
  ///
  /// In en, this message translates to:
  /// **'Bowl'**
  String get bowl;

  /// No description provided for @smallPlate.
  ///
  /// In en, this message translates to:
  /// **'Small Plate'**
  String get smallPlate;

  /// No description provided for @mediumPlate.
  ///
  /// In en, this message translates to:
  /// **'Medium Plate'**
  String get mediumPlate;

  /// No description provided for @largePlate.
  ///
  /// In en, this message translates to:
  /// **'Large Plate'**
  String get largePlate;

  /// No description provided for @smallBowl.
  ///
  /// In en, this message translates to:
  /// **'Small Bowl'**
  String get smallBowl;

  /// No description provided for @mediumBowl.
  ///
  /// In en, this message translates to:
  /// **'Medium Bowl'**
  String get mediumBowl;

  /// No description provided for @largeBowl.
  ///
  /// In en, this message translates to:
  /// **'Large Bowl'**
  String get largeBowl;

  /// No description provided for @fillLevel.
  ///
  /// In en, this message translates to:
  /// **'Fill Level'**
  String get fillLevel;

  /// No description provided for @quarter.
  ///
  /// In en, this message translates to:
  /// **'1/4 Full'**
  String get quarter;

  /// No description provided for @half.
  ///
  /// In en, this message translates to:
  /// **'1/2 Full'**
  String get half;

  /// No description provided for @threeQuarters.
  ///
  /// In en, this message translates to:
  /// **'3/4 Full'**
  String get threeQuarters;

  /// No description provided for @full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get full;

  /// No description provided for @foodSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{plateType} - {fillTitle} (~{grams}g)'**
  String foodSelectionSubtitle(
    Object fillTitle,
    Object grams,
    Object plateType,
  );

  /// No description provided for @selectFood.
  ///
  /// In en, this message translates to:
  /// **'Select Food'**
  String get selectFood;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'{count} cal'**
  String calories(Object count);

  /// No description provided for @caloriesConsumed.
  ///
  /// In en, this message translates to:
  /// **'{count} calories consumed'**
  String caloriesConsumed(Object count);

  /// No description provided for @caloriesPer100g.
  ///
  /// In en, this message translates to:
  /// **'({calories}/100g)'**
  String caloriesPer100g(Object calories);

  /// No description provided for @calorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Calorie Goal'**
  String get calorieGoal;

  /// No description provided for @calorieGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Calorie Goal'**
  String get calorieGoalLabel;

  /// No description provided for @setCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Your Calorie Goal'**
  String get setCalorieGoal;

  /// No description provided for @setYourCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Your Calorie Goal'**
  String get setYourCalorieGoal;

  /// No description provided for @editCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Calorie Goal'**
  String get editCalorieGoal;

  /// No description provided for @howManyCalories.
  ///
  /// In en, this message translates to:
  /// **'How many calories do you want to consume daily?'**
  String get howManyCalories;

  /// No description provided for @dailyCalorieHint.
  ///
  /// In en, this message translates to:
  /// **'2000'**
  String get dailyCalorieHint;

  /// No description provided for @calorieGoalHint.
  ///
  /// In en, this message translates to:
  /// **'200'**
  String get calorieGoalHint;

  /// No description provided for @calorieGoalSet.
  ///
  /// In en, this message translates to:
  /// **'Your daily calorie goal is now {calories} kcal'**
  String calorieGoalSet(Object calories);

  /// No description provided for @kcalPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} kcal/day'**
  String kcalPerDay(Object count);

  /// No description provided for @calorieBalanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Calorie intake balance'**
  String get calorieBalanceDesc;

  /// No description provided for @egg.
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get egg;

  /// No description provided for @milk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get milk;

  /// No description provided for @yogurt.
  ///
  /// In en, this message translates to:
  /// **'Yogurt'**
  String get yogurt;

  /// No description provided for @whiteRice.
  ///
  /// In en, this message translates to:
  /// **'White Rice'**
  String get whiteRice;

  /// No description provided for @plainPasta.
  ///
  /// In en, this message translates to:
  /// **'Plain Pasta'**
  String get plainPasta;

  /// No description provided for @chickenBreast.
  ///
  /// In en, this message translates to:
  /// **'Chicken Breast'**
  String get chickenBreast;

  /// No description provided for @grilledSalmon.
  ///
  /// In en, this message translates to:
  /// **'Grilled Salmon'**
  String get grilledSalmon;

  /// No description provided for @boiledPotato.
  ///
  /// In en, this message translates to:
  /// **'Boiled Potato'**
  String get boiledPotato;

  /// No description provided for @mixedVegetables.
  ///
  /// In en, this message translates to:
  /// **'Mixed Vegetables'**
  String get mixedVegetables;

  /// No description provided for @couscous.
  ///
  /// In en, this message translates to:
  /// **'Couscous'**
  String get couscous;

  /// No description provided for @quinoa.
  ///
  /// In en, this message translates to:
  /// **'Quinoa'**
  String get quinoa;

  /// No description provided for @bulgur.
  ///
  /// In en, this message translates to:
  /// **'Bulgur'**
  String get bulgur;

  /// No description provided for @corn.
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get corn;

  /// No description provided for @peas.
  ///
  /// In en, this message translates to:
  /// **'Peas'**
  String get peas;

  /// No description provided for @broccoli.
  ///
  /// In en, this message translates to:
  /// **'Broccoli'**
  String get broccoli;

  /// No description provided for @mushroom.
  ///
  /// In en, this message translates to:
  /// **'Mushroom'**
  String get mushroom;

  /// No description provided for @stirFryVegetables.
  ///
  /// In en, this message translates to:
  /// **'Stir-Fry Vegetables'**
  String get stirFryVegetables;

  /// No description provided for @sweetPotato.
  ///
  /// In en, this message translates to:
  /// **'Sweet Potato'**
  String get sweetPotato;

  /// No description provided for @baldoRice.
  ///
  /// In en, this message translates to:
  /// **'Baldo Rice'**
  String get baldoRice;

  /// No description provided for @chickenCurry.
  ///
  /// In en, this message translates to:
  /// **'Chicken Curry'**
  String get chickenCurry;

  /// No description provided for @beefCurry.
  ///
  /// In en, this message translates to:
  /// **'Beef Curry'**
  String get beefCurry;

  /// No description provided for @spaghettiPuttanesca.
  ///
  /// In en, this message translates to:
  /// **'Spaghetti Puttanesca'**
  String get spaghettiPuttanesca;

  /// No description provided for @ravioli.
  ///
  /// In en, this message translates to:
  /// **'Ravioli'**
  String get ravioli;

  /// No description provided for @gnocchi.
  ///
  /// In en, this message translates to:
  /// **'Gnocchi'**
  String get gnocchi;

  /// No description provided for @kidneyBeans.
  ///
  /// In en, this message translates to:
  /// **'Kidney Beans'**
  String get kidneyBeans;

  /// No description provided for @chickpeas.
  ///
  /// In en, this message translates to:
  /// **'Chickpeas'**
  String get chickpeas;

  /// No description provided for @lentils.
  ///
  /// In en, this message translates to:
  /// **'Lentils'**
  String get lentils;

  /// No description provided for @whiteBeans.
  ///
  /// In en, this message translates to:
  /// **'White Beans'**
  String get whiteBeans;

  /// No description provided for @tuna.
  ///
  /// In en, this message translates to:
  /// **'Tuna'**
  String get tuna;

  /// No description provided for @mussels.
  ///
  /// In en, this message translates to:
  /// **'Mussels'**
  String get mussels;

  /// No description provided for @shrimp.
  ///
  /// In en, this message translates to:
  /// **'Shrimp'**
  String get shrimp;

  /// No description provided for @caesarSalad.
  ///
  /// In en, this message translates to:
  /// **'Caesar Salad'**
  String get caesarSalad;

  /// No description provided for @tofu.
  ///
  /// In en, this message translates to:
  /// **'Tofu'**
  String get tofu;

  /// No description provided for @salad.
  ///
  /// In en, this message translates to:
  /// **'Salad'**
  String get salad;

  /// No description provided for @soup.
  ///
  /// In en, this message translates to:
  /// **'Soup'**
  String get soup;

  /// No description provided for @fruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get fruit;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg'**
  String weightKg(Object weight);

  /// No description provided for @weightWithUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight ({unit})'**
  String weightWithUnit(Object unit);

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @goalWeight.
  ///
  /// In en, this message translates to:
  /// **'Goal Weight'**
  String get goalWeight;

  /// No description provided for @weightHistory.
  ///
  /// In en, this message translates to:
  /// **'Weight History'**
  String get weightHistory;

  /// No description provided for @noWeightHistory.
  ///
  /// In en, this message translates to:
  /// **'No weight history'**
  String get noWeightHistory;

  /// No description provided for @startTrackingWeight.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your weight progress'**
  String get startTrackingWeight;

  /// No description provided for @trackWeightProgress.
  ///
  /// In en, this message translates to:
  /// **'Track your weight to see progress'**
  String get trackWeightProgress;

  /// No description provided for @updateWeight.
  ///
  /// In en, this message translates to:
  /// **'Update Weight'**
  String get updateWeight;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight ({unit})'**
  String enterWeight(Object unit);

  /// No description provided for @editWeight.
  ///
  /// In en, this message translates to:
  /// **'Edit Weight'**
  String get editWeight;

  /// No description provided for @enterWeightLbs.
  ///
  /// In en, this message translates to:
  /// **'Enter weight (lbs)'**
  String get enterWeightLbs;

  /// No description provided for @enterWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Enter weight (kg)'**
  String get enterWeightKg;

  /// No description provided for @whatsYourWeight.
  ///
  /// In en, this message translates to:
  /// **'What\'s your weight?'**
  String get whatsYourWeight;

  /// No description provided for @weightUpdated.
  ///
  /// In en, this message translates to:
  /// **'Weight Updated'**
  String get weightUpdated;

  /// No description provided for @weightGoalAchieved.
  ///
  /// In en, this message translates to:
  /// **'Weight Goal Achieved'**
  String get weightGoalAchieved;

  /// No description provided for @reachTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Reach your target weight'**
  String get reachTargetWeight;

  /// No description provided for @loseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// No description provided for @reduceCalories.
  ///
  /// In en, this message translates to:
  /// **'Reduce calories'**
  String get reduceCalories;

  /// No description provided for @maintainWeight.
  ///
  /// In en, this message translates to:
  /// **'Maintain Weight'**
  String get maintainWeight;

  /// No description provided for @balancedCalories.
  ///
  /// In en, this message translates to:
  /// **'Balanced calories'**
  String get balancedCalories;

  /// No description provided for @gainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get gainWeight;

  /// No description provided for @increaseCalories.
  ///
  /// In en, this message translates to:
  /// **'Increase calories'**
  String get increaseCalories;

  /// No description provided for @weightProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Progress towards target weight'**
  String get weightProgressDesc;

  /// No description provided for @weightPercent.
  ///
  /// In en, this message translates to:
  /// **'{weight}% weight'**
  String weightPercent(Object weight);

  /// No description provided for @scoreSlashWeight.
  ///
  /// In en, this message translates to:
  /// **'{score}/{weight}'**
  String scoreSlashWeight(Object score, Object weight);

  /// No description provided for @percentWeight.
  ///
  /// In en, this message translates to:
  /// **'% weight'**
  String get percentWeight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @editHeight.
  ///
  /// In en, this message translates to:
  /// **'Edit Height'**
  String get editHeight;

  /// No description provided for @addHeightWeight.
  ///
  /// In en, this message translates to:
  /// **'Add height and weight'**
  String get addHeightWeight;

  /// No description provided for @bodyMassIndex.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index (BMI)'**
  String get bodyMassIndex;

  /// No description provided for @bmiValue.
  ///
  /// In en, this message translates to:
  /// **'BMI: {value}'**
  String bmiValue(Object value);

  /// No description provided for @bmiLabel.
  ///
  /// In en, this message translates to:
  /// **'BMI: {value}'**
  String bmiLabel(Object value);

  /// No description provided for @notCalculated.
  ///
  /// In en, this message translates to:
  /// **'Not calculated'**
  String get notCalculated;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @myWorkouts.
  ///
  /// In en, this message translates to:
  /// **'My Workouts'**
  String get myWorkouts;

  /// No description provided for @startFitnessJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your fitness journey today!'**
  String get startFitnessJourney;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @addExercisesToStart.
  ///
  /// In en, this message translates to:
  /// **'Add exercises to start'**
  String get addExercisesToStart;

  /// No description provided for @selectExercise.
  ///
  /// In en, this message translates to:
  /// **'Select Exercise'**
  String get selectExercise;

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise Name'**
  String get exerciseName;

  /// No description provided for @enterExerciseName.
  ///
  /// In en, this message translates to:
  /// **'Enter exercise name'**
  String get enterExerciseName;

  /// No description provided for @exerciseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Exercise not found'**
  String get exerciseNotFound;

  /// No description provided for @logExercise.
  ///
  /// In en, this message translates to:
  /// **'Log Exercise'**
  String get logExercise;

  /// No description provided for @quickLog.
  ///
  /// In en, this message translates to:
  /// **'Quick Log'**
  String get quickLog;

  /// No description provided for @quickExerciseLog.
  ///
  /// In en, this message translates to:
  /// **'Quick Exercise Log'**
  String get quickExerciseLog;

  /// No description provided for @logASingleExercise.
  ///
  /// In en, this message translates to:
  /// **'Log a single exercise'**
  String get logASingleExercise;

  /// No description provided for @logYourExercise.
  ///
  /// In en, this message translates to:
  /// **'Log your exercise'**
  String get logYourExercise;

  /// No description provided for @exerciseType.
  ///
  /// In en, this message translates to:
  /// **'Exercise Type'**
  String get exerciseType;

  /// No description provided for @cardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get cardio;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @workoutName.
  ///
  /// In en, this message translates to:
  /// **'Workout Name'**
  String get workoutName;

  /// No description provided for @enterWorkoutName.
  ///
  /// In en, this message translates to:
  /// **'Enter workout name'**
  String get enterWorkoutName;

  /// No description provided for @createWorkout.
  ///
  /// In en, this message translates to:
  /// **'Create Workout'**
  String get createWorkout;

  /// No description provided for @buildYourOwnWorkout.
  ///
  /// In en, this message translates to:
  /// **'Build your own workout'**
  String get buildYourOwnWorkout;

  /// No description provided for @workoutBuilder.
  ///
  /// In en, this message translates to:
  /// **'Workout Builder'**
  String get workoutBuilder;

  /// No description provided for @editWorkout.
  ///
  /// In en, this message translates to:
  /// **'Edit Workout'**
  String get editWorkout;

  /// No description provided for @deleteWorkout.
  ///
  /// In en, this message translates to:
  /// **'Delete Workout'**
  String get deleteWorkout;

  /// No description provided for @areYouSureDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this workout?'**
  String get areYouSureDelete;

  /// No description provided for @todaysPrograms.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Programs'**
  String get todaysPrograms;

  /// No description provided for @quickPrograms.
  ///
  /// In en, this message translates to:
  /// **'Quick Programs'**
  String get quickPrograms;

  /// No description provided for @customProgram.
  ///
  /// In en, this message translates to:
  /// **'Custom Program'**
  String get customProgram;

  /// No description provided for @createProgramToQuicklyStart.
  ///
  /// In en, this message translates to:
  /// **'Create a program to quickly start'**
  String get createProgramToQuicklyStart;

  /// No description provided for @editProgram.
  ///
  /// In en, this message translates to:
  /// **'Edit Program'**
  String get editProgram;

  /// No description provided for @deleteProgram.
  ///
  /// In en, this message translates to:
  /// **'Delete Program'**
  String get deleteProgram;

  /// No description provided for @deleteProgramQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Program?'**
  String get deleteProgramQuestion;

  /// No description provided for @areYouSureDeleteProgram.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String areYouSureDeleteProgram(Object name);

  /// No description provided for @programNameHint.
  ///
  /// In en, this message translates to:
  /// **'Program name (e.g. Push Day)'**
  String get programNameHint;

  /// No description provided for @programUpdated.
  ///
  /// In en, this message translates to:
  /// **'Program \"{name}\" updated!'**
  String programUpdated(Object name);

  /// No description provided for @programSaved.
  ///
  /// In en, this message translates to:
  /// **'Program \"{name}\" saved!'**
  String programSaved(Object name);

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @feet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get feet;

  /// No description provided for @inches.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get inches;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get notSet;

  /// No description provided for @addSet.
  ///
  /// In en, this message translates to:
  /// **'Add Set'**
  String get addSet;

  /// No description provided for @editSetNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit Set {number}'**
  String editSetNumber(Object number);

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @repsLowercase.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get repsLowercase;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest (s)'**
  String get rest;

  /// No description provided for @restTime.
  ///
  /// In en, this message translates to:
  /// **'Rest Time'**
  String get restTime;

  /// No description provided for @restSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String restSeconds(Object seconds);

  /// No description provided for @noWorkoutsLogged.
  ///
  /// In en, this message translates to:
  /// **'No workouts logged yet'**
  String get noWorkoutsLogged;

  /// No description provided for @exerciseStreak.
  ///
  /// In en, this message translates to:
  /// **'Exercise Streak'**
  String get exerciseStreak;

  /// No description provided for @noStreakYet.
  ///
  /// In en, this message translates to:
  /// **'No streak yet'**
  String get noStreakYet;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going!'**
  String get keepGoing;

  /// No description provided for @workoutStreakDesc.
  ///
  /// In en, this message translates to:
  /// **'Workout streak and daily activity'**
  String get workoutStreakDesc;

  /// No description provided for @workoutCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout Completed!'**
  String get workoutCompleted;

  /// No description provided for @completedAt.
  ///
  /// In en, this message translates to:
  /// **'Completed at {time}'**
  String completedAt(Object time);

  /// No description provided for @workoutNotComplete.
  ///
  /// In en, this message translates to:
  /// **'Workout Not Complete'**
  String get workoutNotComplete;

  /// No description provided for @workoutNotCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t finished all sets. Do you want to save your progress and finish anyway?'**
  String get workoutNotCompleteMessage;

  /// No description provided for @finishAnyway.
  ///
  /// In en, this message translates to:
  /// **'Finish Anyway'**
  String get finishAnyway;

  /// No description provided for @exitWorkout.
  ///
  /// In en, this message translates to:
  /// **'Exit Workout?'**
  String get exitWorkout;

  /// No description provided for @progressNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Your progress will not be saved.'**
  String get progressNotSaved;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current}/{total}'**
  String exerciseProgress(Object current, Object total);

  /// No description provided for @percentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Complete'**
  String percentComplete(Object percent);

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevel;

  /// No description provided for @howActiveAreYou.
  ///
  /// In en, this message translates to:
  /// **'How active are you on a typical day?'**
  String get howActiveAreYou;

  /// No description provided for @sedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get sedentary;

  /// No description provided for @littleExercise.
  ///
  /// In en, this message translates to:
  /// **'Little or no exercise'**
  String get littleExercise;

  /// No description provided for @littleToNoExercise.
  ///
  /// In en, this message translates to:
  /// **'Little to no exercise'**
  String get littleToNoExercise;

  /// No description provided for @lightlyActive.
  ///
  /// In en, this message translates to:
  /// **'Lightly Active'**
  String get lightlyActive;

  /// No description provided for @lightExercise.
  ///
  /// In en, this message translates to:
  /// **'Light exercise 1-3 days/week'**
  String get lightExercise;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @lightActivity.
  ///
  /// In en, this message translates to:
  /// **'1-3 days/week'**
  String get lightActivity;

  /// No description provided for @moderatelyActive.
  ///
  /// In en, this message translates to:
  /// **'Moderately Active'**
  String get moderatelyActive;

  /// No description provided for @moderateExercise.
  ///
  /// In en, this message translates to:
  /// **'Moderate exercise 3-5 days/week'**
  String get moderateExercise;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @moderateActivity.
  ///
  /// In en, this message translates to:
  /// **'3-5 days/week'**
  String get moderateActivity;

  /// No description provided for @veryActive.
  ///
  /// In en, this message translates to:
  /// **'Very Active'**
  String get veryActive;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeActivity.
  ///
  /// In en, this message translates to:
  /// **'6-7 days/week'**
  String get activeActivity;

  /// No description provided for @intenseTraining.
  ///
  /// In en, this message translates to:
  /// **'Intense daily training'**
  String get intenseTraining;

  /// No description provided for @intenseDailyTraining.
  ///
  /// In en, this message translates to:
  /// **'Intense daily training'**
  String get intenseDailyTraining;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @sleepLogged.
  ///
  /// In en, this message translates to:
  /// **'Sleep Logged'**
  String get sleepLogged;

  /// No description provided for @sleepDuration.
  ///
  /// In en, this message translates to:
  /// **'Sleep Duration'**
  String get sleepDuration;

  /// No description provided for @noSleepData.
  ///
  /// In en, this message translates to:
  /// **'No sleep data recorded'**
  String get noSleepData;

  /// No description provided for @noSleepDataYet.
  ///
  /// In en, this message translates to:
  /// **'No sleep data yet'**
  String get noSleepDataYet;

  /// No description provided for @trackSleepPatterns.
  ///
  /// In en, this message translates to:
  /// **'Track your sleep to see patterns'**
  String get trackSleepPatterns;

  /// No description provided for @sleepQualityDesc.
  ///
  /// In en, this message translates to:
  /// **'Sleep duration and quality'**
  String get sleepQualityDesc;

  /// No description provided for @hoursOfSleep.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours of sleep'**
  String hoursOfSleep(Object hours);

  /// No description provided for @ofHoursGoal.
  ///
  /// In en, this message translates to:
  /// **'of {hours}h'**
  String ofHoursGoal(Object hours);

  /// No description provided for @lastNight.
  ///
  /// In en, this message translates to:
  /// **'Last night'**
  String get lastNight;

  /// No description provided for @sleepTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep Tracking'**
  String get sleepTrackingTitle;

  /// No description provided for @automaticSleepTracking.
  ///
  /// In en, this message translates to:
  /// **'Automatic Sleep Tracking'**
  String get automaticSleepTracking;

  /// No description provided for @automaticTrackingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Automatic tracking enabled'**
  String get automaticTrackingEnabled;

  /// No description provided for @sleepTrackingWillStartTonight.
  ///
  /// In en, this message translates to:
  /// **'Sleep tracking will start tonight'**
  String get sleepTrackingWillStartTonight;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking'**
  String get startTracking;

  /// No description provided for @currentlySleeping.
  ///
  /// In en, this message translates to:
  /// **'Currently Sleeping'**
  String get currentlySleeping;

  /// No description provided for @sleepTrackingStartTonight.
  ///
  /// In en, this message translates to:
  /// **'Sleep tracking will start tonight'**
  String get sleepTrackingStartTonight;

  /// No description provided for @noSmartwatchNeeded.
  ///
  /// In en, this message translates to:
  /// **'No smartwatch needed! Track your sleep automatically.'**
  String get noSmartwatchNeeded;

  /// No description provided for @whenDoYouSleep.
  ///
  /// In en, this message translates to:
  /// **'When do you usually sleep?'**
  String get whenDoYouSleep;

  /// No description provided for @whenDoYouUsuallySleep.
  ///
  /// In en, this message translates to:
  /// **'When do you usually sleep?'**
  String get whenDoYouUsuallySleep;

  /// No description provided for @sleepTime.
  ///
  /// In en, this message translates to:
  /// **'Sleep Time'**
  String get sleepTime;

  /// No description provided for @wakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake Time'**
  String get wakeTime;

  /// No description provided for @sleepSegments.
  ///
  /// In en, this message translates to:
  /// **'Sleep Segments'**
  String get sleepSegments;

  /// No description provided for @sleepCycles.
  ///
  /// In en, this message translates to:
  /// **'Sleep Cycles'**
  String get sleepCycles;

  /// No description provided for @wakeUps.
  ///
  /// In en, this message translates to:
  /// **'Wake Ups'**
  String get wakeUps;

  /// No description provided for @sleepSegmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Sleep Segment {number}'**
  String sleepSegmentNumber(Object number);

  /// No description provided for @heartbeat.
  ///
  /// In en, this message translates to:
  /// **'Heartbeat'**
  String get heartbeat;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @currentHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Current Heart Rate'**
  String get currentHeartRate;

  /// No description provided for @restingHeartRateDesc.
  ///
  /// In en, this message translates to:
  /// **'Resting heart rate'**
  String get restingHeartRateDesc;

  /// No description provided for @todaysReadings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Readings'**
  String get todaysReadings;

  /// No description provided for @noReadingsYet.
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get noReadingsYet;

  /// No description provided for @requiresMonitor.
  ///
  /// In en, this message translates to:
  /// **'Requires heart rate monitor device'**
  String get requiresMonitor;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get yourProfile;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @manageYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Profile'**
  String get manageYourProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @healthInfo.
  ///
  /// In en, this message translates to:
  /// **'Health Information'**
  String get healthInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @january1.
  ///
  /// In en, this message translates to:
  /// **'January 1, 1990'**
  String get january1;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @unitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get unitedStates;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @selectUnits.
  ///
  /// In en, this message translates to:
  /// **'Select Units'**
  String get selectUnits;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for your activities'**
  String get pushNotificationsDesc;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get updates via email'**
  String get emailNotificationsDesc;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @privacySettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your privacy preferences'**
  String get privacySettingsDesc;

  /// No description provided for @dataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get dataStorage;

  /// No description provided for @dataStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your data and storage'**
  String get dataStorageDesc;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @helpSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get helpSupportDesc;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutAlly.
  ///
  /// In en, this message translates to:
  /// **'About Ally'**
  String get aboutAlly;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @termsConditionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Read our terms and conditions'**
  String get termsConditionsDesc;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @readPolicies.
  ///
  /// In en, this message translates to:
  /// **'Read our policies and terms'**
  String get readPolicies;

  /// No description provided for @openingWebsite.
  ///
  /// In en, this message translates to:
  /// **'Opening website...'**
  String get openingWebsite;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// No description provided for @openingPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Opening Privacy Policy...'**
  String get openingPrivacyPolicy;

  /// No description provided for @openingTerms.
  ///
  /// In en, this message translates to:
  /// **'Opening Terms of Service...'**
  String get openingTerms;

  /// No description provided for @licensedApache.
  ///
  /// In en, this message translates to:
  /// **'Licensed under Apache License 2.0'**
  String get licensedApache;

  /// No description provided for @licensedApache2.
  ///
  /// In en, this message translates to:
  /// **'Licensed under Apache 2.0'**
  String get licensedApache2;

  /// No description provided for @licensedApache2Short.
  ///
  /// In en, this message translates to:
  /// **'Licensed under Apache 2.0'**
  String get licensedApache2Short;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Vertex Corporation'**
  String get copyright;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and data'**
  String get deleteAccountDesc;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @addFriendsToSee.
  ///
  /// In en, this message translates to:
  /// **'Add friends to see their activity'**
  String get addFriendsToSee;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get noFriendsYet;

  /// No description provided for @enterFriendUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your friend\'s username to follow their activity'**
  String get enterFriendUsername;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @friendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend Request Sent'**
  String get friendRequestSent;

  /// No description provided for @requestSentTo.
  ///
  /// In en, this message translates to:
  /// **'Request sent to {username} successfully!'**
  String requestSentTo(Object username);

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremium;

  /// No description provided for @upgradeYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your Plan'**
  String get upgradeYourPlan;

  /// No description provided for @unlockMore.
  ///
  /// In en, this message translates to:
  /// **'Unlock More.'**
  String get unlockMore;

  /// No description provided for @upgradeForExclusive.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for exclusive perks and a smoother,\nfaster experience.'**
  String get upgradeForExclusive;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @allyIndividual.
  ///
  /// In en, this message translates to:
  /// **'Ally Individual'**
  String get allyIndividual;

  /// No description provided for @allIndividualFeatures.
  ///
  /// In en, this message translates to:
  /// **'All Individual features plus\nfamily sharing for up to 4 members.'**
  String get allIndividualFeatures;

  /// No description provided for @familyPlan.
  ///
  /// In en, this message translates to:
  /// **'Family Plan'**
  String get familyPlan;

  /// No description provided for @getAllyPlan.
  ///
  /// In en, this message translates to:
  /// **'Get Ally Plan'**
  String get getAllyPlan;

  /// No description provided for @getFamilyPlan.
  ///
  /// In en, this message translates to:
  /// **'Get Family Plan'**
  String get getFamilyPlan;

  /// No description provided for @subscribeToPlan.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {title} plan'**
  String subscribeToPlan(Object title);

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @yourAchievements.
  ///
  /// In en, this message translates to:
  /// **'Your achievements'**
  String get yourAchievements;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @badgesEarned.
  ///
  /// In en, this message translates to:
  /// **'Badges Earned'**
  String get badgesEarned;

  /// No description provided for @availableAchievements.
  ///
  /// In en, this message translates to:
  /// **'Available Achievements'**
  String get availableAchievements;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @completedChallenges.
  ///
  /// In en, this message translates to:
  /// **'Completed Challenges'**
  String get completedChallenges;

  /// No description provided for @noAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'No Achievements Yet'**
  String get noAchievementsYet;

  /// No description provided for @startTrackingForAchievements.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your health to unlock achievements!'**
  String get startTrackingForAchievements;

  /// No description provided for @dayStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreakLabel;

  /// No description provided for @hydrationHero.
  ///
  /// In en, this message translates to:
  /// **'Hydration Hero'**
  String get hydrationHero;

  /// No description provided for @hydrationHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Drink 8 glasses a day for 7 days'**
  String get hydrationHeroDesc;

  /// No description provided for @drink8Glasses.
  ///
  /// In en, this message translates to:
  /// **'Drink 8 glasses of water daily'**
  String get drink8Glasses;

  /// No description provided for @workoutWarrior.
  ///
  /// In en, this message translates to:
  /// **'Workout Warrior'**
  String get workoutWarrior;

  /// No description provided for @complete7Days.
  ///
  /// In en, this message translates to:
  /// **'Complete 7 days of exercise'**
  String get complete7Days;

  /// No description provided for @sleepChampion.
  ///
  /// In en, this message translates to:
  /// **'Sleep Champion'**
  String get sleepChampion;

  /// No description provided for @sleepChampionDesc.
  ///
  /// In en, this message translates to:
  /// **'Get 8 hours sleep for 7 days'**
  String get sleepChampionDesc;

  /// No description provided for @get8Hours.
  ///
  /// In en, this message translates to:
  /// **'Get 8 hours of sleep for 7 days'**
  String get get8Hours;

  /// No description provided for @nutritionMaster.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Master'**
  String get nutritionMaster;

  /// No description provided for @trackMeals.
  ///
  /// In en, this message translates to:
  /// **'Track meals for 30 days'**
  String get trackMeals;

  /// No description provided for @heartHealth.
  ///
  /// In en, this message translates to:
  /// **'Heart Health'**
  String get heartHealth;

  /// No description provided for @maintain60to100.
  ///
  /// In en, this message translates to:
  /// **'Maintain 60-100 bpm for a week'**
  String get maintain60to100;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntake;

  /// No description provided for @earlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get earlyBird;

  /// No description provided for @earlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Log 7 consecutive days'**
  String get earlyBirdDesc;

  /// No description provided for @calorieCounter.
  ///
  /// In en, this message translates to:
  /// **'Calorie Counter'**
  String get calorieCounter;

  /// No description provided for @calorieCounterDesc.
  ///
  /// In en, this message translates to:
  /// **'Track meals for 30 days'**
  String get calorieCounterDesc;

  /// No description provided for @weekWarrior.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get weekWarrior;

  /// No description provided for @weekWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Exercise 5 times a week'**
  String get weekWarriorDesc;

  /// No description provided for @mileMaster.
  ///
  /// In en, this message translates to:
  /// **'Mile Master'**
  String get mileMaster;

  /// No description provided for @mileMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Run a total of 100 miles'**
  String get mileMasterDesc;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Continuing without login.'**
  String get authFailed;

  /// No description provided for @firebaseNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Firebase not configured. Use anonymous login.'**
  String get firebaseNotConfigured;

  /// No description provided for @firebaseNotConfiguredSignup.
  ///
  /// In en, this message translates to:
  /// **'Firebase not configured. Continuing without registration.'**
  String get firebaseNotConfiguredSignup;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign in failed. Use anonymous login instead.'**
  String get googleSignInFailed;

  /// No description provided for @emailSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Email sign in failed: {error}'**
  String emailSignInFailed(Object error);

  /// No description provided for @signUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed: {error}'**
  String signUpFailed(Object error);

  /// No description provided for @logged.
  ///
  /// In en, this message translates to:
  /// **'Logged!'**
  String get logged;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Cortex is temporarily offline while we roll out some important updates. Access to the app will be restored shortly.\n\nThank you for your patience as we improve your experience.'**
  String get maintenanceMessage;

  /// No description provided for @pageCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Page Could Not Be Loaded'**
  String get pageCouldNotBeLoaded;

  /// No description provided for @checkYourInternet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get checkYourInternet;

  /// No description provided for @notificationGoodMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get notificationGoodMorningTitle;

  /// No description provided for @notificationGoodMorningBody.
  ///
  /// In en, this message translates to:
  /// **'A great day is waiting for you. How about starting it with a cup of coffee and an interesting chat?'**
  String get notificationGoodMorningBody;

  /// No description provided for @notificationGoodNightTitle.
  ///
  /// In en, this message translates to:
  /// **'Good Night!'**
  String get notificationGoodNightTitle;

  /// No description provided for @notificationGoodNightBody.
  ///
  /// In en, this message translates to:
  /// **'Ally is with you even when you sleep. Don\'t worry, it won\'t touch.'**
  String get notificationGoodNightBody;

  /// No description provided for @notificationUpsellFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Exclusive to the {targetTier} Plan!'**
  String notificationUpsellFeatureTitle(Object targetTier);

  /// No description provided for @notificationUpsellFeatureBody.
  ///
  /// In en, this message translates to:
  /// **'Hello {currentTier} subscriber! The {targetTier} plan just got the {featureName} feature, which will take your Cortex to the next level. How about an upgrade?'**
  String notificationUpsellFeatureBody(
    Object currentTier,
    Object featureName,
    Object targetTier,
  );

  /// No description provided for @notificationSubscriptionOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'CHEAPER THAN GUM'**
  String get notificationSubscriptionOfferTitle;

  /// No description provided for @notificationSubscriptionOfferBody.
  ///
  /// In en, this message translates to:
  /// **'A FULL {discountRate}% DISCOUNT on all our subscription plans. Don\'t miss this!'**
  String notificationSubscriptionOfferBody(Object discountRate);

  /// No description provided for @notificationNewFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'whoa!'**
  String get notificationNewFeatureTitle;

  /// No description provided for @notificationNewFeatureBody.
  ///
  /// In en, this message translates to:
  /// **'Discover the new {featureName} feature. Cortex is now more powerful than ever.'**
  String notificationNewFeatureBody(Object featureName);

  /// The user-visible name for the main notification channel.
  ///
  /// In en, this message translates to:
  /// **'Cortex Updates'**
  String get channelFcmName;

  /// The user-visible description for the main notification channel.
  ///
  /// In en, this message translates to:
  /// **'Notifications about news, updates and other information from Cortex'**
  String get channelFcmDescription;

  /// The user-visible name for the engagement notification channel.
  ///
  /// In en, this message translates to:
  /// **'Friendly Reminders'**
  String get channelEngagementName;

  /// The user-visible description for the engagement notification channel.
  ///
  /// In en, this message translates to:
  /// **'Fun notifications to keep you engaged.'**
  String get channelEngagementDescription;

  /// The user-visible name for the greetings notification channel.
  ///
  /// In en, this message translates to:
  /// **'Daily Greetings'**
  String get channelGreetingsName;

  /// The user-visible description for the greetings notification channel.
  ///
  /// In en, this message translates to:
  /// **'The messages like good morning and good night.'**
  String get channelGreetingsDescription;

  /// No description provided for @loginToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginToYourAccount;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get createYourAccount;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get invalidPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get wrongPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get weakPassword;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get authError;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username.'**
  String get invalidUsername;

  /// No description provided for @usernameTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken.'**
  String get usernameTaken;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get authenticationFailed;

  /// No description provided for @emailTooLong.
  ///
  /// In en, this message translates to:
  /// **'Email can be at most 30 characters.'**
  String get emailTooLong;

  /// No description provided for @deviceLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached the account creation limit for this device.'**
  String get deviceLimitReached;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username is too short.'**
  String get usernameTooShort;

  /// No description provided for @usernameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Username cannot exceed 16 characters.'**
  String get usernameTooLong;

  /// No description provided for @invalidUsernameCharacters.
  ///
  /// In en, this message translates to:
  /// **'Only these letters: \'abcçdefgğhıijklmnoöprsştuüvyzxqw\' and the characters \'.\', \'-\', \'_\' can be used in the username.'**
  String get invalidUsernameCharacters;

  /// No description provided for @passwordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password cannot exceed 64 characters.'**
  String get passwordTooLong;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user account has been disabled.'**
  String get userDisabled;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your Vertex account. By continuing, you agree to our Terms of Service & Privacy Policy.'**
  String get loginSubtitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a Vertex account for seamless access across all our services. By continuing, you agree to our Terms of Service & Privacy Policy.'**
  String get registerSubtitle;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue without creating an account'**
  String get continueAsGuest;

  /// No description provided for @guestModeWarning.
  ///
  /// In en, this message translates to:
  /// **'Guest mode has limited features to ensure the best service quality.'**
  String get guestModeWarning;

  /// No description provided for @anonymousEntity.
  ///
  /// In en, this message translates to:
  /// **'Anonymous Entity'**
  String get anonymousEntity;

  /// No description provided for @upgradeAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Account'**
  String get upgradeAccountTitle;

  /// No description provided for @upgradeAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create an account to get daily 200 bonus credits and unlock more limits.'**
  String get upgradeAccountDescription;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @upgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finalize Registration'**
  String get upgradeTitle;

  /// No description provided for @accountLinkedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account successfully created!'**
  String get accountLinkedSuccess;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @betterWithAnAccount.
  ///
  /// In en, this message translates to:
  /// **'This section is better with an account!'**
  String get betterWithAnAccount;

  /// No description provided for @iHaveReadAndAgree.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the terms of service'**
  String get iHaveReadAndAgree;

  /// No description provided for @verificationEmailLimitReached.
  ///
  /// In en, this message translates to:
  /// **'We won\'t send anymore'**
  String get verificationEmailLimitReached;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification e-mail sent!'**
  String get verificationEmailSent;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'E-mail has not verified'**
  String get emailNotVerified;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend verification e-mail'**
  String get resendCode;

  /// No description provided for @remainingSeconds.
  ///
  /// In en, this message translates to:
  /// **'Remaining time for verification'**
  String get remainingSeconds;

  /// No description provided for @pleaseCheckYourEmail.
  ///
  /// In en, this message translates to:
  /// **'To use Cortex, you need to verify your email. \n A verification link has been sent to your email address, please check your email.'**
  String get pleaseCheckYourEmail;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get backToLogin;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @maxResendLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached the maximum number of verification emails'**
  String get maxResendLimitReached;

  /// No description provided for @verificationScreenContinueWithoutVerification.
  ///
  /// In en, this message translates to:
  /// **'Continue without verification'**
  String get verificationScreenContinueWithoutVerification;

  /// No description provided for @verificationScreenWarning.
  ///
  /// In en, this message translates to:
  /// **'Even if you continue, the 1-day account verification period is still in effect for your account. If you haven\'t verified your account by then, it will be deleted from the app.'**
  String get verificationScreenWarning;

  /// No description provided for @unverifiedAccountHeader.
  ///
  /// In en, this message translates to:
  /// **'Your account is not verified'**
  String get unverifiedAccountHeader;

  /// No description provided for @unverifiedAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'If you do not verify your account within {timeLeft}, it will be deleted'**
  String unverifiedAccountWarning(Object timeLeft, Object timeleft);

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @accountVerified.
  ///
  /// In en, this message translates to:
  /// **'Your account has been verified.'**
  String get accountVerified;

  /// No description provided for @linkSent.
  ///
  /// In en, this message translates to:
  /// **'Link sent'**
  String get linkSent;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternetConnection;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get anErrorOccurred;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaving so soon?'**
  String get exitAppTitle;

  /// No description provided for @exitAppConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this amazing platform?'**
  String get exitAppConfirmation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'az',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'ku',
    'nl',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'az':
      return AppLocalizationsAz();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ku':
      return AppLocalizationsKu();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
