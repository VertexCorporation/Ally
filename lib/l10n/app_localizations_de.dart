// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Ally';

  @override
  String get welcomeTitle => 'Ally';

  @override
  String get welcomeDescription => 'Der engste Verbündete Ihrer Gesundheit.';

  @override
  String get letsStart => 'Lass uns anfangen!';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get continueAnonymously => 'Anonym fortfahren';

  @override
  String get loginDescription => 'Melden Sie sich an, um fortzufahren';

  @override
  String get dailyReflection => 'Tägliche Reflexion';

  @override
  String get helloAnonymous => 'Hallo, Anonym!';

  @override
  String get healthScore => 'Gesundheitswert';

  @override
  String get today => 'Heute';

  @override
  String get of100 => 'von 100';

  @override
  String get exercises => 'Übungen';

  @override
  String dayStreak(int count) {
    return '$count Tage in Folge';
  }

  @override
  String daysCount(int count) {
    return '$count Tage';
  }

  @override
  String get nutrition => 'Ernährung';

  @override
  String calories(int count) {
    return '$count Kal';
  }

  @override
  String get sleep => 'Schlaf';

  @override
  String hours(String hours) {
    return '${hours}h';
  }

  @override
  String get water => 'Wasser';

  @override
  String waterGlasses(int current, int goal) {
    return '$current / $goal Gläser';
  }

  @override
  String get weight => 'Gewicht';

  @override
  String weightKg(double weight) {
    return '$weight kg';
  }

  @override
  String get heartbeat => 'Herzschlag';

  @override
  String bpm(int bpm) {
    return '$bpm Schläge/Min';
  }

  @override
  String get pedometer => 'Schritte';

  @override
  String steps(int current, int goal) {
    return 'Schritte';
  }

  @override
  String get home => 'Startseite';

  @override
  String get activity => 'Aktivität';

  @override
  String get achievements => 'Erfolge';

  @override
  String get account => 'Konto';

  @override
  String get settings => 'Einstellungen';

  @override
  String get friendsActivity => 'Freundesaktivität';

  @override
  String get myActivity => 'Meine Aktivität';

  @override
  String get yourAchievements => 'Ihre Erfolge';

  @override
  String get totalPoints => 'Gesamtpunkte';

  @override
  String get completedChallenges => 'Abgeschlossene Herausforderungen';

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String get days => 'Tage';

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
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get addExercise => 'Übung Hinzufügen';

  @override
  String get exerciseType => 'Exercise Type';

  @override
  String get cardio => 'Kardio';

  @override
  String get strength => 'Kraft';

  @override
  String get flexibility => 'Flexibilität';

  @override
  String get sports => 'Sport';

  @override
  String get addNutrition => 'Ernährung Hinzufügen';

  @override
  String get automatic => 'Automatisch';

  @override
  String get manual => 'Manuell';

  @override
  String get scanWithCamera => 'Mit Kamera Scannen';

  @override
  String get selectPlateType => 'Tellertyp Auswählen';

  @override
  String get plate => 'Teller';

  @override
  String get bowl => 'Schale';

  @override
  String get smallPlate => 'Kleiner Teller';

  @override
  String get mediumPlate => 'Mittlerer Teller';

  @override
  String get largePlate => 'Großer Teller';

  @override
  String get smallBowl => 'Kleine Schale';

  @override
  String get mediumBowl => 'Mittlere Schale';

  @override
  String get largeBowl => 'Große Schale';

  @override
  String get fillLevel => 'Füllstand';

  @override
  String get quarter => '1/4 Voll';

  @override
  String get half => '1/2 Voll';

  @override
  String get threeQuarters => '3/4 Voll';

  @override
  String get full => 'Voll';

  @override
  String get selectFood => 'Lebensmittel Auswählen';

  @override
  String get breakfast => 'Frühstück';

  @override
  String get lunch => 'Mittagessen';

  @override
  String get dinner => 'Abendessen';

  @override
  String get snacks => 'Snacks';

  @override
  String get egg => 'Ei';

  @override
  String get milk => 'Milch';

  @override
  String get yogurt => 'Joghurt';

  @override
  String get whiteRice => 'Weißer Reis';

  @override
  String get plainPasta => 'Nudeln Natur';

  @override
  String get chickenBreast => 'Hähnchenbrust';

  @override
  String get grilledSalmon => 'Gegrillter Lachs';

  @override
  String get boiledPotato => 'Gekochte Kartoffel';

  @override
  String get mixedVegetables => 'Gemischtes Gemüse';

  @override
  String get couscous => 'Couscous';

  @override
  String get quinoa => 'Quinoa';

  @override
  String get bulgur => 'Bulgur';

  @override
  String get corn => 'Mais';

  @override
  String get peas => 'Erbsen';

  @override
  String get broccoli => 'Brokkoli';

  @override
  String get mushroom => 'Pilz';

  @override
  String get stirFryVegetables => 'Gebratenes Gemüse';

  @override
  String get sweetPotato => 'Süßkartoffel';

  @override
  String get baldoRice => 'Baldo Reis';

  @override
  String get chickenCurry => 'Hähnchen-Curry';

  @override
  String get beefCurry => 'Rindfleisch-Curry';

  @override
  String get spaghettiPuttanesca => 'Spaghetti Puttanesca';

  @override
  String get ravioli => 'Ravioli';

  @override
  String get gnocchi => 'Gnocchi';

  @override
  String get kidneyBeans => 'Rote Bohnen';

  @override
  String get chickpeas => 'Kichererbsen';

  @override
  String get lentils => 'Linsen';

  @override
  String get whiteBeans => 'Weiße Bohnen';

  @override
  String get tuna => 'Thunfisch';

  @override
  String get mussels => 'Muscheln';

  @override
  String get shrimp => 'Garnele';

  @override
  String get caesarSalad => 'Caesar-Salat';

  @override
  String get tofu => 'Tofu';

  @override
  String get salad => 'Salat';

  @override
  String get soup => 'Suppe';

  @override
  String get fruit => 'Obst';

  @override
  String get vegetables => 'Gemüse';

  @override
  String get mealLog => 'Mahlzeitenprotokoll';

  @override
  String get todaysMeals => 'Heutige Mahlzeiten';

  @override
  String get noMealsYet => 'Noch keine Mahlzeiten hinzugefügt';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get pushNotifications => 'Push-Benachrichtigungen';

  @override
  String get pushNotificationsDesc =>
      'Erhalten Sie Benachrichtigungen für Ihre Aktivitäten';

  @override
  String get emailNotifications => 'E-Mail-Benachrichtigungen';

  @override
  String get emailNotificationsDesc => 'Erhalten Sie Updates per E-Mail';

  @override
  String get privacySecurity => 'Datenschutz und Sicherheit';

  @override
  String get privacySettings => 'Datenschutzeinstellungen';

  @override
  String get privacySettingsDesc =>
      'Verwalten Sie Ihre Datenschutzeinstellungen';

  @override
  String get dataStorage => 'Daten und Speicher';

  @override
  String get dataStorageDesc => 'Verwalten Sie Ihre Daten und Ihren Speicher';

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Thema';

  @override
  String get units => 'Einheiten';

  @override
  String get about => 'Über';

  @override
  String get helpSupport => 'Hilfe und Support';

  @override
  String get helpSupportDesc =>
      'Erhalten Sie Hilfe und kontaktieren Sie den Support';

  @override
  String get termsConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get termsConditionsDesc => 'Lesen Sie unsere Geschäftsbedingungen';

  @override
  String get aboutAlly => 'Über Ally';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get selectTheme => 'Thema auswählen';

  @override
  String get selectUnits => 'Einheiten auswählen';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get metric => 'Metrisch';

  @override
  String get imperial => 'Imperial';

  @override
  String get personalInfo => 'Persönliche Informationen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get anonymousUser => 'Anonymer Benutzer';

  @override
  String get country => 'Land';

  @override
  String get unitedStates => 'Vereinigte Staaten';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get january1 => '1. Januar 1990';

  @override
  String get healthInfo => 'Gesundheitsinformationen';

  @override
  String get currentWeight => 'Aktuelles Gewicht';

  @override
  String get waterGoal => 'Wasserziel';

  @override
  String glassesPerDay(int count) {
    return '$count Gläser/Tag';
  }

  @override
  String get calorieGoal => 'Kalorienziel';

  @override
  String kcalPerDay(int count) {
    return '$count kcal/Tag';
  }

  @override
  String get exerciseStreak => 'Übungsserie';

  @override
  String get dangerZone => 'Gefahrenzone';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountDesc =>
      'Löschen Sie Ihr Konto und Ihre Daten dauerhaft';

  @override
  String get noFriendsYet => 'Noch keine Freunde';

  @override
  String get addFriendsToSee =>
      'Fügen Sie Freunde hinzu, um deren Aktivität zu sehen';

  @override
  String get noActivityYet => 'Noch keine Aktivität';

  @override
  String get startTrackingToSee =>
      'Beginnen Sie mit der Verfolgung, um Ihre Aktivität zu sehen';

  @override
  String get badges => 'Abzeichen';

  @override
  String get dayStreakLabel => 'Tägliche Serie';

  @override
  String get availableAchievements => 'Verfügbare Erfolge';

  @override
  String get hydrationHero => 'Hydrations-Held';

  @override
  String get drink8Glasses => 'Trinken Sie täglich 8 Gläser Wasser';

  @override
  String get points => 'Punkte';

  @override
  String get workoutWarrior => 'Trainingskrieger';

  @override
  String get complete7Days => 'Absolvieren Sie 7 Tage Training';

  @override
  String get sleepChampion => 'Schlaf-Champion';

  @override
  String get get8Hours => 'Schlafen Sie 7 Tage lang 8 Stunden';

  @override
  String get nutritionMaster => 'Ernährungsmeister';

  @override
  String get trackMeals => 'Verfolgen Sie Mahlzeiten für 30 Tage';

  @override
  String get heartHealth => 'Herzgesundheit';

  @override
  String get maintain60to100 => 'Halten Sie eine Woche lang 60-100 Schläge/Min';

  @override
  String get waterIntake => 'Wasseraufnahme';

  @override
  String get mealLogged => 'Mahlzeit protokolliert';

  @override
  String get sleepLogged => 'Schlaf protokolliert';

  @override
  String get weightUpdated => 'Gewicht aktualisiert';

  @override
  String get justNow => 'Gerade eben';

  @override
  String minutesAgo(int minutes) {
    return 'Vor ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'Vor ${hours}h';
  }

  @override
  String get lastNight => 'Letzte Nacht';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get sleepDuration => 'Schlafdauer';

  @override
  String get heartRate => 'Herzfrequenz';

  @override
  String get scoreBreakdown => 'Score-Aufschlüsselung';

  @override
  String get loseWeight => 'Gewicht Verlieren';

  @override
  String get reduceCalories => 'Kalorien reduzieren';

  @override
  String get maintainWeight => 'Gewicht Halten';

  @override
  String get balancedCalories => 'Ausgewogene Kalorien';

  @override
  String get gainWeight => 'Gewicht Zunehmen';

  @override
  String get increaseCalories => 'Kalorien erhöhen';

  @override
  String get activityLevel => 'Aktivitätsniveau';

  @override
  String get sedentary => 'Sitzend';

  @override
  String get littleExercise => 'Wenig oder keine Bewegung';

  @override
  String get lightlyActive => 'Leicht aktiv';

  @override
  String get lightExercise => 'Leichte Übung 1-3 Tage/Woche';

  @override
  String get moderatelyActive => 'Mäßig aktiv';

  @override
  String get moderateExercise => 'Mäßige Übung 3-5 Tage/Woche';

  @override
  String get veryActive => 'Sehr Aktiv';

  @override
  String get intenseTraining => 'Intensives tägliches Training';

  @override
  String get yourHealthScore => 'Ihre Gesundheitsbewertung';

  @override
  String get outOf100 => 'von 100';

  @override
  String get workoutStreakDesc => 'Trainingsserie und tägliche Aktivität';

  @override
  String get sleepQualityDesc => 'Schlafdauer und -qualität';

  @override
  String get hydrationGoalDesc => 'Tägliches Hydrationsziel';

  @override
  String get weightProgressDesc => 'Fortschritt zum Zielgewicht';

  @override
  String get calorieBalanceDesc => 'Kalorienaufnahme-Balance';

  @override
  String get restingHeartRateDesc => 'Ruhepuls';

  @override
  String get todaysIntake => 'Heutige Aufnahme';

  @override
  String get noMealsLogged => 'Noch keine Mahlzeiten erfasst';

  @override
  String get tapToAddMeal =>
      'Tippen Sie auf +, um Ihre erste Mahlzeit hinzuzufügen';

  @override
  String get todaysPrograms => 'Heutige Programme';

  @override
  String get noWorkoutsLogged => 'Noch keine Trainings erfasst';

  @override
  String get startFitnessJourney => 'Beginnen Sie heute Ihre Fitness-Reise!';

  @override
  String get noSleepData => 'Keine Schlafdaten erfasst';

  @override
  String get trackSleepPatterns =>
      'Verfolgen Sie Ihren Schlaf, um Muster zu sehen';

  @override
  String get progress => 'Fortschritt';

  @override
  String get noWeightHistory => 'Kein Gewichtsverlauf';

  @override
  String get trackWeightProgress =>
      'Verfolgen Sie Ihr Gewicht, um Fortschritte zu sehen';

  @override
  String get currentHeartRate => 'Aktuelle Herzfrequenz';

  @override
  String get todaysReadings => 'Heutige Messwerte';

  @override
  String get noReadingsYet => 'Noch keine Messwerte';

  @override
  String get requiresMonitor => 'Erfordert Herzfrequenz-Überwachungsgerät';

  @override
  String get percentWeight => '% Gewicht';

  @override
  String get tipMaintainStreak =>
      'Konzentrieren Sie sich darauf, Ihre Trainingsserie aufrechtzuerhalten';

  @override
  String get tipDrinkWater =>
      'Versuchen Sie heute 2 Gläser Wasser mehr zu trinken';

  @override
  String get tipBedtimeEarlier =>
      'Streben Sie 30 Minuten frühere Schlafenszeit an';

  @override
  String get weightGoalAchieved => 'Gewichtsziel Erreicht';

  @override
  String get reachTargetWeight => 'Erreichen Sie Ihr Zielgewicht';

  @override
  String get welcomeToAlly => 'Willkommen bei Ally';

  @override
  String get personalHealthCompanion => 'Ihr persönlicher Gesundheitsbegleiter';

  @override
  String get trackWellnessJourney =>
      'Verfolgen Sie Ihre Wellness-Reise mit personalisierten Zielen und Einblicken';

  @override
  String drankGlasses(int count) {
    return '$count Gläser Wasser getrunken';
  }

  @override
  String caloriesConsumed(int count) {
    return '$count Kalorien konsumiert';
  }

  @override
  String dayStreakMaintained(int count) {
    return '$count-Tage-Serie aufrechterhalten';
  }

  @override
  String hoursOfSleep(String hours) {
    return '$hours Stunden Schlaf';
  }

  @override
  String get todaysOverview => 'Heutige Übersicht';

  @override
  String get quickStats => 'Schnellstatistiken';

  @override
  String get totalActivity => 'Gesamtaktivität';

  @override
  String get badgesEarned => 'Verdiente Abzeichen';

  @override
  String get setYourGoals => 'Setze Deine Ziele';

  @override
  String get manageYourProfile => 'Verwalte Dein Profil';

  @override
  String get firstSteps => 'Erste Schritte';

  @override
  String get firstStepsDesc => 'Vervollständige deine Profilkonfiguration';

  @override
  String get earlyBird => 'Frühaufsteher';

  @override
  String get earlyBirdDesc => '7 aufeinanderfolgende Tage aufzeichnen';

  @override
  String get hydrationHeroDesc => 'Trinke 7 Tage lang 8 Gläser pro Tag';

  @override
  String get calorieCounter => 'Kalorienzähler';

  @override
  String get calorieCounterDesc => 'Verfolge Mahlzeiten für 30 Tage';

  @override
  String get weekWarrior => 'Wochen-Krieger';

  @override
  String get weekWarriorDesc => 'Trainiere 5 Mal pro Woche';

  @override
  String get mileMaster => 'Meilen-Meister';

  @override
  String get mileMasterDesc => 'Laufe insgesamt 100 Meilen';

  @override
  String get sleepChampionDesc => 'Schlafe 7 Tage lang 8 Stunden';

  @override
  String get calculateCalorieNeeds =>
      'Dies hilft uns, Ihren täglichen Kalorienbedarf zu berechnen';

  @override
  String get personalizeHealthGoals =>
      'Wir verwenden dies, um Ihre Gesundheitsziele zu personalisieren';

  @override
  String get tellUsAboutYourself => 'Erzählen Sie uns mehr über sich';

  @override
  String get determinesCalorieTarget => 'Dies bestimmt Ihr Kalorienziel';

  @override
  String get howActiveAreYou => 'Wie aktiv sind Sie an einem typischen Tag?';

  @override
  String get littleToNoExercise => 'Wenig bis keine Bewegung';

  @override
  String get intenseDailyTraining => 'Intensives tägliches Training';

  @override
  String get light => 'Leicht';

  @override
  String get lightActivity => '1-3 Tage/Woche';

  @override
  String get moderate => 'Mäßig';

  @override
  String get moderateActivity => '3-5 Tage/Woche';

  @override
  String get active => 'Aktiv';

  @override
  String get activeActivity => '6-7 Tage/Woche';

  @override
  String get editWeight => 'Edit Weight';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeYourPlan => 'Upgraden Sie Ihren Plan';

  @override
  String get unlockMore => 'Mehr Freischalten.';

  @override
  String get goPremium => 'Zu Premium Wechseln';

  @override
  String get upgradeForExclusive =>
      'Upgraden Sie für exklusive Vorteile und ein flüssigeres,\nschnelleres Erlebnis.';

  @override
  String get individual => 'Einzelperson';

  @override
  String get family => 'Familie';

  @override
  String get familyPlan => 'Familienplan';

  @override
  String get allyIndividual => 'Ally Einzelperson';

  @override
  String get month => 'Monat';

  @override
  String get allIndividualFeatures =>
      'Alle Einzelperson-Funktionen plus\nFamilienfreigabe für bis zu 4 Mitglieder.';

  @override
  String get getAllyPlan => 'Ally Plan Erhalten';

  @override
  String get getFamilyPlan => 'Familienplan Erhalten';

  @override
  String get friendRequestSent => 'Freundschaftsanfrage Gesendet';

  @override
  String requestSentTo(String username) {
    return 'Anfrage erfolgreich an $username gesendet!';
  }

  @override
  String get selectExercise => 'Übung Auswählen';

  @override
  String get all => 'Alle';

  @override
  String get addExercisesToStart => 'Fügen Sie Übungen hinzu, um zu beginnen';

  @override
  String get tapPlusButton => 'Tippen Sie auf die Schaltfläche + unten';

  @override
  String get reps => 'Wiederholungen';

  @override
  String get rest => 'Ruhe (s)';

  @override
  String get addSet => 'Satz Hinzufügen';

  @override
  String get workoutName => 'Trainingsnamen';

  @override
  String get enterWorkoutName => 'Geben Sie den Trainingsnamen ein';

  @override
  String get createWorkout => 'Training Erstellen';

  @override
  String get editWorkout => 'Training Bearbeiten';

  @override
  String get deleteWorkout => 'Training Löschen';

  @override
  String get areYouSureDelete =>
      'Sind Sie sicher, dass Sie dieses Training löschen möchten?';

  @override
  String get delete => 'Löschen';

  @override
  String completedAt(String time) {
    return 'Abgeschlossen um $time';
  }

  @override
  String get set => 'Satz';

  @override
  String get quickExerciseLog => 'Schnelles Trainingsprotokoll';

  @override
  String get logYourExercise => 'Protokollieren Sie Ihr Training';

  @override
  String get exerciseName => 'Übungsname';

  @override
  String get enterExerciseName => 'Geben Sie den Übungsnamen ein';

  @override
  String get sets => 'Sätze';

  @override
  String get duration => 'Dauer';

  @override
  String get minutes => 'Minuten';

  @override
  String get logExercise => 'Training Protokollieren';

  @override
  String get close => 'Schließen';

  @override
  String get customProgram => 'Benutzerdefiniertes Programm';

  @override
  String get buildYourOwnWorkout => 'Erstellen Sie Ihr eigenes Training';

  @override
  String get quickLog => 'Schnellprotokoll';

  @override
  String get logASingleExercise => 'Eine einzelne Übung protokollieren';

  @override
  String get noStreakYet => 'Noch keine Serie';

  @override
  String get day => 'Tag';

  @override
  String get keepGoing => 'Mach weiter!';

  @override
  String get quickPrograms => 'Schnellprogramme';

  @override
  String get createProgramToQuicklyStart =>
      'Erstellen Sie ein Programm für einen schnellen Start';

  @override
  String get min => 'Min';

  @override
  String get ex => 'Üb';

  @override
  String get editProgram => 'Programm Bearbeiten';

  @override
  String get deleteProgram => 'Programm Löschen';

  @override
  String get deleteProgramQuestion => 'Programm Löschen?';

  @override
  String areYouSureDeleteProgram(String name) {
    return 'Sind Sie sicher, dass Sie \"$name\" löschen möchten?';
  }

  @override
  String get logged => 'protokolliert';

  @override
  String get kg => 'kg';

  @override
  String editSetNumber(int number) {
    return 'Satz $number Bearbeiten';
  }

  @override
  String weightWithUnit(String unit) {
    return 'Gewicht ($unit)';
  }

  @override
  String get exerciseNotFound => 'Übung nicht gefunden';

  @override
  String get exitWorkout => 'Training Beenden?';

  @override
  String get progressNotSaved => 'Ihr Fortschritt wird nicht gespeichert.';

  @override
  String get exit => 'Beenden';

  @override
  String get finish => 'Fertigstellen';

  @override
  String exerciseProgress(int current, int total) {
    return 'Übung $current/$total';
  }

  @override
  String percentComplete(int percent) {
    return '$percent% Abgeschlossen';
  }

  @override
  String get restTime => 'Ruhezeit';

  @override
  String get skip => 'Überspringen';

  @override
  String get repsLowercase => 'wiederholungen';

  @override
  String get kgUnit => 'kg';

  @override
  String get workoutNotComplete => 'Training Nicht Abgeschlossen';

  @override
  String get workoutNotCompleteMessage =>
      'Sie haben nicht alle Sätze beendet. Möchten Sie Ihren Fortschritt speichern und trotzdem beenden?';

  @override
  String get finishAnyway => 'Trotzdem Beenden';

  @override
  String get previous => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get workoutCompleted => 'Training Abgeschlossen!';

  @override
  String get enableStepTracking => 'Schrittzählung Aktivieren';

  @override
  String get stepPermissionMessage =>
      'Wir benötigen die Aktivitätserkennungsberechtigung, um Ihre Schritte im Hintergrund zu zählen.';

  @override
  String get later => 'Später';

  @override
  String get allow => 'Erlauben';

  @override
  String get stepTrackingEnabled => '✅ Schrittverfolgung aktiviert!';

  @override
  String get permissionDenied => '⚠️ Berechtigung verweigert';

  @override
  String get profile => 'Profil';

  @override
  String get yourProfile => 'Ihr Profil';

  @override
  String get support => 'Support';

  @override
  String get legal => 'Rechtliches';

  @override
  String get healthClosestAlly => 'Der engste Verbündete Ihrer Gesundheit.';

  @override
  String get openingWebsite => 'Website wird geöffnet...';

  @override
  String get visitWebsite => 'Website Besuchen';

  @override
  String get licensedApache => 'Lizenziert unter Apache License 2.0';

  @override
  String get licensedApache2 => 'Lizenziert unter Apache 2.0';

  @override
  String get copyright => '© 2025 Vertex Corporation';

  @override
  String get readPolicies => 'Lesen Sie unsere Richtlinien und Bedingungen';

  @override
  String get openingPrivacyPolicy => 'Datenschutzrichtlinie wird geöffnet...';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get openingTerms => 'Nutzungsbedingungen werden geöffnet...';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get editWaterGoal => 'Wasserziel Bearbeiten';

  @override
  String get glasses => 'Gläser';

  @override
  String get editCalorieGoal => 'Kalorienziel Bearbeiten';

  @override
  String get kcal => 'kcal';

  @override
  String get goalWeight => 'Zielgewicht';

  @override
  String get editHeight => 'Größe Bearbeiten';

  @override
  String get height => 'Größe';

  @override
  String get cm => 'cm';

  @override
  String get feet => 'Fuß';

  @override
  String get inches => 'Zoll';

  @override
  String get bodyMassIndex => 'Body-Mass-Index (BMI)';

  @override
  String get notCalculated => 'Nicht berechnet';

  @override
  String get addHeightWeight => 'Größe und Gewicht hinzufügen';

  @override
  String get noAchievementsYet => 'Noch Keine Erfolge';

  @override
  String get startTrackingForAchievements =>
      'Beginnen Sie mit der Verfolgung Ihrer Gesundheit, um Erfolge freizuschalten!';

  @override
  String get authFailed =>
      'Authentifizierung fehlgeschlagen. Fortsetzung ohne Anmeldung.';

  @override
  String get firebaseNotConfigured =>
      'Firebase nicht konfiguriert. Verwenden Sie anonyme Anmeldung.';

  @override
  String get googleSignInFailed =>
      'Google-Anmeldung fehlgeschlagen. Verwenden Sie stattdessen anonyme Anmeldung.';

  @override
  String emailSignInFailed(String error) {
    return 'E-Mail-Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get signIn => 'Anmelden';

  @override
  String get chooseSignInMethod => 'Wählen Sie Ihre Anmeldemethode';

  @override
  String get continueWithGoogle => 'Mit Google Fortfahren';

  @override
  String get continueWithEmail => 'Mit E-Mail Fortfahren';

  @override
  String get continueAsAnonymous => 'Als Anonym Fortfahren';

  @override
  String get dontHaveAccount => 'Sie haben kein Konto? ';

  @override
  String get signUp => 'Registrieren';

  @override
  String get legalAgreement =>
      'Durch Anmelden/Registrieren stimmen Sie unserer Datenschutzrichtlinie und unseren Nutzungsbedingungen zu';

  @override
  String get signInWithEmail => 'Mit E-Mail anmelden';

  @override
  String get enterEmailAddress => 'Geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get email => 'E-Mail';

  @override
  String get enterPassword => 'Geben Sie Ihr Passwort ein';

  @override
  String get password => 'Passwort';

  @override
  String get firebaseNotConfiguredSignup =>
      'Firebase nicht konfiguriert. Fortsetzung ohne Registrierung.';

  @override
  String signUpFailed(String error) {
    return 'Registrierung fehlgeschlagen: $error';
  }

  @override
  String get chooseUsername => 'Wählen Sie Ihren Benutzernamen';

  @override
  String get username => 'Benutzername';

  @override
  String get createPassword => 'Erstellen Sie ein Passwort';

  @override
  String get back => 'Zurück';

  @override
  String get startJourney => 'Reise Beginnen';

  @override
  String get continueAlly => 'Fortfahren';

  @override
  String get chooseUnits => 'Wählen Sie Ihre Einheiten';

  @override
  String get selectSystemPrefer => 'Wählen Sie das System, das Sie bevorzugen';

  @override
  String get kgCm => 'kg, cm';

  @override
  String get lbsIn => 'lbs, in';

  @override
  String get whatsYourWeight => 'Was ist Ihr Gewicht?';

  @override
  String get personalizeJourney =>
      'Helfen Sie uns, Ihre Reise zu personalisieren';

  @override
  String get whatsYourHeight => 'Was ist Ihre Größe?';

  @override
  String get calculateIdealMetrics => 'Wir berechnen Ihre idealen Metriken';

  @override
  String get whatsYourAge => 'Wie alt sind Sie?';

  @override
  String get createPerfectPlan =>
      'Lassen Sie uns Ihren perfekten Gesundheitsplan erstellen';

  @override
  String get years => 'Jahre';

  @override
  String get dailyStepGoal => 'Tägliches Schrittziel';

  @override
  String weightPercent(int weight) {
    return '$weight% Gewicht';
  }

  @override
  String get ally => 'Ally';

  @override
  String get yourHealths => 'Der engste\n';

  @override
  String get closest => 'Verbündete ';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get service => 'Service';

  @override
  String get automaticSleepTracking => 'Automatische Schlafverfolgung';

  @override
  String get noSmartwatchNeeded =>
      'Keine Smartwatch erforderlich! Verfolgen Sie Ihren Schlaf automatisch.';

  @override
  String get whenDoYouSleep => 'Wann schlafen Sie normalerweise?';

  @override
  String get sleepTime => 'Schlafenszeit';

  @override
  String get wakeTime => 'Weckzeit';

  @override
  String get sleepTrackingTitle => 'Schlafverfolgung';

  @override
  String get automaticTrackingEnabled => 'Automatische Verfolgung aktiviert';

  @override
  String get startTracking => 'Verfolgung Starten';

  @override
  String get sleepSegments => 'Schlafsegmente';

  @override
  String get sleepCycles => 'Schlafzyklen';

  @override
  String get wakeUps => 'Aufwachen';

  @override
  String get noSleepDataYet => 'Noch keine Schlafdaten';

  @override
  String get sleepTrackingStartTonight =>
      'Die Schlafverfolgung beginnt heute Nacht';

  @override
  String get currentlySleeping => 'Schläft Gerade';

  @override
  String sleepSegmentNumber(int number) {
    return 'Schlafsegment $number';
  }

  @override
  String get setWaterGoal => 'Setzen Sie Ihr Wasserziel';

  @override
  String get howMuchWater => 'Wie viel Wasser möchten Sie täglich trinken?';

  @override
  String get goalUpdated => 'Ziel Aktualisiert';

  @override
  String get editGoal => 'Ziel Bearbeiten';

  @override
  String get quickAdd => 'Schnell Hinzufügen';

  @override
  String get updateWeight => 'Gewicht Aktualisieren';

  @override
  String enterWeight(String unit) {
    return 'Gewicht eingeben ($unit)';
  }

  @override
  String get weightHistory => 'Gewichtsverlauf';

  @override
  String get startTrackingWeight =>
      'Beginnen Sie mit der Verfolgung Ihres Gewichtsfortschritts';

  @override
  String get setCalorieGoal => 'Setzen Sie Ihr Kalorienziel';

  @override
  String get howManyCalories =>
      'Wie viele Kalorien möchten Sie täglich zu sich nehmen?';

  @override
  String get goalSet => 'Ziel Gesetzt';

  @override
  String calorieGoalSet(int calories) {
    return 'Ihr tägliches Kalorienziel beträgt jetzt $calories kcal';
  }

  @override
  String get addFriend => 'Freund Hinzufügen';

  @override
  String get welcomeText1 => 'Ihre Gesundheit';

  @override
  String get welcomeText2 => 'engste';

  @override
  String get welcomeText3 => 'Verbündete';

  @override
  String get serviceControls => 'Service-Kontrollen';

  @override
  String get startService => 'Service Starten';

  @override
  String get restartService => 'Service Neustarten';

  @override
  String get stopService => 'Service Stoppen';

  @override
  String get setYourGoal => 'Setzen Sie Ihr Ziel';

  @override
  String get howManySteps => 'Wie viele Schritte möchten Sie heute erreichen?';

  @override
  String get serviceStarted => 'Service Gestartet';

  @override
  String get serviceStartedDesc => 'Der Schrittzähler-Service läuft jetzt';

  @override
  String get serviceRestarted => 'Service Neugestartet';

  @override
  String get serviceRestartedDesc =>
      'Der Schrittzähler-Service wurde neugestartet';

  @override
  String get serviceStopped => 'Service Gestoppt';

  @override
  String get serviceStoppedDesc => 'Der Schrittzähler-Service wurde gestoppt';

  @override
  String dailyGoalSet(Object goal) {
    return 'Ihr tägliches Ziel beträgt jetzt $goal Schritte';
  }

  @override
  String get stepsLabel => 'Schritte';

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
  String get programNameHint => 'Programmname (z.B. Push Day)';

  @override
  String get usernameHint => 'Benutzername';

  @override
  String get emailHint => 'E-Mail';

  @override
  String get passwordHint => 'Passwort';

  @override
  String get dailyCalorieHint => '2000';

  @override
  String get usernameAtHint => '@benutzername';

  @override
  String programUpdated(String name) {
    return 'Programm \"$name\" aktualisiert!';
  }

  @override
  String programSaved(String name) {
    return 'Programm \"$name\" gespeichert!';
  }

  @override
  String valueOfTarget(String value, String target) {
    return '$value von $target';
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
    return 'von $value$unit';
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
    return '~$calories Kal';
  }

  @override
  String caloriesPer100g(String calories) {
    return '($calories/100g)';
  }

  @override
  String get licensedApache2Short => 'Lizenziert unter Apache 2.0';

  @override
  String get waterGoalLabel => 'Wasserziel';

  @override
  String get calorieGoalLabel => 'Kalorienziel';

  @override
  String get enterWeightLbs => 'Gewicht eingeben (lbs)';

  @override
  String get enterWeightKg => 'Gewicht eingeben (kg)';

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
    return 'von ${hours}h';
  }

  @override
  String get nowLabel => 'Jetzt';

  @override
  String dailyGoalSetTo(String value, String unit) {
    return 'Tagesziel auf $value$unit gesetzt';
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
      'Geben Sie den Benutzernamen Ihres Freundes ein, um dessen Aktivität zu folgen';

  @override
  String get sendRequest => 'Anfrage Senden';

  @override
  String subscribeToPlan(String title) {
    return 'Abonnieren Sie den $title-Plan';
  }

  @override
  String restSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get setYourCalorieGoal => 'Legen Sie Ihr Kalorienziel Fest';

  @override
  String get workoutBuilder => 'Trainingsbauer';

  @override
  String get whenDoYouUsuallySleep => 'Wann schlafen Sie normalerweise?';

  @override
  String get sleepTrackingWillStartTonight =>
      'Die Schlafverfolgung beginnt heute Abend';
}
