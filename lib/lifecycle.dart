// lifecycle.dart

import 'package:ally/screen.dart';
import 'package:ally/services/sleep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Represents the general states of the application.
/// Since Ally is currently simple, it only has initializing and ready states.
enum AppStatus {
  initializing,
  ready,
}

/// Main layer managing the application lifecycle and initialization process.
/// - Listens to AppLifecycleState changes (Background/Foreground).
/// - Triggers SleepTrackerService.
/// - Manages the splash screen.
/// - Navigates to MainScreen when ready.
class AppLifecycleManager extends StatefulWidget {
  const AppLifecycleManager({super.key});

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {

  // Service instance
  final SleepTrackerService _sleepService = SleepTrackerService();

  // Initial state
  AppStatus _status = AppStatus.initializing;
  bool _splashRemoved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Trigger initialization
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handles app lifecycle changes (Logs events and triggers SleepService for Ally).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    debugPrint('AppLifecycleManager: Lifecycle changed to $state');

    switch (state) {
      case AppLifecycleState.resumed:
      // Notify that screen is on when app comes to foreground
        _sleepService.onScreenOn();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      // Consider screen off when app goes to background or is locked
        _sleepService.onScreenOff();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Asynchronous operations required during app startup.
  /// (Database checks, cache clearing, etc. can be added here).
  Future<void> _initializeApp() async {
    // Artificial delay or necessary loading can be done here.
    // Since services are already loaded in main.dart, we move quickly to ready.
    // However, a small wait (postFrame) is beneficial for UI rendering.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _status = AppStatus.ready;
        });
        _removeSplash();
      }
    });
  }

  /// Safely removes the Native Splash screen.
  void _removeSplash() {
    if (!_splashRemoved) {
      _splashRemoved = true;
      try {
        debugPrint('AppLifecycleManager: UI Ready. Removing Native Splash.');
        FlutterNativeSplash.remove();
      } catch (e) {
        // Prevent app crash if flutter_native_splash package is not installed or throws an error.
        debugPrint("Warning: Failed to remove splash screen: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _buildScreenForStatus(),
    );
  }

  /// Selects which screen to show based on status.
  Widget _buildScreenForStatus() {
    switch (_status) {
      case AppStatus.initializing:
        return const SizedBox.shrink(key: ValueKey('Initializing'));

      case AppStatus.ready:
        return const MainScreen(key: ValueKey('MainScreen'));
    }
  }
}