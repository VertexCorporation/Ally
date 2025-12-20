import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../providers/health.dart';
import '../l10n/app_localizations.dart';
import '../widgets/dialogs.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({super.key});

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    
    // Load initial steps directly
    _loadInitialSteps();
    
    // Read steps every 2 seconds from SharedPreferences
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await _loadStepsFromPrefs();
    });
  }
  
  Future<void> _loadInitialSteps() async {
    await _loadStepsFromPrefs();
  }
  
  Future<void> _loadStepsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = '${now.day}/${now.month}/${now.year}';
    final steps = prefs.getInt('steps_$today') ?? 0;
    
    if (mounted) {
      final healthProvider = Provider.of<HealthProvider>(context, listen: false);
      healthProvider.updateStepsFromSensor(steps);
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final healthProvider = Provider.of<HealthProvider>(context);
    final healthData = healthProvider.healthData;
    final l10n = AppLocalizations.of(context)!;
    
    final progress = (healthData.currentSteps / healthData.stepsGoal).clamp(0.0, 1.0);

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded, color: Theme.of(context).iconTheme.color, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(l10n.pedometer, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Steps Card
                Hero(
                  tag: 'pedometer_card',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4BAADF),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: const Color(0xFF4BAADF).withValues(alpha:0.3), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${healthData.currentSteps}',
                                style: const TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '/ ${healthData.stepsGoal}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Colors.white70,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              '${(progress * 100).toInt()}% ${l10n.completed}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Quick Actions
                Text(
                  l10n.quickActions,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        l10n.service,
                        Icons.settings_suggest_rounded,
                        const Color(0xFF4BAADF),
                        () {
                          CustomDialogs.showServiceControlDialog(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        l10n.setGoal,
                        Icons.flag_rounded,
                        const Color(0xFF06FFA5),
                        () {
                          CustomDialogs.showSetGoalDialog(
                            context,
                            healthProvider.healthData.stepsGoal,
                            (goal) {
                              healthProvider.updateStepsGoal(goal);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
