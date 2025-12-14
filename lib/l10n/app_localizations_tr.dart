// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Ally';

  @override
  String get welcomeTitle => 'Ally';

  @override
  String get welcomeDescription => 'Sağlığınızın en yakın dostu.';

  @override
  String get letsStart => 'Hadi başlayalım!';

  @override
  String get loginTitle => 'Giriş';

  @override
  String get continueAnonymously => 'Anonim Devam Et';

  @override
  String get loginDescription => 'Devam etmek için giriş yapın';

  @override
  String get dailyReflection => 'Günlük yansıma';

  @override
  String get helloAnonymous => 'Merhaba, anonim!';

  @override
  String get healthScore => 'Sağlık Skoru';

  @override
  String get today => 'Bugün';

  @override
  String get of100 => '/ 100';

  @override
  String get exercises => 'Egzersizler';

  @override
  String dayStreak(int count) {
    return '$count günlük seri';
  }

  @override
  String daysCount(int count) {
    return '$count gün';
  }

  @override
  String get nutrition => 'Beslenme';

  @override
  String calories(int count) {
    return '$count kal';
  }

  @override
  String get sleep => 'Uyku';

  @override
  String hours(String hours) {
    return '${hours}s';
  }

  @override
  String get water => 'Su';

  @override
  String waterGlasses(int current, int goal) {
    return '$current / $goal bardak';
  }

  @override
  String get weight => 'Ağırlık';

  @override
  String weightKg(double weight) {
    return '$weight kg';
  }

  @override
  String get heartbeat => 'Kalp Atışı';

  @override
  String bpm(int bpm) {
    return '$bpm bpm';
  }

  @override
  String get pedometer => 'Adımlar';

  @override
  String steps(int current, int goal) {
    return 'adım';
  }

  @override
  String get home => 'Ana Sayfa';

  @override
  String get activity => 'Aktivite';

  @override
  String get achievements => 'Başarılar';

  @override
  String get account => 'Hesap';

  @override
  String get settings => 'Ayarlar';

  @override
  String get friendsActivity => 'Arkadaş Aktivitesi';

  @override
  String get myActivity => 'Aktivitem';

  @override
  String get yourAchievements => 'Başarılarınız';

  @override
  String get totalPoints => 'Toplam Puan';

  @override
  String get completedChallenges => 'Tamamlanan Görevler';

  @override
  String get currentStreak => 'Mevcut Seri';

  @override
  String get days => 'gün';

  @override
  String get completed => 'tamamlandı';

  @override
  String get quickActions => 'Hızlı İşlemler';

  @override
  String get add500Steps => '500 Adım Ekle';

  @override
  String get add1000Steps => '1000 Adım Ekle';

  @override
  String get setGoal => 'Hedef Belirle';

  @override
  String get stepsGoal => 'Adım Hedefi';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get addExercise => 'Egzersiz Ekle';

  @override
  String get exerciseType => 'Egzersiz Tipi';

  @override
  String get cardio => 'Kardiyo';

  @override
  String get strength => 'Kuvvet';

  @override
  String get flexibility => 'Esneklik';

  @override
  String get sports => 'Spor';

  @override
  String get addNutrition => 'Beslenme Ekle';

  @override
  String get automatic => 'Otomatik';

  @override
  String get manual => 'Manuel';

  @override
  String get scanWithCamera => 'Kamera ile Tara';

  @override
  String get selectPlateType => 'Tabak Tipi Seç';

  @override
  String get plate => 'Tabak';

  @override
  String get bowl => 'Kase';

  @override
  String get smallPlate => 'Küçük Tabak';

  @override
  String get mediumPlate => 'Orta Tabak';

  @override
  String get largePlate => 'Büyük Tabak';

  @override
  String get smallBowl => 'Küçük Kase';

  @override
  String get mediumBowl => 'Orta Kase';

  @override
  String get largeBowl => 'Büyük Kase';

  @override
  String get fillLevel => 'Doluluk Seviyesi';

  @override
  String get quarter => '1/4 Dolu';

  @override
  String get half => '1/2 Dolu';

  @override
  String get threeQuarters => '3/4 Dolu';

  @override
  String get full => 'Dolu';

  @override
  String get selectFood => 'Yemek Seç';

  @override
  String get breakfast => 'Kahvaltı';

  @override
  String get lunch => 'Öğle Yemeği';

  @override
  String get dinner => 'Akşam Yemeği';

  @override
  String get snacks => 'Atıştırmalık';

  @override
  String get egg => 'Yumurta';

  @override
  String get milk => 'Süt';

  @override
  String get yogurt => 'Yoğurt';

  @override
  String get whiteRice => 'Beyaz Pirinç';

  @override
  String get plainPasta => 'Sade Makarna';

  @override
  String get chickenBreast => 'Tavuk Göğsü';

  @override
  String get grilledSalmon => 'Izgara Somon';

  @override
  String get boiledPotato => 'Haşlanmış Patates';

  @override
  String get mixedVegetables => 'Karışık Sebze';

  @override
  String get couscous => 'Kuskus';

  @override
  String get quinoa => 'Kinoa';

  @override
  String get bulgur => 'Bulgur';

  @override
  String get corn => 'Mısır';

  @override
  String get peas => 'Bezelye';

  @override
  String get broccoli => 'Brokoli';

  @override
  String get mushroom => 'Mantar';

  @override
  String get stirFryVegetables => 'Sebze Sote';

  @override
  String get sweetPotato => 'Tatlı Patates';

  @override
  String get baldoRice => 'Baldo Pirinç';

  @override
  String get chickenCurry => 'Tavuklu Körili';

  @override
  String get beefCurry => 'Etli Körili';

  @override
  String get spaghettiPuttanesca => 'Spagetti';

  @override
  String get ravioli => 'Mantı';

  @override
  String get gnocchi => 'Gnocchi';

  @override
  String get kidneyBeans => 'Barbunya';

  @override
  String get chickpeas => 'Nohut';

  @override
  String get lentils => 'Mercimek';

  @override
  String get whiteBeans => 'Kuru Fasulye';

  @override
  String get tuna => 'Ton Balığı';

  @override
  String get mussels => 'Midye';

  @override
  String get shrimp => 'Karides';

  @override
  String get caesarSalad => 'Sezar Salata';

  @override
  String get tofu => 'Tofu';

  @override
  String get salad => 'Salata';

  @override
  String get soup => 'Çorba';

  @override
  String get fruit => 'Meyve';

  @override
  String get vegetables => 'Sebzeler';

  @override
  String get mealLog => 'Yemek Kaydı';

  @override
  String get todaysMeals => 'Bugünkü Öğünler';

  @override
  String get noMealsYet => 'Henüz yemek eklenmedi';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get pushNotifications => 'Anlık Bildirimler';

  @override
  String get pushNotificationsDesc => 'Aktiviteleriniz için bildirim alın';

  @override
  String get emailNotifications => 'E-posta Bildirimleri';

  @override
  String get emailNotificationsDesc => 'E-posta ile güncelleme alın';

  @override
  String get privacySecurity => 'Gizlilik ve Güvenlik';

  @override
  String get privacySettings => 'Gizlilik Ayarları';

  @override
  String get privacySettingsDesc => 'Gizlilik tercihlerinizi yönetin';

  @override
  String get dataStorage => 'Veri ve Depolama';

  @override
  String get dataStorageDesc => 'Verilerinizi ve depolamanızı yönetin';

  @override
  String get appSettings => 'Uygulama Ayarları';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get units => 'Birimler';

  @override
  String get about => 'Hakkında';

  @override
  String get helpSupport => 'Yardım ve Destek';

  @override
  String get helpSupportDesc => 'Yardım alın ve destekle iletişime geçin';

  @override
  String get termsConditions => 'Şartlar ve Koşullar';

  @override
  String get termsConditionsDesc => 'Şartlarımızı ve koşullarımızı okuyun';

  @override
  String get aboutAlly => 'Ally Hakkında';

  @override
  String get version => 'Versiyon 1.0.0';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get selectTheme => 'Tema Seçin';

  @override
  String get selectUnits => 'Birim Seçin';

  @override
  String get systemDefault => 'Sistem Varsayılanı';

  @override
  String get lightMode => 'Açık Mod';

  @override
  String get darkMode => 'Koyu Mod';

  @override
  String get metric => 'Metrik';

  @override
  String get imperial => 'İngiliz Birimi';

  @override
  String get personalInfo => 'Kişisel Bilgiler';

  @override
  String get fullName => 'Tam Ad';

  @override
  String get anonymousUser => 'Anonim Kullanıcı';

  @override
  String get country => 'Ülke';

  @override
  String get unitedStates => 'Amerika Birleşik Devletleri';

  @override
  String get dateOfBirth => 'Doğum Tarihi';

  @override
  String get january1 => '1 Ocak 1990';

  @override
  String get healthInfo => 'Sağlık Bilgileri';

  @override
  String get currentWeight => 'Mevcut Kilo';

  @override
  String get waterGoal => 'Su Hedefi';

  @override
  String glassesPerDay(int count) {
    return '$count bardak/gün';
  }

  @override
  String get calorieGoal => 'Kalori Hedefi';

  @override
  String kcalPerDay(int count) {
    return '$count kkal/gün';
  }

  @override
  String get exerciseStreak => 'Egzersiz Serisi';

  @override
  String get dangerZone => 'Tehlike Bölgesi';

  @override
  String get deleteAccount => 'Hesabı Sil';

  @override
  String get deleteAccountDesc =>
      'Hesabınızı ve verilerinizi kalıcı olarak silin';

  @override
  String get noFriendsYet => 'Henüz arkadaş yok';

  @override
  String get addFriendsToSee => 'Aktivitelerini görmek için arkadaş ekleyin';

  @override
  String get noActivityYet => 'Henüz aktivite yok';

  @override
  String get startTrackingToSee =>
      'Aktivitelerinizi görmek için takip başlatın';

  @override
  String get badges => 'Rozetler';

  @override
  String get dayStreakLabel => 'Günlük Seri';

  @override
  String get availableAchievements => 'Mevcut Başarımlar';

  @override
  String get hydrationHero => 'Hidrasyon Kahramanı';

  @override
  String get drink8Glasses => 'Günlük 8 bardak su için';

  @override
  String get points => 'puan';

  @override
  String get workoutWarrior => 'Egzersiz Savaşçısı';

  @override
  String get complete7Days => '7 günlük egzersiz tamamla';

  @override
  String get sleepChampion => 'Uyku Şampiyonu';

  @override
  String get get8Hours => '7 gün boyunca 8 saat uyku';

  @override
  String get nutritionMaster => 'Beslenme Ustası';

  @override
  String get trackMeals => '30 gün öğün takibi';

  @override
  String get heartHealth => 'Kalp Sağlığı';

  @override
  String get maintain60to100 => 'Bir hafta 60-100 nabız koruyun';

  @override
  String get waterIntake => 'Su Alımı';

  @override
  String get mealLogged => 'Öğün Kaydedildi';

  @override
  String get sleepLogged => 'Uyku Kaydedildi';

  @override
  String get weightUpdated => 'Kilo Güncellendi';

  @override
  String get justNow => 'Şimdi';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}d önce';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}s önce';
  }

  @override
  String get lastNight => 'Dün gece';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get sleepDuration => 'Uyku Süresi';

  @override
  String get heartRate => 'Kalp Atışı';

  @override
  String get scoreBreakdown => 'Skor Dağılımı';

  @override
  String get loseWeight => 'Kilo Ver';

  @override
  String get reduceCalories => 'Kaloriyi azalt';

  @override
  String get maintainWeight => 'Kiloyu Koru';

  @override
  String get balancedCalories => 'Dengeli kaloriler';

  @override
  String get gainWeight => 'Kilo Al';

  @override
  String get increaseCalories => 'Kaloriyi artır';

  @override
  String get activityLevel => 'Aktivite Seviyesi';

  @override
  String get sedentary => 'Hareketsiz';

  @override
  String get littleExercise => 'Az veya hiç egzersiz yok';

  @override
  String get lightlyActive => 'Hafif Aktif';

  @override
  String get lightExercise => 'Haftada 1-3 gün hafif egzersiz';

  @override
  String get moderatelyActive => 'Orta Aktif';

  @override
  String get moderateExercise => 'Haftada 3-5 gün orta egzersiz';

  @override
  String get veryActive => 'Çok Aktif';

  @override
  String get intenseTraining => 'Günlük yoğun antrenman';

  @override
  String get yourHealthScore => 'Sağlık Puanınız';

  @override
  String get outOf100 => '/ 100';

  @override
  String get workoutStreakDesc => 'Egzersiz serisi ve günlük aktivite';

  @override
  String get sleepQualityDesc => 'Uyku süresi ve kalitesi';

  @override
  String get hydrationGoalDesc => 'Günlük hidrasyon hedefi';

  @override
  String get weightProgressDesc => 'Hedef kilosundaki ilerleme';

  @override
  String get calorieBalanceDesc => 'Kalori alımı dengesi';

  @override
  String get restingHeartRateDesc => 'Dinlenme kalp atış hızı';

  @override
  String get todaysIntake => 'Bugünkü Alım';

  @override
  String get noMealsLogged => 'Henüz öğün kaydedilmedi';

  @override
  String get tapToAddMeal => 'İlk öğününüzü eklemek için + düğmesine dokunun';

  @override
  String get todaysPrograms => 'Bugünkü Programlar';

  @override
  String get noWorkoutsLogged => 'Henüz egzersiz kaydedilmedi';

  @override
  String get startFitnessJourney => 'Fitness yolculuğunuza bugün başlayın!';

  @override
  String get noSleepData => 'Uyku verisi kaydedilmedi';

  @override
  String get trackSleepPatterns => 'Uyku düzenlerini görmek için takip edin';

  @override
  String get progress => 'İlerleme';

  @override
  String get noWeightHistory => 'Kilo geçmişi yok';

  @override
  String get trackWeightProgress =>
      'İlerlemeyi görmek için kilonuzu takip edin';

  @override
  String get currentHeartRate => 'Mevcut Kalp Atış Hızı';

  @override
  String get todaysReadings => 'Bugünkü Ölçümler';

  @override
  String get noReadingsYet => 'Henüz ölçüm yok';

  @override
  String get requiresMonitor => 'Kalp atış hızı monitörü cihazı gerektirir';

  @override
  String get percentWeight => '% ağırlık';

  @override
  String get tipMaintainStreak => 'Egzersiz serinizi sürdürmeye odaklanın';

  @override
  String get tipDrinkWater => 'Bugün 2 bardak daha su içmeye çalışın';

  @override
  String get tipBedtimeEarlier => '30 dakika daha erken yatmayı hedefleyin';

  @override
  String get weightGoalAchieved => 'Kilo Hedefi Ulaşıldı';

  @override
  String get reachTargetWeight => 'Hedef kilonuza ulaşın';

  @override
  String get welcomeToAlly => 'Ally\'ye Hoş Geldiniz';

  @override
  String get personalHealthCompanion => 'Kişisel sağlık yardımcınız';

  @override
  String get trackWellnessJourney =>
      'Kişiselleştirilmiş hedefler ve içgörülerle sağlık yolculuğunuzu takip edin';

  @override
  String drankGlasses(int count) {
    return '$count bardak su içildi';
  }

  @override
  String caloriesConsumed(int count) {
    return '$count kalori tüketildi';
  }

  @override
  String dayStreakMaintained(int count) {
    return '$count günlük seri sürdürüldü';
  }

  @override
  String hoursOfSleep(String hours) {
    return '$hours saat uyku';
  }

  @override
  String get todaysOverview => 'Bugünün Özeti';

  @override
  String get quickStats => 'Hızlı İstatistikler';

  @override
  String get totalActivity => 'Toplam Aktivite';

  @override
  String get badgesEarned => 'Kazanılan Rozetler';

  @override
  String get setYourGoals => 'Hedeflerinizi Belirleyin';

  @override
  String get manageYourProfile => 'Profilinizi Yönetin';

  @override
  String get firstSteps => 'İlk Adımlar';

  @override
  String get firstStepsDesc => 'Profil kurulumunuzu tamamlayın';

  @override
  String get earlyBird => 'Erken Kalkan';

  @override
  String get earlyBirdDesc => '7 ardışık gün kaydedin';

  @override
  String get hydrationHeroDesc => '7 gün boyunca günde 8 bardak su için';

  @override
  String get calorieCounter => 'Kalori Sayacı';

  @override
  String get calorieCounterDesc => '30 gün boyunca öğün takibi yapın';

  @override
  String get weekWarrior => 'Haftalık Savaşçı';

  @override
  String get weekWarriorDesc => 'Haftada 5 kez egzersiz yapın';

  @override
  String get mileMaster => 'Mil Ustası';

  @override
  String get mileMasterDesc => 'Toplam 100 mil koşun';

  @override
  String get sleepChampionDesc => '7 gün boyunca 8 saat uyuyun';

  @override
  String get calculateCalorieNeeds =>
      'Bu, günlük kalori ihtiyacınızı hesaplamamıza yardımcı olur';

  @override
  String get personalizeHealthGoals =>
      'Sağlık hedeflerinizi kişiselleştirmek için bunu kullanacağız';

  @override
  String get tellUsAboutYourself => 'Bize kendinizden bahsedin';

  @override
  String get determinesCalorieTarget => 'Bu, kalori hedefinizi belirler';

  @override
  String get howActiveAreYou => 'Tipik bir günde ne kadar aktifsiniz?';

  @override
  String get littleToNoExercise => 'Az veya hiç egzersiz yok';

  @override
  String get intenseDailyTraining => 'Yoğun günlük antrenman';

  @override
  String get light => 'Hafif';

  @override
  String get lightActivity => 'Haftada 1-3 gün';

  @override
  String get moderate => 'Orta';

  @override
  String get moderateActivity => 'Haftada 3-5 gün';

  @override
  String get active => 'Aktif';

  @override
  String get activeActivity => 'Haftada 6-7 gün';

  @override
  String get editWeight => 'Kiloyu Düzenle';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeYourPlan => 'Planını Yükselt';

  @override
  String get unlockMore => 'Daha Fazlasını Aç.';

  @override
  String get goPremium => 'Premium\'a Geç';

  @override
  String get upgradeForExclusive =>
      'Özel avantajlar ve daha akıcı,\ndaha hızlı deneyim için yükselt.';

  @override
  String get individual => 'Bireysel';

  @override
  String get family => 'Aile';

  @override
  String get familyPlan => 'Aile Planı';

  @override
  String get allyIndividual => 'Ally Bireysel';

  @override
  String get month => 'ay';

  @override
  String get allIndividualFeatures =>
      'Tüm Bireysel özellikler artı\n4 kişiye kadar aile paylaşımı.';

  @override
  String get getAllyPlan => 'Ally Planı Al';

  @override
  String get getFamilyPlan => 'Aile Planı Al';

  @override
  String get friendRequestSent => 'Arkadaşlık İsteği Gönderildi';

  @override
  String requestSentTo(String username) {
    return '$username kullanıcısına istek başarıyla gönderildi!';
  }

  @override
  String get selectExercise => 'Egzersiz Seç';

  @override
  String get all => 'Tümü';

  @override
  String get addExercisesToStart => 'Başlamak için egzersiz ekle';

  @override
  String get tapPlusButton => 'Aşağıdaki + butonuna dokun';

  @override
  String get reps => 'Tekrar';

  @override
  String get rest => 'Dinlenme (sn)';

  @override
  String get addSet => 'Set Ekle';

  @override
  String get workoutName => 'Antrenman Adı';

  @override
  String get enterWorkoutName => 'Antrenman adı girin';

  @override
  String get createWorkout => 'Antrenman Oluştur';

  @override
  String get editWorkout => 'Antrenmanı Düzenle';

  @override
  String get deleteWorkout => 'Antrenmanı Sil';

  @override
  String get areYouSureDelete =>
      'Bu antrenmanı silmek istediğinizden emin misiniz?';

  @override
  String get delete => 'Sil';

  @override
  String completedAt(String time) {
    return '$time saatinde tamamlandı';
  }

  @override
  String get set => 'Set';

  @override
  String get quickExerciseLog => 'Hızlı Egzersiz Kaydı';

  @override
  String get logYourExercise => 'Egzersizini kaydet';

  @override
  String get exerciseName => 'Egzersiz Adı';

  @override
  String get enterExerciseName => 'Egzersiz adı girin';

  @override
  String get sets => 'Setler';

  @override
  String get duration => 'Süre';

  @override
  String get minutes => 'dakika';

  @override
  String get logExercise => 'Egzersiz Kaydet';

  @override
  String get close => 'Kapat';

  @override
  String get customProgram => 'Özel Program';

  @override
  String get buildYourOwnWorkout => 'Kendi antrenmanınızı oluşturun';

  @override
  String get quickLog => 'Hızlı Kayıt';

  @override
  String get logASingleExercise => 'Tek bir egzersiz kaydet';

  @override
  String get noStreakYet => 'Henüz seri yok';

  @override
  String get day => 'gün';

  @override
  String get keepGoing => 'Devam et!';

  @override
  String get quickPrograms => 'Hızlı Programlar';

  @override
  String get createProgramToQuicklyStart =>
      'Hızlıca başlamak için program oluştur';

  @override
  String get min => 'dk';

  @override
  String get ex => 'egz';

  @override
  String get editProgram => 'Programı Düzenle';

  @override
  String get deleteProgram => 'Programı Sil';

  @override
  String get deleteProgramQuestion => 'Program Silinsin mi?';

  @override
  String areYouSureDeleteProgram(String name) {
    return '\"$name\" programını silmek istediğinizden emin misiniz?';
  }

  @override
  String get logged => 'kaydedildi';

  @override
  String get kg => 'kg';

  @override
  String editSetNumber(int number) {
    return 'Set $number Düzenle';
  }

  @override
  String weightWithUnit(String unit) {
    return 'Ağırlık ($unit)';
  }

  @override
  String get exerciseNotFound => 'Egzersiz bulunamadı';

  @override
  String get exitWorkout => 'Antrenman Çıkış?';

  @override
  String get progressNotSaved => 'İlerlemeniz kaydedilmeyecek.';

  @override
  String get exit => 'Çıkış';

  @override
  String get finish => 'Bitir';

  @override
  String exerciseProgress(int current, int total) {
    return 'Egzersiz $current/$total';
  }

  @override
  String percentComplete(int percent) {
    return '%$percent Tamamlandı';
  }

  @override
  String get restTime => 'Dinlenme Süresi';

  @override
  String get skip => 'Atla';

  @override
  String get repsLowercase => 'tekrar';

  @override
  String get kgUnit => 'kg';

  @override
  String get workoutNotComplete => 'Antrenman Tamamlanmadı';

  @override
  String get workoutNotCompleteMessage =>
      'Tüm setleri bitirmediniz. İlerlemenizi kaydetmek ve yine de bitirmek ister misiniz?';

  @override
  String get finishAnyway => 'Yine de Bitir';

  @override
  String get previous => 'Önceki';

  @override
  String get next => 'Sonraki';

  @override
  String get workoutCompleted => 'Antrenman Tamamlandı!';

  @override
  String get enableStepTracking => 'Adım Takibini Etkinleştir';

  @override
  String get stepPermissionMessage =>
      'Arka planda adımlarınızı saymak için aktivite tanıma iznine ihtiyacımız var.';

  @override
  String get later => 'Sonra';

  @override
  String get allow => 'İzin Ver';

  @override
  String get stepTrackingEnabled => '✅ Adım takibi etkinleştirildi!';

  @override
  String get permissionDenied => '⚠️ İzin reddedildi';

  @override
  String get profile => 'Profil';

  @override
  String get yourProfile => 'Profiliniz';

  @override
  String get support => 'Destek';

  @override
  String get legal => 'Yasal';

  @override
  String get healthClosestAlly => 'Sağlığınızın en yakın dostu.';

  @override
  String get openingWebsite => 'Web sitesi açılıyor...';

  @override
  String get visitWebsite => 'Web Sitesini Ziyaret Et';

  @override
  String get licensedApache => 'Apache License 2.0 altında lisanslanmıştır';

  @override
  String get licensedApache2 => 'Apache 2.0 altında lisanslanmıştır';

  @override
  String get copyright => '© 2025 Vertex Corporation';

  @override
  String get readPolicies => 'Politikalarımızı ve koşullarımızı okuyun';

  @override
  String get openingPrivacyPolicy => 'Gizlilik Politikası açılıyor...';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get openingTerms => 'Hizmet Şartları açılıyor...';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get editWaterGoal => 'Su Hedefini Düzenle';

  @override
  String get glasses => 'bardak';

  @override
  String get editCalorieGoal => 'Kalori Hedefini Düzenle';

  @override
  String get kcal => 'kkal';

  @override
  String get goalWeight => 'Hedef Kilo';

  @override
  String get editHeight => 'Boyunu Düzenle';

  @override
  String get height => 'Boy';

  @override
  String get cm => 'cm';

  @override
  String get feet => 'Fit';

  @override
  String get inches => 'İnç';

  @override
  String get bodyMassIndex => 'Vücut Kitle İndeksi (VKİ)';

  @override
  String get notCalculated => 'Hesaplanmadı';

  @override
  String get addHeightWeight => 'Boy ve kilo ekle';

  @override
  String get noAchievementsYet => 'Henüz Başarı Yok';

  @override
  String get startTrackingForAchievements =>
      'Başarıların kilidini açmak için sağlığınızı takip etmeye başlayın!';

  @override
  String get authFailed =>
      'Kimlik doğrulama başarısız oldu. Giriş yapmadan devam ediliyor.';

  @override
  String get firebaseNotConfigured =>
      'Firebase yapılandırılmamış. Anonim giriş kullanın.';

  @override
  String get googleSignInFailed =>
      'Google ile giriş başarısız oldu. Bunun yerine anonim giriş kullanın.';

  @override
  String emailSignInFailed(String error) {
    return 'E-posta ile giriş başarısız oldu: $error';
  }

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get chooseSignInMethod => 'Giriş yönteminizi seçin';

  @override
  String get continueWithGoogle => 'Google ile Devam Et';

  @override
  String get continueWithEmail => 'E-posta ile Devam Et';

  @override
  String get continueAsAnonymous => 'Anonim Olarak Devam Et';

  @override
  String get dontHaveAccount => 'Hesabınız yok mu? ';

  @override
  String get signUp => 'Kaydol';

  @override
  String get legalAgreement =>
      'Giriş yaparak/kaydolarak Gizlilik Politikamızı ve Hizmet Şartlarımızı kabul etmiş olursunuz';

  @override
  String get signInWithEmail => 'E-posta ile giriş yap';

  @override
  String get enterEmailAddress => 'E-posta adresinizi girin';

  @override
  String get email => 'E-posta';

  @override
  String get enterPassword => 'Şifrenizi girin';

  @override
  String get password => 'Şifre';

  @override
  String get firebaseNotConfiguredSignup =>
      'Firebase yapılandırılmamış. Kayıt olmadan devam ediliyor.';

  @override
  String signUpFailed(String error) {
    return 'Kayıt başarısız oldu: $error';
  }

  @override
  String get chooseUsername => 'Kullanıcı adınızı seçin';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get createPassword => 'Bir şifre oluşturun';

  @override
  String get back => 'Geri';

  @override
  String get startJourney => 'Yolculuğa Başla';

  @override
  String get continueAlly => 'Devam Et';

  @override
  String get chooseUnits => 'Birimlerinizi seçin';

  @override
  String get selectSystemPrefer => 'Tercih ettiğiniz sistemi seçin';

  @override
  String get kgCm => 'kg, cm';

  @override
  String get lbsIn => 'lbs, in';

  @override
  String get whatsYourWeight => 'Kilonuz nedir?';

  @override
  String get personalizeJourney =>
      'Yolculuğunuzu kişiselleştirmemize yardımcı olun';

  @override
  String get whatsYourHeight => 'Boyunuz nedir?';

  @override
  String get calculateIdealMetrics => 'İdeal metriklerinizi hesaplayacağız';

  @override
  String get whatsYourAge => 'Yaşınız kaç?';

  @override
  String get createPerfectPlan => 'Mükemmel sağlık planınızı oluşturalım';

  @override
  String get years => 'yıl';

  @override
  String get dailyStepGoal => 'Günlük adım hedefi';

  @override
  String weightPercent(int weight) {
    return '%$weight ağırlık';
  }

  @override
  String get ally => 'Ally';

  @override
  String get yourHealths => 'Sağlığınızın\n';

  @override
  String get closest => 'en yakın ';

  @override
  String get getStarted => 'Başla';

  @override
  String get service => 'Servis';

  @override
  String get automaticSleepTracking => 'Otomatik Uyku Takibi';

  @override
  String get noSmartwatchNeeded =>
      'Akıllı saat gerekmez! Uykunuzu otomatik olarak takip edin.';

  @override
  String get whenDoYouSleep => 'Genellikle ne zaman uyursunuz?';

  @override
  String get sleepTime => 'Uyku Saati';

  @override
  String get wakeTime => 'Uyanma Saati';

  @override
  String get sleepTrackingTitle => 'Uyku Takibi';

  @override
  String get automaticTrackingEnabled => 'Otomatik takip etkin';

  @override
  String get startTracking => 'Takibi Başlat';

  @override
  String get sleepSegments => 'Uyku Bölümleri';

  @override
  String get sleepCycles => 'Uyku Döngüleri';

  @override
  String get wakeUps => 'Uyanmalar';

  @override
  String get noSleepDataYet => 'Henüz uyku verisi yok';

  @override
  String get sleepTrackingStartTonight => 'Uyku takibi bu gece başlayacak';

  @override
  String get currentlySleeping => 'Şu Anda Uyuyor';

  @override
  String sleepSegmentNumber(int number) {
    return 'Uyku Bölümü $number';
  }

  @override
  String get setWaterGoal => 'Su Hedefinizi Belirleyin';

  @override
  String get howMuchWater => 'Günlük ne kadar su içmek istiyorsunuz?';

  @override
  String get goalUpdated => 'Hedef Güncellendi';

  @override
  String get editGoal => 'Hedefi Düzenle';

  @override
  String get quickAdd => 'Hızlı Ekle';

  @override
  String get updateWeight => 'Kiloyu Güncelle';

  @override
  String enterWeight(String unit) {
    return 'Kilo girin ($unit)';
  }

  @override
  String get weightHistory => 'Kilo Geçmişi';

  @override
  String get startTrackingWeight => 'Kilo ilerlemenizi takip etmeye başlayın';

  @override
  String get setCalorieGoal => 'Kalori Hedefinizi Belirleyin';

  @override
  String get howManyCalories => 'Günlük kaç kalori tüketmek istiyorsun?';

  @override
  String get goalSet => 'Hedef Belirlendi';

  @override
  String calorieGoalSet(int calories) {
    return 'Günlük kalori hedefiniz artık $calories kkal';
  }

  @override
  String get addFriend => 'Arkadaş Ekle';

  @override
  String get welcomeText1 => 'Sağlığınızın';

  @override
  String get welcomeText2 => 'en yakın';

  @override
  String get welcomeText3 => 'dostu';

  @override
  String get serviceControls => 'Servis Kontrolleri';

  @override
  String get startService => 'Servisi Başlat';

  @override
  String get restartService => 'Servisi Yeniden Başlat';

  @override
  String get stopService => 'Servisi Durdur';

  @override
  String get setYourGoal => 'Hedefini Belirle';

  @override
  String get howManySteps => 'Bugün kaç adım hedeflemek istiyorsun?';

  @override
  String get serviceStarted => 'Servis Başlatıldı';

  @override
  String get serviceStartedDesc => 'Adım sayacı servisi şimdi çalışıyor';

  @override
  String get serviceRestarted => 'Servis Yeniden Başlatıldı';

  @override
  String get serviceRestartedDesc => 'Adım sayacı servisi yeniden başlatıldı';

  @override
  String get serviceStopped => 'Servis Durduruldu';

  @override
  String get serviceStoppedDesc => 'Adım sayacı servisi durduruldu';

  @override
  String dailyGoalSet(Object goal) {
    return 'Günlük hedefiniz şimdi $goal adım';
  }

  @override
  String get stepsLabel => 'adım';

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
  String get programNameHint => 'Program adı (örn. Push Day)';

  @override
  String get usernameHint => 'Kullanıcı Adı';

  @override
  String get emailHint => 'E-posta';

  @override
  String get passwordHint => 'Şifre';

  @override
  String get dailyCalorieHint => '2000';

  @override
  String get usernameAtHint => '@kullaniciadi';

  @override
  String programUpdated(String name) {
    return 'Program \"$name\" güncellendi!';
  }

  @override
  String programSaved(String name) {
    return 'Program \"$name\" kaydedildi!';
  }

  @override
  String valueOfTarget(String value, String target) {
    return '$value / $target';
  }

  @override
  String valueSlashTarget(String value, String target) {
    return '$value/$target';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}s ${minutes}d';
  }

  @override
  String ofValueUnit(String value, String unit) {
    return '$value$unit\'den';
  }

  @override
  String bmiValue(String value) {
    return 'VKİ: $value';
  }

  @override
  String gramsAmount(String grams) {
    return '~${grams}g';
  }

  @override
  String caloriesAmount(String calories) {
    return '~$calories kal';
  }

  @override
  String caloriesPer100g(String calories) {
    return '($calories/100g)';
  }

  @override
  String get licensedApache2Short => 'Apache 2.0 altında lisanslanmıştır';

  @override
  String get waterGoalLabel => 'Su Hedefi';

  @override
  String get calorieGoalLabel => 'Kalori Hedefi';

  @override
  String get enterWeightLbs => 'Kilo girin (lbs)';

  @override
  String get enterWeightKg => 'Kilo girin (kg)';

  @override
  String bmiLabel(String value) {
    return 'VKİ: $value';
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
  String get bpmUnit => 'Nabız';

  @override
  String ofHoursGoal(String hours) {
    return '${hours}s\'den';
  }

  @override
  String get nowLabel => 'Şimdi';

  @override
  String dailyGoalSetTo(String value, String unit) {
    return 'Günlük hedef $value$unit olarak ayarlandı';
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
      'Aktivitelerini takip etmek için arkadaşınızın kullanıcı adını girin';

  @override
  String get sendRequest => 'İstek Gönder';

  @override
  String subscribeToPlan(String title) {
    return '$title planına abone ol';
  }

  @override
  String restSeconds(int seconds) {
    return '${seconds}sn';
  }

  @override
  String get setYourCalorieGoal => 'Kalori Hedefini Belirle';

  @override
  String get workoutBuilder => 'Antrenman Oluşturucu';

  @override
  String get whenDoYouUsuallySleep => 'Genellikle ne zaman uyursunuz?';

  @override
  String get sleepTrackingWillStartTonight => 'Uyku takibi bu gece başlayacak';
}
