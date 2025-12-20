import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class PedometerService {
  static final PedometerService _instance = PedometerService._internal();
  factory PedometerService() => _instance;
  PedometerService._internal();
  
  static const platform = MethodChannel('com.vertex.ally/step_counter');
  
  Future<void> startNativeService() async {
    try {
      final status = await Permission.activityRecognition.request();

      if (status.isGranted) {
        await platform.invokeMethod('startStepCounterService');
        debugPrint('✅ Native step counter service started');
      } else {
        debugPrint('❌ Activity recognition permission denied');
      }
    } catch (e) {
      debugPrint('Error starting native service: $e');
    }
  }
  
  Future<void> stopNativeService() async {
    try {
      await platform.invokeMethod('stopStepCounterService');
      debugPrint('Native step counter service stopped');
    } catch (e) {
      debugPrint('Error stopping native service: $e');
    }
  }

  Future<int> getStepsForDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('steps_$date') ?? 0;
  }
}
