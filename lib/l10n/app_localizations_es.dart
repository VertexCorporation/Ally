// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Ally';

  @override
  String get welcomeTitle => 'Ally';

  @override
  String get welcomeDescription => 'El aliado más cercano de tu salud.';

  @override
  String get letsStart => '¡Empecemos!';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get continueAnonymously => 'Continuar anónimamente';

  @override
  String get loginDescription => 'Inicia sesión para continuar';

  @override
  String get dailyReflection => 'Reflexión diaria';

  @override
  String get helloAnonymous => '¡Hola, anónimo!';

  @override
  String get healthScore => 'Puntuación de salud';

  @override
  String get today => 'Hoy';

  @override
  String get of100 => 'de 100';

  @override
  String get exercises => 'Ejercicios';

  @override
  String dayStreak(int count) {
    return '$count días seguidos';
  }

  @override
  String daysCount(int count) {
    return '$count días';
  }

  @override
  String get nutrition => 'Nutrición';

  @override
  String calories(int count) {
    return '$count cal';
  }

  @override
  String get sleep => 'Sueño';

  @override
  String hours(String hours) {
    return '${hours}h';
  }

  @override
  String get water => 'Agua';

  @override
  String waterGlasses(int current, int goal) {
    return '$current / $goal vasos';
  }

  @override
  String get weight => 'Peso';

  @override
  String weightKg(double weight) {
    return '$weight kg';
  }

  @override
  String get heartbeat => 'Latidos';

  @override
  String bpm(int bpm) {
    return '$bpm lpm';
  }

  @override
  String get pedometer => 'Pasos';

  @override
  String steps(int current, int goal) {
    return 'pasos';
  }

  @override
  String get home => 'Inicio';

  @override
  String get activity => 'Actividad';

  @override
  String get achievements => 'Logros';

  @override
  String get account => 'Cuenta';

  @override
  String get settings => 'Configuración';

  @override
  String get friendsActivity => 'Actividad de amigos';

  @override
  String get myActivity => 'Mi actividad';

  @override
  String get yourAchievements => 'Tus logros';

  @override
  String get totalPoints => 'Puntos totales';

  @override
  String get completedChallenges => 'Desafíos completados';

  @override
  String get currentStreak => 'Racha actual';

  @override
  String get days => 'días';

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
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get addExercise => 'Agregar Ejercicio';

  @override
  String get exerciseType => 'Exercise Type';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Fuerza';

  @override
  String get flexibility => 'Flexibilidad';

  @override
  String get sports => 'Deportes';

  @override
  String get addNutrition => 'Agregar Nutrición';

  @override
  String get automatic => 'Automático';

  @override
  String get manual => 'Manual';

  @override
  String get scanWithCamera => 'Escanear con Cámara';

  @override
  String get selectPlateType => 'Seleccionar Tipo de Plato';

  @override
  String get plate => 'Plato';

  @override
  String get bowl => 'Tazón';

  @override
  String get smallPlate => 'Plato Pequeño';

  @override
  String get mediumPlate => 'Plato Mediano';

  @override
  String get largePlate => 'Plato Grande';

  @override
  String get smallBowl => 'Tazón Pequeño';

  @override
  String get mediumBowl => 'Tazón Mediano';

  @override
  String get largeBowl => 'Tazón Grande';

  @override
  String get fillLevel => 'Nivel de Llenado';

  @override
  String get quarter => '1/4 Lleno';

  @override
  String get half => '1/2 Lleno';

  @override
  String get threeQuarters => '3/4 Lleno';

  @override
  String get full => 'Lleno';

  @override
  String get selectFood => 'Seleccionar Comida';

  @override
  String get breakfast => 'Desayuno';

  @override
  String get lunch => 'Almuerzo';

  @override
  String get dinner => 'Cena';

  @override
  String get snacks => 'Bocadillos';

  @override
  String get egg => 'Huevo';

  @override
  String get milk => 'Leche';

  @override
  String get yogurt => 'Yogur';

  @override
  String get whiteRice => 'Arroz Blanco';

  @override
  String get plainPasta => 'Pasta Simple';

  @override
  String get chickenBreast => 'Pechuga de Pollo';

  @override
  String get grilledSalmon => 'Salmón a la Parrilla';

  @override
  String get boiledPotato => 'Patata Hervida';

  @override
  String get mixedVegetables => 'Verduras Mixtas';

  @override
  String get couscous => 'Cuscús';

  @override
  String get quinoa => 'Quinoa';

  @override
  String get bulgur => 'Bulgur';

  @override
  String get corn => 'Maíz';

  @override
  String get peas => 'Guisantes';

  @override
  String get broccoli => 'Brócoli';

  @override
  String get mushroom => 'Champiñón';

  @override
  String get stirFryVegetables => 'Verduras Salteadas';

  @override
  String get sweetPotato => 'Batata';

  @override
  String get baldoRice => 'Arroz Baldo';

  @override
  String get chickenCurry => 'Curry de Pollo';

  @override
  String get beefCurry => 'Curry de Carne';

  @override
  String get spaghettiPuttanesca => 'Espagueti Puttanesca';

  @override
  String get ravioli => 'Ravioli';

  @override
  String get gnocchi => 'Gnocchi';

  @override
  String get kidneyBeans => 'Frijoles Rojos';

  @override
  String get chickpeas => 'Garbanzos';

  @override
  String get lentils => 'Lentejas';

  @override
  String get whiteBeans => 'Frijoles Blancos';

  @override
  String get tuna => 'Atún';

  @override
  String get mussels => 'Mejillones';

  @override
  String get shrimp => 'Camarón';

  @override
  String get caesarSalad => 'Ensalada César';

  @override
  String get tofu => 'Tofu';

  @override
  String get salad => 'Ensalada';

  @override
  String get soup => 'Sopa';

  @override
  String get fruit => 'Fruta';

  @override
  String get vegetables => 'Verduras';

  @override
  String get mealLog => 'Registro de Comidas';

  @override
  String get todaysMeals => 'Comidas de Hoy';

  @override
  String get noMealsYet => 'Aún no se han agregado comidas';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get pushNotifications => 'Notificaciones push';

  @override
  String get pushNotificationsDesc =>
      'Recibe notificaciones de tus actividades';

  @override
  String get emailNotifications => 'Notificaciones por correo';

  @override
  String get emailNotificationsDesc =>
      'Recibe actualizaciones por correo electrónico';

  @override
  String get privacySecurity => 'Privacidad y seguridad';

  @override
  String get privacySettings => 'Configuración de privacidad';

  @override
  String get privacySettingsDesc => 'Administra tus preferencias de privacidad';

  @override
  String get dataStorage => 'Datos y almacenamiento';

  @override
  String get dataStorageDesc => 'Administra tus datos y almacenamiento';

  @override
  String get appSettings => 'Configuración de la aplicación';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get units => 'Unidades';

  @override
  String get about => 'Acerca de';

  @override
  String get helpSupport => 'Ayuda y soporte';

  @override
  String get helpSupportDesc => 'Obtén ayuda y contacta con soporte';

  @override
  String get termsConditions => 'Términos y condiciones';

  @override
  String get termsConditionsDesc => 'Lee nuestros términos y condiciones';

  @override
  String get aboutAlly => 'Acerca de Ally';

  @override
  String get version => 'Versión 1.0.0';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get selectTheme => 'Seleccionar tema';

  @override
  String get selectUnits => 'Seleccionar unidades';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get metric => 'Métrico';

  @override
  String get imperial => 'Imperial';

  @override
  String get personalInfo => 'Información personal';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get anonymousUser => 'Usuario anónimo';

  @override
  String get country => 'País';

  @override
  String get unitedStates => 'Estados Unidos';

  @override
  String get dateOfBirth => 'Fecha de nacimiento';

  @override
  String get january1 => '1 de enero de 1990';

  @override
  String get healthInfo => 'Información de salud';

  @override
  String get currentWeight => 'Peso actual';

  @override
  String get waterGoal => 'Objetivo de agua';

  @override
  String glassesPerDay(int count) {
    return '$count vasos/día';
  }

  @override
  String get calorieGoal => 'Objetivo de calorías';

  @override
  String kcalPerDay(int count) {
    return '$count kcal/día';
  }

  @override
  String get exerciseStreak => 'Racha de ejercicio';

  @override
  String get dangerZone => 'Zona de peligro';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountDesc => 'Elimina permanentemente tu cuenta y datos';

  @override
  String get noFriendsYet => 'Aún no hay amigos';

  @override
  String get addFriendsToSee => 'Agrega amigos para ver su actividad';

  @override
  String get noActivityYet => 'Aún no hay actividad';

  @override
  String get startTrackingToSee => 'Comienza a rastrear para ver tu actividad';

  @override
  String get badges => 'Insignias';

  @override
  String get dayStreakLabel => 'Racha de días';

  @override
  String get availableAchievements => 'Logros disponibles';

  @override
  String get hydrationHero => 'Héroe de Hidratación';

  @override
  String get drink8Glasses => 'Bebe 8 vasos de agua diariamente';

  @override
  String get points => 'puntos';

  @override
  String get workoutWarrior => 'Guerrero del ejercicio';

  @override
  String get complete7Days => 'Completa 7 días de ejercicio';

  @override
  String get sleepChampion => 'Campeón del Sueño';

  @override
  String get get8Hours => 'Duerme 8 horas durante 7 días';

  @override
  String get nutritionMaster => 'Maestro de nutrición';

  @override
  String get trackMeals => 'Registra comidas durante 30 días';

  @override
  String get heartHealth => 'Salud del corazón';

  @override
  String get maintain60to100 => 'Mantén 60-100 lpm durante una semana';

  @override
  String get waterIntake => 'Consumo de agua';

  @override
  String get mealLogged => 'Comida registrada';

  @override
  String get sleepLogged => 'Sueño registrado';

  @override
  String get weightUpdated => 'Peso actualizado';

  @override
  String get justNow => 'Justo ahora';

  @override
  String minutesAgo(int minutes) {
    return 'Hace ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'Hace ${hours}h';
  }

  @override
  String get lastNight => 'Anoche';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get sleepDuration => 'Duración del sueño';

  @override
  String get heartRate => 'Frecuencia cardíaca';

  @override
  String get scoreBreakdown => 'Desglose de puntuación';

  @override
  String get loseWeight => 'Perder Peso';

  @override
  String get reduceCalories => 'Reducir calorías';

  @override
  String get maintainWeight => 'Mantener Peso';

  @override
  String get balancedCalories => 'Calorías equilibradas';

  @override
  String get gainWeight => 'Ganar Peso';

  @override
  String get increaseCalories => 'Aumentar calorías';

  @override
  String get activityLevel => 'Nivel de Actividad';

  @override
  String get sedentary => 'Sedentario';

  @override
  String get littleExercise => 'Poco o ningún ejercicio';

  @override
  String get lightlyActive => 'Ligeramente activo';

  @override
  String get lightExercise => 'Ejercicio ligero 1-3 días/semana';

  @override
  String get moderatelyActive => 'Moderadamente activo';

  @override
  String get moderateExercise => 'Ejercicio moderado 3-5 días/semana';

  @override
  String get veryActive => 'Muy Activo';

  @override
  String get intenseTraining => 'Entrenamiento intenso diario';

  @override
  String get yourHealthScore => 'Tu Puntuación de Salud';

  @override
  String get outOf100 => 'de 100';

  @override
  String get workoutStreakDesc => 'Racha de ejercicio y actividad diaria';

  @override
  String get sleepQualityDesc => 'Duración y calidad del sueño';

  @override
  String get hydrationGoalDesc => 'Objetivo de hidratación diaria';

  @override
  String get weightProgressDesc => 'Progreso hacia el peso objetivo';

  @override
  String get calorieBalanceDesc => 'Balance de ingesta calórica';

  @override
  String get restingHeartRateDesc => 'Frecuencia cardíaca en reposo';

  @override
  String get todaysIntake => 'Ingesta de Hoy';

  @override
  String get noMealsLogged => 'No hay comidas registradas aún';

  @override
  String get tapToAddMeal => 'Toca + para añadir tu primera comida';

  @override
  String get todaysPrograms => 'Programas de Hoy';

  @override
  String get noWorkoutsLogged => 'No hay entrenamientos registrados aún';

  @override
  String get startFitnessJourney => '¡Comienza tu viaje fitness hoy!';

  @override
  String get noSleepData => 'No hay datos de sueño registrados';

  @override
  String get trackSleepPatterns => 'Registra tu sueño para ver patrones';

  @override
  String get progress => 'Progreso';

  @override
  String get noWeightHistory => 'Sin historial de peso';

  @override
  String get trackWeightProgress => 'Registra tu peso para ver el progreso';

  @override
  String get currentHeartRate => 'Frecuencia Cardíaca Actual';

  @override
  String get todaysReadings => 'Lecturas de Hoy';

  @override
  String get noReadingsYet => 'No hay lecturas aún';

  @override
  String get requiresMonitor =>
      'Requiere dispositivo monitor de frecuencia cardíaca';

  @override
  String get percentWeight => '% peso';

  @override
  String get tipMaintainStreak =>
      'Concéntrate en mantener tu racha de ejercicio';

  @override
  String get tipDrinkWater => 'Intenta beber 2 vasos más de agua hoy';

  @override
  String get tipBedtimeEarlier => 'Intenta dormir 30 minutos más temprano';

  @override
  String get weightGoalAchieved => 'Objetivo de Peso Alcanzado';

  @override
  String get reachTargetWeight => 'Alcanza tu peso objetivo';

  @override
  String get welcomeToAlly => 'Bienvenido a Ally';

  @override
  String get personalHealthCompanion => 'Tu compañero personal de salud';

  @override
  String get trackWellnessJourney =>
      'Rastrea tu viaje de bienestar con objetivos y perspectivas personalizadas';

  @override
  String drankGlasses(int count) {
    return 'Bebió $count vasos de agua';
  }

  @override
  String caloriesConsumed(int count) {
    return '$count calorías consumidas';
  }

  @override
  String dayStreakMaintained(int count) {
    return 'Racha de $count días mantenida';
  }

  @override
  String hoursOfSleep(String hours) {
    return '$hours horas de sueño';
  }

  @override
  String get todaysOverview => 'Resumen de Hoy';

  @override
  String get quickStats => 'Estadísticas Rápidas';

  @override
  String get totalActivity => 'Actividad Total';

  @override
  String get badgesEarned => 'Insignias Ganadas';

  @override
  String get setYourGoals => 'Establece Tus Objetivos';

  @override
  String get manageYourProfile => 'Administra Tu Perfil';

  @override
  String get firstSteps => 'Primeros Pasos';

  @override
  String get firstStepsDesc => 'Completa la configuración de tu perfil';

  @override
  String get earlyBird => 'Madrugador';

  @override
  String get earlyBirdDesc => 'Registra 7 días consecutivos';

  @override
  String get hydrationHeroDesc => 'Bebe 8 vasos al día durante 7 días';

  @override
  String get calorieCounter => 'Contador de Calorías';

  @override
  String get calorieCounterDesc => 'Rastrea comidas durante 30 días';

  @override
  String get weekWarrior => 'Guerrero Semanal';

  @override
  String get weekWarriorDesc => 'Haz ejercicio 5 veces a la semana';

  @override
  String get mileMaster => 'Maestro de Millas';

  @override
  String get mileMasterDesc => 'Corre un total de 100 millas';

  @override
  String get sleepChampionDesc => 'Duerme 8 horas durante 7 días';

  @override
  String get calculateCalorieNeeds =>
      'Esto nos ayuda a calcular tus necesidades calóricas diarias';

  @override
  String get personalizeHealthGoals =>
      'Usaremos esto para personalizar tus objetivos de salud';

  @override
  String get tellUsAboutYourself => 'Cuéntanos más sobre ti';

  @override
  String get determinesCalorieTarget =>
      'Esto determina tu objetivo de calorías';

  @override
  String get howActiveAreYou => '¿Qué tan activo eres en un día típico?';

  @override
  String get littleToNoExercise => 'Poco o ningún ejercicio';

  @override
  String get intenseDailyTraining => 'Entrenamiento intenso diario';

  @override
  String get light => 'Ligero';

  @override
  String get lightActivity => '1-3 días/semana';

  @override
  String get moderate => 'Moderado';

  @override
  String get moderateActivity => '3-5 días/semana';

  @override
  String get active => 'Activo';

  @override
  String get activeActivity => '6-7 días/semana';

  @override
  String get editWeight => 'Edit Weight';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeYourPlan => 'Mejora tu Plan';

  @override
  String get unlockMore => 'Desbloquea Más.';

  @override
  String get goPremium => 'Hazte Premium';

  @override
  String get upgradeForExclusive =>
      'Mejora para obtener ventajas exclusivas y una experiencia\nmás fluida y rápida.';

  @override
  String get individual => 'Individual';

  @override
  String get family => 'Familia';

  @override
  String get familyPlan => 'Plan Familiar';

  @override
  String get allyIndividual => 'Ally Individual';

  @override
  String get month => 'mes';

  @override
  String get allIndividualFeatures =>
      'Todas las funciones Individual más\ncompartir en familia hasta 4 miembros.';

  @override
  String get getAllyPlan => 'Obtener Plan Ally';

  @override
  String get getFamilyPlan => 'Obtener Plan Familiar';

  @override
  String get friendRequestSent => 'Solicitud de Amistad Enviada';

  @override
  String requestSentTo(String username) {
    return '¡Solicitud enviada a $username con éxito!';
  }

  @override
  String get selectExercise => 'Seleccionar Ejercicio';

  @override
  String get all => 'Todos';

  @override
  String get addExercisesToStart => 'Agregar ejercicios para comenzar';

  @override
  String get tapPlusButton => 'Toca el botón + a continuación';

  @override
  String get reps => 'Repeticiones';

  @override
  String get rest => 'Descanso (s)';

  @override
  String get addSet => 'Agregar Serie';

  @override
  String get workoutName => 'Nombre del Entrenamiento';

  @override
  String get enterWorkoutName => 'Ingresa nombre del entrenamiento';

  @override
  String get createWorkout => 'Crear Entrenamiento';

  @override
  String get editWorkout => 'Editar Entrenamiento';

  @override
  String get deleteWorkout => 'Eliminar Entrenamiento';

  @override
  String get areYouSureDelete =>
      '¿Estás seguro de que deseas eliminar este entrenamiento?';

  @override
  String get delete => 'Eliminar';

  @override
  String completedAt(String time) {
    return 'Completado a las $time';
  }

  @override
  String get set => 'Serie';

  @override
  String get quickExerciseLog => 'Registro Rápido de Ejercicio';

  @override
  String get logYourExercise => 'Registra tu ejercicio';

  @override
  String get exerciseName => 'Nombre del Ejercicio';

  @override
  String get enterExerciseName => 'Ingresa nombre del ejercicio';

  @override
  String get sets => 'Series';

  @override
  String get duration => 'Duración';

  @override
  String get minutes => 'minutos';

  @override
  String get logExercise => 'Registrar Ejercicio';

  @override
  String get close => 'Cerrar';

  @override
  String get customProgram => 'Programa Personalizado';

  @override
  String get buildYourOwnWorkout => 'Crea tu propio entrenamiento';

  @override
  String get quickLog => 'Registro Rápido';

  @override
  String get logASingleExercise => 'Registrar un solo ejercicio';

  @override
  String get noStreakYet => 'Aún no hay racha';

  @override
  String get day => 'día';

  @override
  String get keepGoing => '¡Sigue así!';

  @override
  String get quickPrograms => 'Programas Rápidos';

  @override
  String get createProgramToQuicklyStart =>
      'Crea un programa para comenzar rápidamente';

  @override
  String get min => 'min';

  @override
  String get ex => 'ej';

  @override
  String get editProgram => 'Editar Programa';

  @override
  String get deleteProgram => 'Eliminar Programa';

  @override
  String get deleteProgramQuestion => '¿Eliminar Programa?';

  @override
  String areYouSureDeleteProgram(String name) {
    return '¿Estás seguro de que deseas eliminar \"$name\"?';
  }

  @override
  String get logged => 'registrado';

  @override
  String get kg => 'kg';

  @override
  String editSetNumber(int number) {
    return 'Editar Serie $number';
  }

  @override
  String weightWithUnit(String unit) {
    return 'Peso ($unit)';
  }

  @override
  String get exerciseNotFound => 'Ejercicio no encontrado';

  @override
  String get exitWorkout => '¿Salir del Entrenamiento?';

  @override
  String get progressNotSaved => 'Tu progreso no se guardará.';

  @override
  String get exit => 'Salir';

  @override
  String get finish => 'Finalizar';

  @override
  String exerciseProgress(int current, int total) {
    return 'Ejercicio $current/$total';
  }

  @override
  String percentComplete(int percent) {
    return '$percent% Completo';
  }

  @override
  String get restTime => 'Tiempo de Descanso';

  @override
  String get skip => 'Saltar';

  @override
  String get repsLowercase => 'repeticiones';

  @override
  String get kgUnit => 'kg';

  @override
  String get workoutNotComplete => 'Entrenamiento No Completado';

  @override
  String get workoutNotCompleteMessage =>
      'No has terminado todas las series. ¿Quieres guardar tu progreso y terminar de todos modos?';

  @override
  String get finishAnyway => 'Terminar de Todos Modos';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get workoutCompleted => '¡Entrenamiento Completado!';

  @override
  String get enableStepTracking => 'Habilitar Seguimiento de Pasos';

  @override
  String get stepPermissionMessage =>
      'Necesitamos permiso de reconocimiento de actividad para contar tus pasos en segundo plano.';

  @override
  String get later => 'Más tarde';

  @override
  String get allow => 'Permitir';

  @override
  String get stepTrackingEnabled => '✅ ¡Seguimiento de pasos activado!';

  @override
  String get permissionDenied => '⚠️ Permiso denegado';

  @override
  String get profile => 'Perfil';

  @override
  String get yourProfile => 'Tu Perfil';

  @override
  String get support => 'Soporte';

  @override
  String get legal => 'Legal';

  @override
  String get healthClosestAlly => 'El aliado más cercano de tu salud.';

  @override
  String get openingWebsite => 'Abriendo sitio web...';

  @override
  String get visitWebsite => 'Visitar Sitio Web';

  @override
  String get licensedApache => 'Licenciado bajo Apache License 2.0';

  @override
  String get licensedApache2 => 'Licenciado bajo Apache 2.0';

  @override
  String get copyright => '© 2025 Vertex Corporation';

  @override
  String get readPolicies => 'Lee nuestras políticas y términos';

  @override
  String get openingPrivacyPolicy => 'Abriendo Política de Privacidad...';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get openingTerms => 'Abriendo Términos de Servicio...';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get editWaterGoal => 'Editar Objetivo de Agua';

  @override
  String get glasses => 'vasos';

  @override
  String get editCalorieGoal => 'Editar Objetivo de Calorías';

  @override
  String get kcal => 'kcal';

  @override
  String get goalWeight => 'Peso Objetivo';

  @override
  String get editHeight => 'Editar Altura';

  @override
  String get height => 'Altura';

  @override
  String get cm => 'cm';

  @override
  String get feet => 'Pies';

  @override
  String get inches => 'Pulgadas';

  @override
  String get bodyMassIndex => 'Índice de Masa Corporal (IMC)';

  @override
  String get notCalculated => 'No calculado';

  @override
  String get addHeightWeight => 'Agregar altura y peso';

  @override
  String get noAchievementsYet => 'Aún No Hay Logros';

  @override
  String get startTrackingForAchievements =>
      '¡Comienza a rastrear tu salud para desbloquear logros!';

  @override
  String get authFailed =>
      'Autenticación fallida. Continuando sin iniciar sesión.';

  @override
  String get firebaseNotConfigured =>
      'Firebase no configurado. Use inicio de sesión anónimo.';

  @override
  String get googleSignInFailed =>
      'Inicio de sesión con Google fallido. Use inicio de sesión anónimo en su lugar.';

  @override
  String emailSignInFailed(String error) {
    return 'Inicio de sesión con correo electrónico fallido: $error';
  }

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get chooseSignInMethod => 'Elige tu método de inicio de sesión';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithEmail => 'Continuar con Correo';

  @override
  String get continueAsAnonymous => 'Continuar como Anónimo';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta? ';

  @override
  String get signUp => 'Registrarse';

  @override
  String get legalAgreement =>
      'Al iniciar sesión/registrarte, aceptas nuestra Política de Privacidad y Términos de Servicio';

  @override
  String get signInWithEmail => 'Iniciar sesión con correo';

  @override
  String get enterEmailAddress => 'Ingresa tu dirección de correo';

  @override
  String get email => 'Correo';

  @override
  String get enterPassword => 'Ingresa tu contraseña';

  @override
  String get password => 'Contraseña';

  @override
  String get firebaseNotConfiguredSignup =>
      'Firebase no configurado. Continuando sin registro.';

  @override
  String signUpFailed(String error) {
    return 'Registro fallido: $error';
  }

  @override
  String get chooseUsername => 'Elige tu nombre de usuario';

  @override
  String get username => 'Nombre de Usuario';

  @override
  String get createPassword => 'Crea una contraseña';

  @override
  String get back => 'Atrás';

  @override
  String get startJourney => 'Comenzar Viaje';

  @override
  String get continueAlly => 'Continuar';

  @override
  String get chooseUnits => 'Elige tus unidades';

  @override
  String get selectSystemPrefer => 'Selecciona el sistema que prefieras';

  @override
  String get kgCm => 'kg, cm';

  @override
  String get lbsIn => 'lbs, in';

  @override
  String get whatsYourWeight => '¿Cuál es tu peso?';

  @override
  String get personalizeJourney => 'Ayúdanos a personalizar tu viaje';

  @override
  String get whatsYourHeight => '¿Cuál es tu altura?';

  @override
  String get calculateIdealMetrics => 'Calcularemos tus métricas ideales';

  @override
  String get whatsYourAge => '¿Cuál es tu edad?';

  @override
  String get createPerfectPlan => 'Creemos tu plan de salud perfecto';

  @override
  String get years => 'años';

  @override
  String get dailyStepGoal => 'Objetivo de pasos diarios';

  @override
  String weightPercent(int weight) {
    return '$weight% peso';
  }

  @override
  String get ally => 'Ally';

  @override
  String get yourHealths => 'El aliado más\n';

  @override
  String get closest => 'cercano ';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get service => 'Servicio';

  @override
  String get automaticSleepTracking => 'Seguimiento Automático del Sueño';

  @override
  String get noSmartwatchNeeded =>
      '¡No se necesita reloj inteligente! Rastrea tu sueño automáticamente.';

  @override
  String get whenDoYouSleep => '¿Cuándo sueles dormir?';

  @override
  String get sleepTime => 'Hora de Dormir';

  @override
  String get wakeTime => 'Hora de Despertar';

  @override
  String get sleepTrackingTitle => 'Seguimiento del Sueño';

  @override
  String get automaticTrackingEnabled => 'Seguimiento automático habilitado';

  @override
  String get startTracking => 'Iniciar Seguimiento';

  @override
  String get sleepSegments => 'Segmentos de Sueño';

  @override
  String get sleepCycles => 'Ciclos de Sueño';

  @override
  String get wakeUps => 'Despertares';

  @override
  String get noSleepDataYet => 'Aún no hay datos de sueño';

  @override
  String get sleepTrackingStartTonight =>
      'El seguimiento del sueño comenzará esta noche';

  @override
  String get currentlySleeping => 'Durmiendo Actualmente';

  @override
  String sleepSegmentNumber(int number) {
    return 'Segmento de Sueño $number';
  }

  @override
  String get setWaterGoal => 'Establece Tu Objetivo de Agua';

  @override
  String get howMuchWater => '¿Cuánta agua quieres beber diariamente?';

  @override
  String get goalUpdated => 'Objetivo Actualizado';

  @override
  String get editGoal => 'Editar Objetivo';

  @override
  String get quickAdd => 'Agregar Rápido';

  @override
  String get updateWeight => 'Actualizar Peso';

  @override
  String enterWeight(String unit) {
    return 'Ingresa peso ($unit)';
  }

  @override
  String get weightHistory => 'Historial de Peso';

  @override
  String get startTrackingWeight => 'Comienza a rastrear tu progreso de peso';

  @override
  String get setCalorieGoal => 'Establece Tu Objetivo de Calorías';

  @override
  String get howManyCalories =>
      '¿Cuántas calorías quieres consumir diariamente?';

  @override
  String get goalSet => 'Objetivo Establecido';

  @override
  String calorieGoalSet(int calories) {
    return 'Tu objetivo diario de calorías ahora es $calories kcal';
  }

  @override
  String get addFriend => 'Agregar Amigo';

  @override
  String get welcomeText1 => 'Tu salud';

  @override
  String get welcomeText2 => 'más cercana';

  @override
  String get welcomeText3 => 'aliado';

  @override
  String get serviceControls => 'Controles de Servicio';

  @override
  String get startService => 'Iniciar Servicio';

  @override
  String get restartService => 'Reiniciar Servicio';

  @override
  String get stopService => 'Detener Servicio';

  @override
  String get setYourGoal => 'Establece Tu Objetivo';

  @override
  String get howManySteps => 'Cuántos pasos quieres lograr hoy?';

  @override
  String get serviceStarted => 'Servicio Iniciado';

  @override
  String get serviceStartedDesc =>
      'El servicio de contador de pasos ahora está funcionando';

  @override
  String get serviceRestarted => 'Servicio Reiniciado';

  @override
  String get serviceRestartedDesc =>
      'El servicio de contador de pasos ha sido reiniciado';

  @override
  String get serviceStopped => 'Servicio Detenido';

  @override
  String get serviceStoppedDesc =>
      'El servicio de contador de pasos ha sido detenido';

  @override
  String dailyGoalSet(Object goal) {
    return 'Tu objetivo diario ahora es $goal pasos';
  }

  @override
  String get stepsLabel => 'pasos';

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
  String get programNameHint => 'Nombre del programa (ej: Día Push)';

  @override
  String get usernameHint => 'Nombre de usuario';

  @override
  String get emailHint => 'Correo electrónico';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get dailyCalorieHint => '2000';

  @override
  String get usernameAtHint => '@nombredeusuario';

  @override
  String programUpdated(String name) {
    return '¡Programa \"$name\" actualizado!';
  }

  @override
  String programSaved(String name) {
    return '¡Programa \"$name\" guardado!';
  }

  @override
  String valueOfTarget(String value, String target) {
    return '$value de $target';
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
  String get licensedApache2Short => 'Licenciado bajo Apache 2.0';

  @override
  String get waterGoalLabel => 'Objetivo de Agua';

  @override
  String get calorieGoalLabel => 'Objetivo de Calorías';

  @override
  String get enterWeightLbs => 'Ingrese peso (lbs)';

  @override
  String get enterWeightKg => 'Ingrese peso (kg)';

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
  String get bpmUnit => 'LPM';

  @override
  String ofHoursGoal(String hours) {
    return 'de ${hours}h';
  }

  @override
  String get nowLabel => 'Ahora';

  @override
  String dailyGoalSetTo(String value, String unit) {
    return 'Objetivo diario establecido en $value$unit';
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
      'Ingrese el nombre de usuario de su amigo para seguir su actividad';

  @override
  String get sendRequest => 'Enviar Solicitud';

  @override
  String subscribeToPlan(String title) {
    return 'Suscribirse al plan $title';
  }

  @override
  String restSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get setYourCalorieGoal => 'Establece Tu Objetivo de Calorías';

  @override
  String get workoutBuilder => 'Constructor de Entrenamiento';

  @override
  String get whenDoYouUsuallySleep => '¿Cuándo sueles dormir?';

  @override
  String get sleepTrackingWillStartTonight =>
      'El seguimiento del sueño comenzará esta noche';
}
