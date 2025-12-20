import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health.dart';
import '../l10n/app_localizations.dart';

class HealthScoreScreen extends StatefulWidget {
  const HealthScoreScreen({super.key});

  @override
  State<HealthScoreScreen> createState() => _HealthScoreScreenState();
}

class _HealthScoreScreenState extends State<HealthScoreScreen> {

  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final healthScore = healthData.healthScore;

    // Calculate individual scores based on real data
    final waterScore = ((healthData.waterGlasses / healthData.waterGoal) * 25).clamp(0, 25);
    final exerciseScore = ((healthData.exerciseStreak / 7) * 25).clamp(0, 25);
    final sleepScore = ((healthData.sleepHours / healthData.sleepGoal) * 25).clamp(0, 25);
    final stepsScore = healthData.stepsGoal > 0
        ? ((healthData.currentSteps / healthData.stepsGoal) * 25).clamp(0, 25)
        : 0.0;

    final List<Map<String, dynamic>> scoreBreakdown = [
      {
        'name': AppLocalizations.of(context)!.exercises,
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFFFF6B6B),
        'weight': 25,
        'currentScore': exerciseScore.round(),
        'description': AppLocalizations.of(context)!.workoutStreakDesc,
      },
      {
        'name': AppLocalizations.of(context)!.sleep,
        'icon': Icons.bedtime_rounded,
        'color': const Color(0xFF9D50BB),
        'weight': 25,
        'currentScore': sleepScore.round(),
        'description': AppLocalizations.of(context)!.sleepQualityDesc,
      },
      {
        'name': AppLocalizations.of(context)!.water,
        'icon': Icons.water_drop_rounded,
        'color': const Color(0xFF64B5F6),
        'weight': 25,
        'currentScore': waterScore.round(),
        'description': AppLocalizations.of(context)!.hydrationGoalDesc,
      },
      {
        'name': AppLocalizations.of(context)!.steps,
        'icon': Icons.directions_walk_rounded,
        'color': const Color(0xFF81C784),
        'weight': 25,
        'currentScore': stepsScore.round(),
        'description': AppLocalizations.of(context)!.dailyStepGoal,
      },
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: Theme.of(context).iconTheme.color, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.healthScore, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Score Card
              Hero(
                tag: 'health_score_card',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF64B5F6).withValues(alpha:0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.yourHealthScore,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: healthScore / 100,
                                strokeWidth: 16,
                                backgroundColor: Colors.white70,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$healthScore',
                                  style: const TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.outOf100,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.scoreBreakdown,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 16),
              ...scoreBreakdown.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withValues(alpha:0.3) : Colors.black.withValues(alpha:0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: item['color'].withValues(alpha:0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item['icon'],
                            color: item['color'],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.scoreSlashWeight(item['currentScore'].toString(), item['weight'].toString()),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: item['color'],
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.weightPercent(item['weight']),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: item['currentScore'] / item['weight'],
                        minHeight: 8,
                        backgroundColor: item['color'].withValues(alpha:0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(item['color']),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
