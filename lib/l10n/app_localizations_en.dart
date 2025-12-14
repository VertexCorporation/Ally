// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ally';

  @override
  String get welcomeTitle => 'Ally';

  @override
  String get welcomeDescription => 'Your health\'s closest Ally.';

  @override
  String get letsStart => 'Let\'s start!';

  @override
  String get loginTitle => 'Login';

  @override
  String get continueAnonymously => 'Continue Anonymously';

  @override
  String get loginDescription => 'Sign in to continue';

  @override
  String get dailyReflection => 'Daily reflection';

  @override
  String get helloAnonymous => 'Hello, anonymous!';

  @override
  String get healthScore => 'Health Score';

  @override
  String get today => 'Today';

  @override
  String get of100 => 'of 100';

  @override
  String get exercises => 'Exercises';

  @override
  String dayStreak(int count) {
    return '$count day streak';
  }

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get nutrition => 'Nutrition';

  @override
  String calories(int count) {
    return '$count cal';
  }

  @override
  String get sleep => 'Sleep';

  @override
  String hours(String hours) {
    return '${hours}h';
  }

  @override
  String get water => 'Water';

  @override
  String waterGlasses(int current, int goal) {
    return '$current / $goal glasses';
  }

  @override
  String get weight => 'Weight';

  @override
  String weightKg(double weight) {
    return '$weight kg';
  }

  @override
  String get heartbeat => 'Heartbeat';

  @override
  String bpm(int bpm) {
    return '$bpm bpm';
  }

  @override
  String get pedometer => 'Steps';

  @override
  String steps(int current, int goal) {
    return 'steps';
  }

  @override
  String get home => 'Home';

  @override
  String get activity => 'Activity';

  @override
  String get achievements => 'Achievements';

  @override
  String get account => 'Account';

  @override
  String get settings => 'Settings';

  @override
  String get friendsActivity => 'Friends Activity';

  @override
  String get myActivity => 'My Activity';

  @override
  String get yourAchievements => 'Your achievements';

  @override
  String get totalPoints => 'Total Points';

  @override
  String get completedChallenges => 'Completed Challenges';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get days => 'days';

  @override
  String get completed => 'completed';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get add500Steps => 'Add 500 Steps';

  @override
  String get add1000Steps => 'Add 1000 Steps';

  @override
  String get setGoal => 'Set Goal';

  @override
  String get stepsGoal => 'Steps Goal';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get addExercise => 'Add Exercise';

  @override
  String get exerciseType => 'Exercise Type';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Strength';

  @override
  String get flexibility => 'Flexibility';

  @override
  String get sports => 'Sports';

  @override
  String get addNutrition => 'Add Nutrition';

  @override
  String get automatic => 'Automatic';

  @override
  String get manual => 'Manual';

  @override
  String get scanWithCamera => 'Scan with Camera';

  @override
  String get selectPlateType => 'Select Plate Type';

  @override
  String get plate => 'Plate';

  @override
  String get bowl => 'Bowl';

  @override
  String get smallPlate => 'Small Plate';

  @override
  String get mediumPlate => 'Medium Plate';

  @override
  String get largePlate => 'Large Plate';

  @override
  String get smallBowl => 'Small Bowl';

  @override
  String get mediumBowl => 'Medium Bowl';

  @override
  String get largeBowl => 'Large Bowl';

  @override
  String get fillLevel => 'Fill Level';

  @override
  String get quarter => '1/4 Full';

  @override
  String get half => '1/2 Full';

  @override
  String get threeQuarters => '3/4 Full';

  @override
  String get full => 'Full';

  @override
  String get selectFood => 'Select Food';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snacks => 'Snacks';

  @override
  String get egg => 'Egg';

  @override
  String get milk => 'Milk';

  @override
  String get yogurt => 'Yogurt';

  @override
  String get whiteRice => 'White Rice';

  @override
  String get plainPasta => 'Plain Pasta';

  @override
  String get chickenBreast => 'Chicken Breast';

  @override
  String get grilledSalmon => 'Grilled Salmon';

  @override
  String get boiledPotato => 'Boiled Potato';

  @override
  String get mixedVegetables => 'Mixed Vegetables';

  @override
  String get couscous => 'Couscous';

  @override
  String get quinoa => 'Quinoa';

  @override
  String get bulgur => 'Bulgur';

  @override
  String get corn => 'Corn';

  @override
  String get peas => 'Peas';

  @override
  String get broccoli => 'Broccoli';

  @override
  String get mushroom => 'Mushroom';

  @override
  String get stirFryVegetables => 'Stir-Fry Vegetables';

  @override
  String get sweetPotato => 'Sweet Potato';

  @override
  String get baldoRice => 'Baldo Rice';

  @override
  String get chickenCurry => 'Chicken Curry';

  @override
  String get beefCurry => 'Beef Curry';

  @override
  String get spaghettiPuttanesca => 'Spaghetti Puttanesca';

  @override
  String get ravioli => 'Ravioli';

  @override
  String get gnocchi => 'Gnocchi';

  @override
  String get kidneyBeans => 'Kidney Beans';

  @override
  String get chickpeas => 'Chickpeas';

  @override
  String get lentils => 'Lentils';

  @override
  String get whiteBeans => 'White Beans';

  @override
  String get tuna => 'Tuna';

  @override
  String get mussels => 'Mussels';

  @override
  String get shrimp => 'Shrimp';

  @override
  String get caesarSalad => 'Caesar Salad';

  @override
  String get tofu => 'Tofu';

  @override
  String get salad => 'Salad';

  @override
  String get soup => 'Soup';

  @override
  String get fruit => 'Fruit';

  @override
  String get vegetables => 'Vegetables';

  @override
  String get mealLog => 'Meal Log';

  @override
  String get todaysMeals => 'Today\'s Meals';

  @override
  String get noMealsYet => 'No meals added yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsDesc =>
      'Receive notifications for your activities';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get emailNotificationsDesc => 'Get updates via email';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get privacySettingsDesc => 'Manage your privacy preferences';

  @override
  String get dataStorage => 'Data & Storage';

  @override
  String get dataStorageDesc => 'Manage your data and storage';

  @override
  String get appSettings => 'App Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get units => 'Units';

  @override
  String get about => 'About';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get helpSupportDesc => 'Get help and contact support';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get termsConditionsDesc => 'Read our terms and conditions';

  @override
  String get aboutAlly => 'About Ally';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get selectUnits => 'Select Units';

  @override
  String get systemDefault => 'System Default';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get metric => 'Metric';

  @override
  String get imperial => 'Imperial';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get anonymousUser => 'Anonymous User';

  @override
  String get country => 'Country';

  @override
  String get unitedStates => 'United States';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get january1 => 'January 1, 1990';

  @override
  String get healthInfo => 'Health Information';

  @override
  String get currentWeight => 'Current Weight';

  @override
  String get waterGoal => 'Water Goal';

  @override
  String glassesPerDay(int count) {
    return '$count glasses/day';
  }

  @override
  String get calorieGoal => 'Calorie Goal';

  @override
  String kcalPerDay(int count) {
    return '$count kcal/day';
  }

  @override
  String get exerciseStreak => 'Exercise Streak';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountDesc => 'Permanently delete your account and data';

  @override
  String get noFriendsYet => 'No friends yet';

  @override
  String get addFriendsToSee => 'Add friends to see their activity';

  @override
  String get noActivityYet => 'No activity yet';

  @override
  String get startTrackingToSee => 'Start tracking to see your activity';

  @override
  String get badges => 'Badges';

  @override
  String get dayStreakLabel => 'Day Streak';

  @override
  String get availableAchievements => 'Available Achievements';

  @override
  String get hydrationHero => 'Hydration Hero';

  @override
  String get drink8Glasses => 'Drink 8 glasses of water daily';

  @override
  String get points => 'points';

  @override
  String get workoutWarrior => 'Workout Warrior';

  @override
  String get complete7Days => 'Complete 7 days of exercise';

  @override
  String get sleepChampion => 'Sleep Champion';

  @override
  String get get8Hours => 'Get 8 hours of sleep for 7 days';

  @override
  String get nutritionMaster => 'Nutrition Master';

  @override
  String get trackMeals => 'Track meals for 30 days';

  @override
  String get heartHealth => 'Heart Health';

  @override
  String get maintain60to100 => 'Maintain 60-100 bpm for a week';

  @override
  String get waterIntake => 'Water Intake';

  @override
  String get mealLogged => 'Meal Logged';

  @override
  String get sleepLogged => 'Sleep Logged';

  @override
  String get weightUpdated => 'Weight Updated';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get lastNight => 'Last night';

  @override
  String get thisWeek => 'This Week';

  @override
  String get sleepDuration => 'Sleep Duration';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get scoreBreakdown => 'Score Breakdown';

  @override
  String get loseWeight => 'Lose Weight';

  @override
  String get reduceCalories => 'Reduce calories';

  @override
  String get maintainWeight => 'Maintain Weight';

  @override
  String get balancedCalories => 'Balanced calories';

  @override
  String get gainWeight => 'Gain Weight';

  @override
  String get increaseCalories => 'Increase calories';

  @override
  String get activityLevel => 'Activity Level';

  @override
  String get sedentary => 'Sedentary';

  @override
  String get littleExercise => 'Little or no exercise';

  @override
  String get lightlyActive => 'Lightly Active';

  @override
  String get lightExercise => 'Light exercise 1-3 days/week';

  @override
  String get moderatelyActive => 'Moderately Active';

  @override
  String get moderateExercise => 'Moderate exercise 3-5 days/week';

  @override
  String get veryActive => 'Very Active';

  @override
  String get intenseTraining => 'Intense daily training';

  @override
  String get yourHealthScore => 'Your Health Score';

  @override
  String get outOf100 => 'out of 100';

  @override
  String get workoutStreakDesc => 'Workout streak and daily activity';

  @override
  String get sleepQualityDesc => 'Sleep duration and quality';

  @override
  String get hydrationGoalDesc => 'Daily hydration goal';

  @override
  String get weightProgressDesc => 'Progress towards target weight';

  @override
  String get calorieBalanceDesc => 'Calorie intake balance';

  @override
  String get restingHeartRateDesc => 'Resting heart rate';

  @override
  String get todaysIntake => 'Today\'s Intake';

  @override
  String get noMealsLogged => 'No meals logged yet';

  @override
  String get tapToAddMeal => 'Tap + to add your first meal';

  @override
  String get todaysPrograms => 'Today\'s Programs';

  @override
  String get noWorkoutsLogged => 'No workouts logged yet';

  @override
  String get startFitnessJourney => 'Start your fitness journey today!';

  @override
  String get noSleepData => 'No sleep data recorded';

  @override
  String get trackSleepPatterns => 'Track your sleep to see patterns';

  @override
  String get progress => 'Progress';

  @override
  String get noWeightHistory => 'No weight history';

  @override
  String get trackWeightProgress => 'Track your weight to see progress';

  @override
  String get currentHeartRate => 'Current Heart Rate';

  @override
  String get todaysReadings => 'Today\'s Readings';

  @override
  String get noReadingsYet => 'No readings yet';

  @override
  String get requiresMonitor => 'Requires heart rate monitor device';

  @override
  String get percentWeight => '% weight';

  @override
  String get tipMaintainStreak => 'Focus on maintaining your exercise streak';

  @override
  String get tipDrinkWater => 'Try to drink 2 more glasses of water today';

  @override
  String get tipBedtimeEarlier => 'Aim for 30 minutes earlier bedtime';

  @override
  String get weightGoalAchieved => 'Weight Goal Achieved';

  @override
  String get reachTargetWeight => 'Reach your target weight';

  @override
  String get welcomeToAlly => 'Welcome to Ally';

  @override
  String get personalHealthCompanion => 'Your personal health companion';

  @override
  String get trackWellnessJourney =>
      'Track your wellness journey with personalized goals and insights';

  @override
  String drankGlasses(int count) {
    return 'Drank $count glasses of water';
  }

  @override
  String caloriesConsumed(int count) {
    return '$count calories consumed';
  }

  @override
  String dayStreakMaintained(int count) {
    return '$count day streak maintained';
  }

  @override
  String hoursOfSleep(String hours) {
    return '$hours hours of sleep';
  }

  @override
  String get todaysOverview => 'Today\'s Overview';

  @override
  String get quickStats => 'Quick Stats';

  @override
  String get totalActivity => 'Total Activity';

  @override
  String get badgesEarned => 'Badges Earned';

  @override
  String get setYourGoals => 'Set Your Goals';

  @override
  String get manageYourProfile => 'Manage Your Profile';

  @override
  String get firstSteps => 'First Steps';

  @override
  String get firstStepsDesc => 'Complete your profile setup';

  @override
  String get earlyBird => 'Early Bird';

  @override
  String get earlyBirdDesc => 'Log 7 consecutive days';

  @override
  String get hydrationHeroDesc => 'Drink 8 glasses a day for 7 days';

  @override
  String get calorieCounter => 'Calorie Counter';

  @override
  String get calorieCounterDesc => 'Track meals for 30 days';

  @override
  String get weekWarrior => 'Week Warrior';

  @override
  String get weekWarriorDesc => 'Exercise 5 times a week';

  @override
  String get mileMaster => 'Mile Master';

  @override
  String get mileMasterDesc => 'Run a total of 100 miles';

  @override
  String get sleepChampionDesc => 'Get 8 hours sleep for 7 days';

  @override
  String get calculateCalorieNeeds =>
      'This helps us calculate your daily calorie needs';

  @override
  String get personalizeHealthGoals =>
      'We\'ll use this to personalize your health goals';

  @override
  String get tellUsAboutYourself => 'Tell us more about yourself';

  @override
  String get determinesCalorieTarget => 'This determines your calorie target';

  @override
  String get howActiveAreYou => 'How active are you on a typical day?';

  @override
  String get littleToNoExercise => 'Little to no exercise';

  @override
  String get intenseDailyTraining => 'Intense daily training';

  @override
  String get light => 'Light';

  @override
  String get lightActivity => '1-3 days/week';

  @override
  String get moderate => 'Moderate';

  @override
  String get moderateActivity => '3-5 days/week';

  @override
  String get active => 'Active';

  @override
  String get activeActivity => '6-7 days/week';

  @override
  String get editWeight => 'Edit Weight';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeYourPlan => 'Upgrade your Plan';

  @override
  String get unlockMore => 'Unlock More.';

  @override
  String get goPremium => 'Go Premium';

  @override
  String get upgradeForExclusive =>
      'Upgrade for exclusive perks and a smoother,\nfaster experience.';

  @override
  String get individual => 'Individual';

  @override
  String get family => 'Family';

  @override
  String get familyPlan => 'Family Plan';

  @override
  String get allyIndividual => 'Ally Individual';

  @override
  String get month => 'month';

  @override
  String get allIndividualFeatures =>
      'All Individual features plus\nfamily sharing for up to 4 members.';

  @override
  String get getAllyPlan => 'Get Ally Plan';

  @override
  String get getFamilyPlan => 'Get Family Plan';

  @override
  String get friendRequestSent => 'Friend Request Sent';

  @override
  String requestSentTo(String username) {
    return 'Request sent to $username successfully!';
  }

  @override
  String get selectExercise => 'Select Exercise';

  @override
  String get all => 'All';

  @override
  String get addExercisesToStart => 'Add exercises to start';

  @override
  String get tapPlusButton => 'Tap the + button below';

  @override
  String get reps => 'Reps';

  @override
  String get rest => 'Rest (s)';

  @override
  String get addSet => 'Add Set';

  @override
  String get workoutName => 'Workout Name';

  @override
  String get enterWorkoutName => 'Enter workout name';

  @override
  String get createWorkout => 'Create Workout';

  @override
  String get editWorkout => 'Edit Workout';

  @override
  String get deleteWorkout => 'Delete Workout';

  @override
  String get areYouSureDelete =>
      'Are you sure you want to delete this workout?';

  @override
  String get delete => 'Delete';

  @override
  String completedAt(String time) {
    return 'Completed at $time';
  }

  @override
  String get set => 'Set';

  @override
  String get quickExerciseLog => 'Quick Exercise Log';

  @override
  String get logYourExercise => 'Log your exercise';

  @override
  String get exerciseName => 'Exercise Name';

  @override
  String get enterExerciseName => 'Enter exercise name';

  @override
  String get sets => 'Sets';

  @override
  String get duration => 'Duration';

  @override
  String get minutes => 'minutes';

  @override
  String get logExercise => 'Log Exercise';

  @override
  String get close => 'Close';

  @override
  String get customProgram => 'Custom Program';

  @override
  String get buildYourOwnWorkout => 'Build your own workout';

  @override
  String get quickLog => 'Quick Log';

  @override
  String get logASingleExercise => 'Log a single exercise';

  @override
  String get noStreakYet => 'No streak yet';

  @override
  String get day => 'day';

  @override
  String get keepGoing => 'Keep going!';

  @override
  String get quickPrograms => 'Quick Programs';

  @override
  String get createProgramToQuicklyStart => 'Create a program to quickly start';

  @override
  String get min => 'min';

  @override
  String get ex => 'ex';

  @override
  String get editProgram => 'Edit Program';

  @override
  String get deleteProgram => 'Delete Program';

  @override
  String get deleteProgramQuestion => 'Delete Program?';

  @override
  String areYouSureDeleteProgram(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get logged => 'logged';

  @override
  String get kg => 'kg';

  @override
  String editSetNumber(int number) {
    return 'Edit Set $number';
  }

  @override
  String weightWithUnit(String unit) {
    return 'Weight ($unit)';
  }

  @override
  String get exerciseNotFound => 'Exercise not found';

  @override
  String get exitWorkout => 'Exit Workout?';

  @override
  String get progressNotSaved => 'Your progress will not be saved.';

  @override
  String get exit => 'Exit';

  @override
  String get finish => 'Finish';

  @override
  String exerciseProgress(int current, int total) {
    return 'Exercise $current/$total';
  }

  @override
  String percentComplete(int percent) {
    return '$percent% Complete';
  }

  @override
  String get restTime => 'Rest Time';

  @override
  String get skip => 'Skip';

  @override
  String get repsLowercase => 'reps';

  @override
  String get kgUnit => 'kg';

  @override
  String get workoutNotComplete => 'Workout Not Complete';

  @override
  String get workoutNotCompleteMessage =>
      'You haven\'t finished all sets. Do you want to save your progress and finish anyway?';

  @override
  String get finishAnyway => 'Finish Anyway';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get workoutCompleted => 'Workout Completed!';

  @override
  String get enableStepTracking => 'Enable Step Tracking';

  @override
  String get stepPermissionMessage =>
      'We need activity recognition permission to count your steps in the background.';

  @override
  String get later => 'Later';

  @override
  String get allow => 'Allow';

  @override
  String get stepTrackingEnabled => '✅ Step tracking enabled!';

  @override
  String get permissionDenied => '⚠️ Permission denied';

  @override
  String get profile => 'Profile';

  @override
  String get yourProfile => 'Your Profile';

  @override
  String get support => 'Support';

  @override
  String get legal => 'Legal';

  @override
  String get healthClosestAlly => 'Your health\'s closest Ally.';

  @override
  String get openingWebsite => 'Opening website...';

  @override
  String get visitWebsite => 'Visit Website';

  @override
  String get licensedApache => 'Licensed under Apache License 2.0';

  @override
  String get licensedApache2 => 'Licensed under Apache 2.0';

  @override
  String get copyright => '© 2025 Vertex Corporation';

  @override
  String get readPolicies => 'Read our policies and terms';

  @override
  String get openingPrivacyPolicy => 'Opening Privacy Policy...';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get openingTerms => 'Opening Terms of Service...';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get editWaterGoal => 'Edit Water Goal';

  @override
  String get glasses => 'glasses';

  @override
  String get editCalorieGoal => 'Edit Calorie Goal';

  @override
  String get kcal => 'kcal';

  @override
  String get goalWeight => 'Goal Weight';

  @override
  String get editHeight => 'Edit Height';

  @override
  String get height => 'Height';

  @override
  String get cm => 'cm';

  @override
  String get feet => 'Feet';

  @override
  String get inches => 'Inches';

  @override
  String get bodyMassIndex => 'Body Mass Index (BMI)';

  @override
  String get notCalculated => 'Not calculated';

  @override
  String get addHeightWeight => 'Add height and weight';

  @override
  String get noAchievementsYet => 'No Achievements Yet';

  @override
  String get startTrackingForAchievements =>
      'Start tracking your health to unlock achievements!';

  @override
  String get authFailed => 'Authentication failed. Continuing without login.';

  @override
  String get firebaseNotConfigured =>
      'Firebase not configured. Use anonymous login.';

  @override
  String get googleSignInFailed =>
      'Google sign in failed. Use anonymous login instead.';

  @override
  String emailSignInFailed(String error) {
    return 'Email sign in failed: $error';
  }

  @override
  String get signIn => 'Sign in';

  @override
  String get chooseSignInMethod => 'Choose your sign in method';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithEmail => 'Continue with Email';

  @override
  String get continueAsAnonymous => 'Continue as Anonymous';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get legalAgreement =>
      'By signing in/up, you agree to our Privacy Policy and Terms of Service';

  @override
  String get signInWithEmail => 'Sign in with email';

  @override
  String get enterEmailAddress => 'Enter your email address';

  @override
  String get email => 'Email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get password => 'Password';

  @override
  String get firebaseNotConfiguredSignup =>
      'Firebase not configured. Continuing without registration.';

  @override
  String signUpFailed(String error) {
    return 'Sign up failed: $error';
  }

  @override
  String get chooseUsername => 'Choose your username';

  @override
  String get username => 'Username';

  @override
  String get createPassword => 'Create a password';

  @override
  String get back => 'Back';

  @override
  String get startJourney => 'Start Journey';

  @override
  String get continueAlly => 'Continue';

  @override
  String get chooseUnits => 'Choose your units';

  @override
  String get selectSystemPrefer => 'Select the system you prefer';

  @override
  String get kgCm => 'kg, cm';

  @override
  String get lbsIn => 'lbs, in';

  @override
  String get whatsYourWeight => 'What\'s your weight?';

  @override
  String get personalizeJourney => 'Help us personalize your journey';

  @override
  String get whatsYourHeight => 'What\'s your height?';

  @override
  String get calculateIdealMetrics => 'We\'ll calculate your ideal metrics';

  @override
  String get whatsYourAge => 'What\'s your age?';

  @override
  String get createPerfectPlan => 'Let\'s create your perfect health plan';

  @override
  String get years => 'years';

  @override
  String get dailyStepGoal => 'Daily step goal';

  @override
  String weightPercent(int weight) {
    return '$weight% weight';
  }

  @override
  String get ally => 'Ally';

  @override
  String get yourHealths => 'Your health\'s\n';

  @override
  String get closest => 'closest ';

  @override
  String get getStarted => 'Get Started';

  @override
  String get service => 'Service';

  @override
  String get automaticSleepTracking => 'Automatic Sleep Tracking';

  @override
  String get noSmartwatchNeeded =>
      'No smartwatch needed! Track your sleep automatically.';

  @override
  String get whenDoYouSleep => 'When do you usually sleep?';

  @override
  String get sleepTime => 'Sleep Time';

  @override
  String get wakeTime => 'Wake Time';

  @override
  String get sleepTrackingTitle => 'Sleep Tracking';

  @override
  String get automaticTrackingEnabled => 'Automatic tracking enabled';

  @override
  String get startTracking => 'Start Tracking';

  @override
  String get sleepSegments => 'Sleep Segments';

  @override
  String get sleepCycles => 'Sleep Cycles';

  @override
  String get wakeUps => 'Wake Ups';

  @override
  String get noSleepDataYet => 'No sleep data yet';

  @override
  String get sleepTrackingStartTonight => 'Sleep tracking will start tonight';

  @override
  String get currentlySleeping => 'Currently Sleeping';

  @override
  String sleepSegmentNumber(int number) {
    return 'Sleep Segment $number';
  }

  @override
  String get setWaterGoal => 'Set Your Water Goal';

  @override
  String get howMuchWater => 'How much water do you want to drink daily?';

  @override
  String get goalUpdated => 'Goal Updated';

  @override
  String get editGoal => 'Edit Goal';

  @override
  String get quickAdd => 'Quick Add';

  @override
  String get updateWeight => 'Update Weight';

  @override
  String enterWeight(String unit) {
    return 'Enter weight ($unit)';
  }

  @override
  String get weightHistory => 'Weight History';

  @override
  String get startTrackingWeight => 'Start tracking your weight progress';

  @override
  String get setCalorieGoal => 'Set Your Calorie Goal';

  @override
  String get howManyCalories =>
      'How many calories do you want to consume daily?';

  @override
  String get goalSet => 'Goal Set';

  @override
  String calorieGoalSet(int calories) {
    return 'Your daily calorie goal is now $calories kcal';
  }

  @override
  String get addFriend => 'Add Friend';

  @override
  String get welcomeText1 => 'Your health\'s';

  @override
  String get welcomeText2 => 'closest';

  @override
  String get welcomeText3 => 'Ally';

  @override
  String get serviceControls => 'Service Controls';

  @override
  String get startService => 'Start Service';

  @override
  String get restartService => 'Restart Service';

  @override
  String get stopService => 'Stop Service';

  @override
  String get setYourGoal => 'Set Your Goal';

  @override
  String get howManySteps => 'How many steps do you want to achieve today?';

  @override
  String get serviceStarted => 'Service Started';

  @override
  String get serviceStartedDesc => 'Step counter service is now running';

  @override
  String get serviceRestarted => 'Service Restarted';

  @override
  String get serviceRestartedDesc => 'Step counter service has been restarted';

  @override
  String get serviceStopped => 'Service Stopped';

  @override
  String get serviceStoppedDesc => 'Step counter service has been stopped';

  @override
  String dailyGoalSet(Object goal) {
    return 'Your daily goal is now $goal steps';
  }

  @override
  String get stepsLabel => 'steps';

  @override
  String get ageHint => '5';

  @override
  String get heightFeetHint => '9';

  @override
  String get weightLbsHint => '170';

  @override
  String get calorieGoalHint => '25';

  @override
  String get defaultStepGoal => '6000';

  @override
  String get programNameHint => 'Program name (e.g. Push Day)';

  @override
  String get usernameHint => 'Username';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get dailyCalorieHint => '2000';

  @override
  String get usernameAtHint => '@username';

  @override
  String programUpdated(String name) {
    return 'Program \"$name\" updated!';
  }

  @override
  String programSaved(String name) {
    return 'Program \"$name\" saved!';
  }

  @override
  String valueOfTarget(String value, String target) {
    return '$value of $target';
  }

  @override
  String valueSlashTarget(String value, String target) {
    return '$value/$target';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String ofValueUnit(String value, String unit) {
    return 'of $value$unit';
  }

  @override
  String bmiValue(String value) {
    return 'BMI: $value';
  }

  @override
  String gramsAmount(String grams) {
    return '~${grams}g';
  }

  @override
  String caloriesAmount(String calories) {
    return '~$calories cal';
  }

  @override
  String caloriesPer100g(String calories) {
    return '($calories/100g)';
  }

  @override
  String get licensedApache2Short => 'Licensed under Apache 2.0';

  @override
  String get waterGoalLabel => 'Water Goal';

  @override
  String get calorieGoalLabel => 'Calorie Goal';

  @override
  String get enterWeightLbs => 'Enter weight (lbs)';

  @override
  String get enterWeightKg => 'Enter weight (kg)';

  @override
  String bmiLabel(String value) {
    return 'BMI: $value';
  }

  @override
  String currentSlashTarget(String current, String target) {
    return '$current / $target';
  }

  @override
  String scoreSlashWeight(String score, String weight) {
    return '$score/$weight';
  }

  @override
  String get bpmUnit => 'BPM';

  @override
  String ofHoursGoal(String hours) {
    return 'of ${hours}h';
  }

  @override
  String get nowLabel => 'Now';

  @override
  String dailyGoalSetTo(String value, String unit) {
    return 'Daily goal set to $value$unit';
  }

  @override
  String foodSelectionSubtitle(
    String plateType,
    String fillTitle,
    String grams,
  ) {
    return '$plateType - $fillTitle (~${grams}g)';
  }

  @override
  String get enterFriendUsername =>
      'Enter your friend\'s username to follow their activity';

  @override
  String get sendRequest => 'Send Request';

  @override
  String subscribeToPlan(String title) {
    return 'Subscribe to $title plan';
  }

  @override
  String restSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get setYourCalorieGoal => 'Set Your Calorie Goal';

  @override
  String get workoutBuilder => 'Workout Builder';

  @override
  String get whenDoYouUsuallySleep => 'When do you usually sleep?';

  @override
  String get sleepTrackingWillStartTonight =>
      'Sleep tracking will start tonight';
}
