// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Ally';

  @override
  String get welcomeTitle => 'Ally';

  @override
  String get welcomeDescription => 'L\'allié le plus proche de votre santé.';

  @override
  String get letsStart => 'Commençons !';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get continueAnonymously => 'Continuer anonymement';

  @override
  String get loginDescription => 'Connectez-vous pour continuer';

  @override
  String get dailyReflection => 'Réflexion quotidienne';

  @override
  String get helloAnonymous => 'Bonjour, anonyme !';

  @override
  String get healthScore => 'Score de santé';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get of100 => 'sur 100';

  @override
  String get exercises => 'Exercices';

  @override
  String dayStreak(int count) {
    return '$count jours d\'affilée';
  }

  @override
  String daysCount(int count) {
    return '$count jours';
  }

  @override
  String get nutrition => 'Nutrition';

  @override
  String calories(int count) {
    return '$count cal';
  }

  @override
  String get sleep => 'Sommeil';

  @override
  String hours(String hours) {
    return '${hours}h';
  }

  @override
  String get water => 'Eau';

  @override
  String waterGlasses(int current, int goal) {
    return '$current / $goal verres';
  }

  @override
  String get weight => 'Poids';

  @override
  String weightKg(double weight) {
    return '$weight kg';
  }

  @override
  String get heartbeat => 'Rythme cardiaque';

  @override
  String bpm(int bpm) {
    return '$bpm bpm';
  }

  @override
  String get pedometer => 'Pas';

  @override
  String steps(int current, int goal) {
    return 'pas';
  }

  @override
  String get home => 'Accueil';

  @override
  String get activity => 'Activité';

  @override
  String get achievements => 'Réalisations';

  @override
  String get account => 'Compte';

  @override
  String get settings => 'Paramètres';

  @override
  String get friendsActivity => 'Activité des amis';

  @override
  String get myActivity => 'Mon activité';

  @override
  String get yourAchievements => 'Vos réalisations';

  @override
  String get totalPoints => 'Points totaux';

  @override
  String get completedChallenges => 'Défis terminés';

  @override
  String get currentStreak => 'Série actuelle';

  @override
  String get days => 'jours';

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
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get addExercise => 'Ajouter un Exercice';

  @override
  String get exerciseType => 'Exercise Type';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Force';

  @override
  String get flexibility => 'Flexibilité';

  @override
  String get sports => 'Sports';

  @override
  String get addNutrition => 'Ajouter Nutrition';

  @override
  String get automatic => 'Automatique';

  @override
  String get manual => 'Manuel';

  @override
  String get scanWithCamera => 'Scanner avec Caméra';

  @override
  String get selectPlateType => 'Sélectionner le Type d\'Assiette';

  @override
  String get plate => 'Assiette';

  @override
  String get bowl => 'Bol';

  @override
  String get smallPlate => 'Petite Assiette';

  @override
  String get mediumPlate => 'Assiette Moyenne';

  @override
  String get largePlate => 'Grande Assiette';

  @override
  String get smallBowl => 'Petit Bol';

  @override
  String get mediumBowl => 'Bol Moyen';

  @override
  String get largeBowl => 'Grand Bol';

  @override
  String get fillLevel => 'Niveau de Remplissage';

  @override
  String get quarter => '1/4 Plein';

  @override
  String get half => '1/2 Plein';

  @override
  String get threeQuarters => '3/4 Plein';

  @override
  String get full => 'Plein';

  @override
  String get selectFood => 'Sélectionner Aliment';

  @override
  String get breakfast => 'Petit-déjeuner';

  @override
  String get lunch => 'Déjeuner';

  @override
  String get dinner => 'Dîner';

  @override
  String get snacks => 'Collations';

  @override
  String get egg => 'Œuf';

  @override
  String get milk => 'Lait';

  @override
  String get yogurt => 'Yaourt';

  @override
  String get whiteRice => 'Riz Blanc';

  @override
  String get plainPasta => 'Pâtes Nature';

  @override
  String get chickenBreast => 'Blanc de Poulet';

  @override
  String get grilledSalmon => 'Saumon Grillé';

  @override
  String get boiledPotato => 'Pomme de Terre Bouillie';

  @override
  String get mixedVegetables => 'Légumes Mélangés';

  @override
  String get couscous => 'Couscous';

  @override
  String get quinoa => 'Quinoa';

  @override
  String get bulgur => 'Boulgour';

  @override
  String get corn => 'Maïs';

  @override
  String get peas => 'Petits Pois';

  @override
  String get broccoli => 'Brocoli';

  @override
  String get mushroom => 'Champignon';

  @override
  String get stirFryVegetables => 'Légumes Sautés';

  @override
  String get sweetPotato => 'Patate Douce';

  @override
  String get baldoRice => 'Riz Baldo';

  @override
  String get chickenCurry => 'Curry de Poulet';

  @override
  String get beefCurry => 'Curry de Bœuf';

  @override
  String get spaghettiPuttanesca => 'Spaghetti Puttanesca';

  @override
  String get ravioli => 'Ravioli';

  @override
  String get gnocchi => 'Gnocchi';

  @override
  String get kidneyBeans => 'Haricots Rouges';

  @override
  String get chickpeas => 'Pois Chiches';

  @override
  String get lentils => 'Lentilles';

  @override
  String get whiteBeans => 'Haricots Blancs';

  @override
  String get tuna => 'Thon';

  @override
  String get mussels => 'Moules';

  @override
  String get shrimp => 'Crevette';

  @override
  String get caesarSalad => 'Salade César';

  @override
  String get tofu => 'Tofu';

  @override
  String get salad => 'Salade';

  @override
  String get soup => 'Soupe';

  @override
  String get fruit => 'Fruit';

  @override
  String get vegetables => 'Légumes';

  @override
  String get mealLog => 'Journal des Repas';

  @override
  String get todaysMeals => 'Repas d\'Aujourd\'hui';

  @override
  String get noMealsYet => 'Aucun repas ajouté pour le moment';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Notifications push';

  @override
  String get pushNotificationsDesc =>
      'Recevez des notifications pour vos activités';

  @override
  String get emailNotifications => 'Notifications par e-mail';

  @override
  String get emailNotificationsDesc => 'Recevez des mises à jour par e-mail';

  @override
  String get privacySecurity => 'Confidentialité et sécurité';

  @override
  String get privacySettings => 'Paramètres de confidentialité';

  @override
  String get privacySettingsDesc => 'Gérez vos préférences de confidentialité';

  @override
  String get dataStorage => 'Données et stockage';

  @override
  String get dataStorageDesc => 'Gérez vos données et votre stockage';

  @override
  String get appSettings => 'Paramètres de l\'application';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get units => 'Unités';

  @override
  String get about => 'À propos';

  @override
  String get helpSupport => 'Aide et assistance';

  @override
  String get helpSupportDesc => 'Obtenez de l\'aide et contactez le support';

  @override
  String get termsConditions => 'Termes et conditions';

  @override
  String get termsConditionsDesc => 'Lisez nos termes et conditions';

  @override
  String get aboutAlly => 'À propos d\'Ally';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get selectTheme => 'Sélectionner le thème';

  @override
  String get selectUnits => 'Sélectionner les unités';

  @override
  String get systemDefault => 'Défaut du système';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get metric => 'Métrique';

  @override
  String get imperial => 'Impérial';

  @override
  String get personalInfo => 'Informations personnelles';

  @override
  String get fullName => 'Nom complet';

  @override
  String get anonymousUser => 'Utilisateur anonyme';

  @override
  String get country => 'Pays';

  @override
  String get unitedStates => 'États-Unis';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get january1 => '1er janvier 1990';

  @override
  String get healthInfo => 'Informations de santé';

  @override
  String get currentWeight => 'Poids actuel';

  @override
  String get waterGoal => 'Objectif d\'eau';

  @override
  String glassesPerDay(int count) {
    return '$count verres/jour';
  }

  @override
  String get calorieGoal => 'Objectif calorique';

  @override
  String kcalPerDay(int count) {
    return '$count kcal/jour';
  }

  @override
  String get exerciseStreak => 'Série d\'exercices';

  @override
  String get dangerZone => 'Zone de danger';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountDesc =>
      'Supprimer définitivement votre compte et vos données';

  @override
  String get noFriendsYet => 'Pas encore d\'amis';

  @override
  String get addFriendsToSee => 'Ajoutez des amis pour voir leur activité';

  @override
  String get noActivityYet => 'Pas encore d\'activité';

  @override
  String get startTrackingToSee =>
      'Commencez le suivi pour voir votre activité';

  @override
  String get badges => 'Badges';

  @override
  String get dayStreakLabel => 'Série de jours';

  @override
  String get availableAchievements => 'Réalisations disponibles';

  @override
  String get hydrationHero => 'Héros de l\'Hydratation';

  @override
  String get drink8Glasses => 'Buvez 8 verres d\'eau quotidiennement';

  @override
  String get points => 'points';

  @override
  String get workoutWarrior => 'Guerrier de l\'entraînement';

  @override
  String get complete7Days => 'Complétez 7 jours d\'exercice';

  @override
  String get sleepChampion => 'Champion du Sommeil';

  @override
  String get get8Hours => 'Dormez 8 heures pendant 7 jours';

  @override
  String get nutritionMaster => 'Maître de la nutrition';

  @override
  String get trackMeals => 'Suivez les repas pendant 30 jours';

  @override
  String get heartHealth => 'Santé cardiaque';

  @override
  String get maintain60to100 => 'Maintenez 60-100 bpm pendant une semaine';

  @override
  String get waterIntake => 'Consommation d\'eau';

  @override
  String get mealLogged => 'Repas enregistré';

  @override
  String get sleepLogged => 'Sommeil enregistré';

  @override
  String get weightUpdated => 'Poids mis à jour';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int minutes) {
    return 'Il y a ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'Il y a ${hours}h';
  }

  @override
  String get lastNight => 'Hier soir';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get sleepDuration => 'Durée du sommeil';

  @override
  String get heartRate => 'Fréquence cardiaque';

  @override
  String get scoreBreakdown => 'Répartition des scores';

  @override
  String get loseWeight => 'Perdre du Poids';

  @override
  String get reduceCalories => 'Réduire les calories';

  @override
  String get maintainWeight => 'Maintenir le Poids';

  @override
  String get balancedCalories => 'Calories équilibrées';

  @override
  String get gainWeight => 'Prendre du Poids';

  @override
  String get increaseCalories => 'Augmenter les calories';

  @override
  String get activityLevel => 'Niveau d\'Activité';

  @override
  String get sedentary => 'Sédentaire';

  @override
  String get littleExercise => 'Peu ou pas d\'exercice';

  @override
  String get lightlyActive => 'Légèrement actif';

  @override
  String get lightExercise => 'Exercice léger 1-3 jours/semaine';

  @override
  String get moderatelyActive => 'Modérément actif';

  @override
  String get moderateExercise => 'Exercice modéré 3-5 jours/semaine';

  @override
  String get veryActive => 'Très Actif';

  @override
  String get intenseTraining => 'Entraînement intensif quotidien';

  @override
  String get yourHealthScore => 'Votre Score de Santé';

  @override
  String get outOf100 => 'sur 100';

  @override
  String get workoutStreakDesc => 'Série d\'exercices et activité quotidienne';

  @override
  String get sleepQualityDesc => 'Durée et qualité du sommeil';

  @override
  String get hydrationGoalDesc => 'Objectif d\'hydratation quotidienne';

  @override
  String get weightProgressDesc => 'Progrès vers le poids cible';

  @override
  String get calorieBalanceDesc => 'Équilibre calorique';

  @override
  String get restingHeartRateDesc => 'Fréquence cardiaque au repos';

  @override
  String get todaysIntake => 'Consommation d\'Aujourd\'hui';

  @override
  String get noMealsLogged => 'Aucun repas enregistré pour le moment';

  @override
  String get tapToAddMeal => 'Appuyez sur + pour ajouter votre premier repas';

  @override
  String get todaysPrograms => 'Programmes d\'Aujourd\'hui';

  @override
  String get noWorkoutsLogged => 'Aucun entraînement enregistré pour le moment';

  @override
  String get startFitnessJourney =>
      'Commencez votre parcours fitness aujourd\'hui!';

  @override
  String get noSleepData => 'Aucune donnée de sommeil enregistrée';

  @override
  String get trackSleepPatterns =>
      'Suivez votre sommeil pour voir les tendances';

  @override
  String get progress => 'Progrès';

  @override
  String get noWeightHistory => 'Aucun historique de poids';

  @override
  String get trackWeightProgress => 'Suivez votre poids pour voir les progrès';

  @override
  String get currentHeartRate => 'Fréquence Cardiaque Actuelle';

  @override
  String get todaysReadings => 'Lectures d\'Aujourd\'hui';

  @override
  String get noReadingsYet => 'Aucune lecture pour le moment';

  @override
  String get requiresMonitor =>
      'Nécessite un appareil de surveillance de la fréquence cardiaque';

  @override
  String get percentWeight => '% poids';

  @override
  String get tipMaintainStreak =>
      'Concentrez-vous sur le maintien de votre série d\'exercices';

  @override
  String get tipDrinkWater =>
      'Essayez de boire 2 verres d\'eau supplémentaires aujourd\'hui';

  @override
  String get tipBedtimeEarlier => 'Visez un coucher 30 minutes plus tôt';

  @override
  String get weightGoalAchieved => 'Objectif de Poids Atteint';

  @override
  String get reachTargetWeight => 'Atteignez votre poids cible';

  @override
  String get welcomeToAlly => 'Bienvenue à Ally';

  @override
  String get personalHealthCompanion => 'Votre compagnon de santé personnel';

  @override
  String get trackWellnessJourney =>
      'Suivez votre parcours de bien-être avec des objectifs et des perspectives personnalisés';

  @override
  String drankGlasses(int count) {
    return 'A bu $count verres d\'eau';
  }

  @override
  String caloriesConsumed(int count) {
    return '$count calories consommées';
  }

  @override
  String dayStreakMaintained(int count) {
    return 'Série de $count jours maintenue';
  }

  @override
  String hoursOfSleep(String hours) {
    return '$hours heures de sommeil';
  }

  @override
  String get todaysOverview => 'Aperçu d\'Aujourd\'hui';

  @override
  String get quickStats => 'Statistiques Rapides';

  @override
  String get totalActivity => 'Activité Totale';

  @override
  String get badgesEarned => 'Badges Gagnés';

  @override
  String get setYourGoals => 'Définissez Vos Objectifs';

  @override
  String get manageYourProfile => 'Gérez Votre Profil';

  @override
  String get firstSteps => 'Premiers Pas';

  @override
  String get firstStepsDesc => 'Complétez la configuration de votre profil';

  @override
  String get earlyBird => 'Lève-Tôt';

  @override
  String get earlyBirdDesc => 'Enregistrez 7 jours consécutifs';

  @override
  String get hydrationHeroDesc => 'Buvez 8 verres par jour pendant 7 jours';

  @override
  String get calorieCounter => 'Compteur de Calories';

  @override
  String get calorieCounterDesc => 'Suivez les repas pendant 30 jours';

  @override
  String get weekWarrior => 'Guerrier de la Semaine';

  @override
  String get weekWarriorDesc => 'Faites de l\'exercice 5 fois par semaine';

  @override
  String get mileMaster => 'Maître des Miles';

  @override
  String get mileMasterDesc => 'Courez un total de 100 miles';

  @override
  String get sleepChampionDesc => 'Dormez 8 heures pendant 7 jours';

  @override
  String get calculateCalorieNeeds =>
      'Cela nous aide à calculer vos besoins caloriques quotidiens';

  @override
  String get personalizeHealthGoals =>
      'Nous utiliserons cela pour personnaliser vos objectifs de santé';

  @override
  String get tellUsAboutYourself => 'Parlez-nous de vous';

  @override
  String get determinesCalorieTarget =>
      'Cela détermine votre objectif calorique';

  @override
  String get howActiveAreYou =>
      'À quel point êtes-vous actif dans une journée typique?';

  @override
  String get littleToNoExercise => 'Peu ou pas d\'exercice';

  @override
  String get intenseDailyTraining => 'Entraînement intense quotidien';

  @override
  String get light => 'Léger';

  @override
  String get lightActivity => '1-3 jours/semaine';

  @override
  String get moderate => 'Modéré';

  @override
  String get moderateActivity => '3-5 jours/semaine';

  @override
  String get active => 'Actif';

  @override
  String get activeActivity => '6-7 jours/semaine';

  @override
  String get editWeight => 'Edit Weight';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeYourPlan => 'Améliorez votre Plan';

  @override
  String get unlockMore => 'Débloquez Plus.';

  @override
  String get goPremium => 'Passez Premium';

  @override
  String get upgradeForExclusive =>
      'Améliorez pour des avantages exclusifs et une expérience\nplus fluide et rapide.';

  @override
  String get individual => 'Individuel';

  @override
  String get family => 'Famille';

  @override
  String get familyPlan => 'Plan Familial';

  @override
  String get allyIndividual => 'Ally Individuel';

  @override
  String get month => 'mois';

  @override
  String get allIndividualFeatures =>
      'Toutes les fonctionnalités Individuelles plus\npartage familial jusqu\'à 4 membres.';

  @override
  String get getAllyPlan => 'Obtenir le Plan Ally';

  @override
  String get getFamilyPlan => 'Obtenir le Plan Familial';

  @override
  String get friendRequestSent => 'Demande d\'Ami Envoyée';

  @override
  String requestSentTo(String username) {
    return 'Demande envoyée à $username avec succès!';
  }

  @override
  String get selectExercise => 'Sélectionner Exercice';

  @override
  String get all => 'Tous';

  @override
  String get addExercisesToStart => 'Ajouter des exercices pour commencer';

  @override
  String get tapPlusButton => 'Appuyez sur le bouton + ci-dessous';

  @override
  String get reps => 'Répétitions';

  @override
  String get rest => 'Repos (s)';

  @override
  String get addSet => 'Ajouter une Série';

  @override
  String get workoutName => 'Nom de l\'Entraînement';

  @override
  String get enterWorkoutName => 'Entrez le nom de l\'entraînement';

  @override
  String get createWorkout => 'Créer un Entraînement';

  @override
  String get editWorkout => 'Modifier l\'Entraînement';

  @override
  String get deleteWorkout => 'Supprimer l\'Entraînement';

  @override
  String get areYouSureDelete =>
      'Êtes-vous sûr de vouloir supprimer cet entraînement?';

  @override
  String get delete => 'Supprimer';

  @override
  String completedAt(String time) {
    return 'Complété à $time';
  }

  @override
  String get set => 'Série';

  @override
  String get quickExerciseLog => 'Enregistrement Rapide d\'Exercice';

  @override
  String get logYourExercise => 'Enregistrez votre exercice';

  @override
  String get exerciseName => 'Nom de l\'Exercice';

  @override
  String get enterExerciseName => 'Entrez le nom de l\'exercice';

  @override
  String get sets => 'Séries';

  @override
  String get duration => 'Durée';

  @override
  String get minutes => 'minutes';

  @override
  String get logExercise => 'Enregistrer l\'Exercice';

  @override
  String get close => 'Fermer';

  @override
  String get customProgram => 'Programme Personnalisé';

  @override
  String get buildYourOwnWorkout => 'Créez votre propre entraînement';

  @override
  String get quickLog => 'Enregistrement Rapide';

  @override
  String get logASingleExercise => 'Enregistrer un seul exercice';

  @override
  String get noStreakYet => 'Pas encore de série';

  @override
  String get day => 'jour';

  @override
  String get keepGoing => 'Continuez !';

  @override
  String get quickPrograms => 'Programmes Rapides';

  @override
  String get createProgramToQuicklyStart =>
      'Créer un programme pour démarrer rapidement';

  @override
  String get min => 'min';

  @override
  String get ex => 'ex';

  @override
  String get editProgram => 'Modifier le Programme';

  @override
  String get deleteProgram => 'Supprimer le Programme';

  @override
  String get deleteProgramQuestion => 'Supprimer le Programme ?';

  @override
  String areYouSureDeleteProgram(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ?';
  }

  @override
  String get logged => 'enregistré';

  @override
  String get kg => 'kg';

  @override
  String editSetNumber(int number) {
    return 'Modifier la Série $number';
  }

  @override
  String weightWithUnit(String unit) {
    return 'Poids ($unit)';
  }

  @override
  String get exerciseNotFound => 'Exercice introuvable';

  @override
  String get exitWorkout => 'Quitter l\'Entraînement ?';

  @override
  String get progressNotSaved => 'Votre progression ne sera pas sauvegardée.';

  @override
  String get exit => 'Quitter';

  @override
  String get finish => 'Terminer';

  @override
  String exerciseProgress(int current, int total) {
    return 'Exercice $current/$total';
  }

  @override
  String percentComplete(int percent) {
    return '$percent% Terminé';
  }

  @override
  String get restTime => 'Temps de Repos';

  @override
  String get skip => 'Passer';

  @override
  String get repsLowercase => 'répétitions';

  @override
  String get kgUnit => 'kg';

  @override
  String get workoutNotComplete => 'Entraînement Non Terminé';

  @override
  String get workoutNotCompleteMessage =>
      'Vous n\'avez pas terminé toutes les séries. Voulez-vous sauvegarder votre progression et terminer quand même ?';

  @override
  String get finishAnyway => 'Terminer Quand Même';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get workoutCompleted => 'Entraînement Terminé !';

  @override
  String get enableStepTracking => 'Activer le Suivi des Pas';

  @override
  String get stepPermissionMessage =>
      'Nous avons besoin de l\'autorisation de reconnaissance d\'activité pour compter vos pas en arrière-plan.';

  @override
  String get later => 'Plus tard';

  @override
  String get allow => 'Autoriser';

  @override
  String get stepTrackingEnabled => '✅ Suivi des pas activé !';

  @override
  String get permissionDenied => '⚠️ Permission refusée';

  @override
  String get profile => 'Profil';

  @override
  String get yourProfile => 'Votre Profil';

  @override
  String get support => 'Support';

  @override
  String get legal => 'Légal';

  @override
  String get healthClosestAlly => 'L\'allié le plus proche de votre santé.';

  @override
  String get openingWebsite => 'Ouverture du site web...';

  @override
  String get visitWebsite => 'Visiter le Site Web';

  @override
  String get licensedApache => 'Sous licence Apache License 2.0';

  @override
  String get licensedApache2 => 'Sous licence Apache 2.0';

  @override
  String get copyright => '© 2025 Vertex Corporation';

  @override
  String get readPolicies => 'Lisez nos politiques et conditions';

  @override
  String get openingPrivacyPolicy =>
      'Ouverture de la Politique de Confidentialité...';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get openingTerms => 'Ouverture des Conditions de Service...';

  @override
  String get termsOfService => 'Conditions de Service';

  @override
  String get editWaterGoal => 'Modifier l\'Objectif d\'Eau';

  @override
  String get glasses => 'verres';

  @override
  String get editCalorieGoal => 'Modifier l\'Objectif Calorique';

  @override
  String get kcal => 'kcal';

  @override
  String get goalWeight => 'Poids Objectif';

  @override
  String get editHeight => 'Modifier la Taille';

  @override
  String get height => 'Taille';

  @override
  String get cm => 'cm';

  @override
  String get feet => 'Pieds';

  @override
  String get inches => 'Pouces';

  @override
  String get bodyMassIndex => 'Indice de Masse Corporelle (IMC)';

  @override
  String get notCalculated => 'Non calculé';

  @override
  String get addHeightWeight => 'Ajouter taille et poids';

  @override
  String get noAchievementsYet => 'Aucune Réalisation Pour l\'Instant';

  @override
  String get startTrackingForAchievements =>
      'Commencez à suivre votre santé pour débloquer des réalisations !';

  @override
  String get authFailed =>
      'Échec de l\'authentification. Continuation sans connexion.';

  @override
  String get firebaseNotConfigured =>
      'Firebase non configuré. Utilisez la connexion anonyme.';

  @override
  String get googleSignInFailed =>
      'Échec de la connexion Google. Utilisez plutôt la connexion anonyme.';

  @override
  String emailSignInFailed(String error) {
    return 'Échec de la connexion par e-mail: $error';
  }

  @override
  String get signIn => 'Se connecter';

  @override
  String get chooseSignInMethod => 'Choisissez votre méthode de connexion';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithEmail => 'Continuer avec E-mail';

  @override
  String get continueAsAnonymous => 'Continuer en Anonyme';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get legalAgreement =>
      'En vous connectant/inscrivant, vous acceptez notre Politique de Confidentialité et nos Conditions de Service';

  @override
  String get signInWithEmail => 'Se connecter avec e-mail';

  @override
  String get enterEmailAddress => 'Entrez votre adresse e-mail';

  @override
  String get email => 'E-mail';

  @override
  String get enterPassword => 'Entrez votre mot de passe';

  @override
  String get password => 'Mot de passe';

  @override
  String get firebaseNotConfiguredSignup =>
      'Firebase non configuré. Continuation sans inscription.';

  @override
  String signUpFailed(String error) {
    return 'Échec de l\'inscription: $error';
  }

  @override
  String get chooseUsername => 'Choisissez votre nom d\'utilisateur';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get createPassword => 'Créer un mot de passe';

  @override
  String get back => 'Retour';

  @override
  String get startJourney => 'Commencer le Voyage';

  @override
  String get continueAlly => 'Continuer';

  @override
  String get chooseUnits => 'Choisissez vos unités';

  @override
  String get selectSystemPrefer => 'Sélectionnez le système que vous préférez';

  @override
  String get kgCm => 'kg, cm';

  @override
  String get lbsIn => 'lbs, in';

  @override
  String get whatsYourWeight => 'Quel est votre poids ?';

  @override
  String get personalizeJourney => 'Aidez-nous à personnaliser votre parcours';

  @override
  String get whatsYourHeight => 'Quelle est votre taille ?';

  @override
  String get calculateIdealMetrics => 'Nous calculerons vos métriques idéales';

  @override
  String get whatsYourAge => 'Quel est votre âge ?';

  @override
  String get createPerfectPlan => 'Créons votre plan de santé parfait';

  @override
  String get years => 'ans';

  @override
  String get dailyStepGoal => 'Objectif de pas quotidien';

  @override
  String weightPercent(int weight) {
    return '$weight% poids';
  }

  @override
  String get ally => 'Ally';

  @override
  String get yourHealths => 'L\'allié le plus\n';

  @override
  String get closest => 'proche ';

  @override
  String get getStarted => 'Commencer';

  @override
  String get service => 'Service';

  @override
  String get automaticSleepTracking => 'Suivi Automatique du Sommeil';

  @override
  String get noSmartwatchNeeded =>
      'Pas de montre intelligente nécessaire ! Suivez votre sommeil automatiquement.';

  @override
  String get whenDoYouSleep => 'Quand dormez-vous habituellement ?';

  @override
  String get sleepTime => 'Heure de Sommeil';

  @override
  String get wakeTime => 'Heure de Réveil';

  @override
  String get sleepTrackingTitle => 'Suivi du Sommeil';

  @override
  String get automaticTrackingEnabled => 'Suivi automatique activé';

  @override
  String get startTracking => 'Commencer le Suivi';

  @override
  String get sleepSegments => 'Segments de Sommeil';

  @override
  String get sleepCycles => 'Cycles de Sommeil';

  @override
  String get wakeUps => 'Réveils';

  @override
  String get noSleepDataYet => 'Aucune donnée de sommeil encore';

  @override
  String get sleepTrackingStartTonight =>
      'Le suivi du sommeil commencera ce soir';

  @override
  String get currentlySleeping => 'Actuellement en Train de Dormir';

  @override
  String sleepSegmentNumber(int number) {
    return 'Segment de Sommeil $number';
  }

  @override
  String get setWaterGoal => 'Définir Votre Objectif d\'Eau';

  @override
  String get howMuchWater =>
      'Combien d\'eau voulez-vous boire quotidiennement ?';

  @override
  String get goalUpdated => 'Objectif Mis à Jour';

  @override
  String get editGoal => 'Modifier l\'Objectif';

  @override
  String get quickAdd => 'Ajout Rapide';

  @override
  String get updateWeight => 'Mettre à Jour le Poids';

  @override
  String enterWeight(String unit) {
    return 'Entrez le poids ($unit)';
  }

  @override
  String get weightHistory => 'Historique du Poids';

  @override
  String get startTrackingWeight => 'Commencez à suivre vos progrès de poids';

  @override
  String get setCalorieGoal => 'Définir Votre Objectif Calorique';

  @override
  String get howManyCalories =>
      'Combien de calories voulez-vous consommer quotidiennement ?';

  @override
  String get goalSet => 'Objectif Défini';

  @override
  String calorieGoalSet(int calories) {
    return 'Votre objectif calorique quotidien est maintenant de $calories kcal';
  }

  @override
  String get addFriend => 'Ajouter un Ami';

  @override
  String get welcomeText1 => 'Votre santé';

  @override
  String get welcomeText2 => 'plus proche';

  @override
  String get welcomeText3 => 'allié';

  @override
  String get serviceControls => 'Contrôles de Service';

  @override
  String get startService => 'Démarrer le Service';

  @override
  String get restartService => 'Redémarrer le Service';

  @override
  String get stopService => 'Arrêter le Service';

  @override
  String get setYourGoal => 'Définir Votre Objectif';

  @override
  String get howManySteps =>
      'Combien de pas voulez-vous atteindre aujourd\'hui ?';

  @override
  String get serviceStarted => 'Service Démarré';

  @override
  String get serviceStartedDesc =>
      'Le service de compteur de pas fonctionne maintenant';

  @override
  String get serviceRestarted => 'Service Redémarré';

  @override
  String get serviceRestartedDesc =>
      'Le service de compteur de pas a été redémarré';

  @override
  String get serviceStopped => 'Service Arrêté';

  @override
  String get serviceStoppedDesc => 'Le service de compteur de pas a été arrêté';

  @override
  String dailyGoalSet(Object goal) {
    return 'Votre objectif quotidien est maintenant de $goal pas';
  }

  @override
  String get stepsLabel => 'pas';

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
  String get programNameHint => 'Nom du programme (ex: Jour Push)';

  @override
  String get usernameHint => 'Nom d\'utilisateur';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Mot de passe';

  @override
  String get dailyCalorieHint => '2000';

  @override
  String get usernameAtHint => '@nomdutilisateur';

  @override
  String programUpdated(String name) {
    return 'Programme \"$name\" mis à jour !';
  }

  @override
  String programSaved(String name) {
    return 'Programme \"$name\" enregistré !';
  }

  @override
  String valueOfTarget(String value, String target) {
    return '$value sur $target';
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
    return 'de $value$unit';
  }

  @override
  String bmiValue(String value) {
    return 'IMC: $value';
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
  String get licensedApache2Short => 'Sous licence Apache 2.0';

  @override
  String get waterGoalLabel => 'Objectif d\'Eau';

  @override
  String get calorieGoalLabel => 'Objectif Calorique';

  @override
  String get enterWeightLbs => 'Entrez le poids (lbs)';

  @override
  String get enterWeightKg => 'Entrez le poids (kg)';

  @override
  String bmiLabel(String value) {
    return 'IMC: $value';
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
    return 'de ${hours}h';
  }

  @override
  String get nowLabel => 'Maintenant';

  @override
  String dailyGoalSetTo(String value, String unit) {
    return 'Objectif quotidien défini à $value$unit';
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
      'Entrez le nom d\'utilisateur de votre ami pour suivre son activité';

  @override
  String get sendRequest => 'Envoyer une Demande';

  @override
  String subscribeToPlan(String title) {
    return 'S\'abonner au plan $title';
  }

  @override
  String restSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get setYourCalorieGoal => 'Définir Votre Objectif Calorique';

  @override
  String get workoutBuilder => 'Constructeur d\'Entraînement';

  @override
  String get whenDoYouUsuallySleep =>
      'À quelle heure dormez-vous généralement ?';

  @override
  String get sleepTrackingWillStartTonight =>
      'Le suivi du sommeil commencera ce soir';
}
