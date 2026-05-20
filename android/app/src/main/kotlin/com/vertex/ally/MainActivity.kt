package com.vertex.ally

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.vertex.ally/step_counter"
    private val ACTIVITY_RECOGNITION_REQUEST = 100

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startStepCounterService" -> {
                    // Android Q (API 29) ve üzeri için izin kontrolü
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACTIVITY_RECOGNITION)
                            != PackageManager.PERMISSION_GRANTED) {
                            // İzin yoksa Flutter'a hata dön
                            result.error("PERMISSION_DENIED", "Activity recognition permission required", null)
                            return@setMethodCallHandler
                        }
                    }
                    
                    val intent = Intent(this, StepCounterService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "stopStepCounterService" -> {
                    val intent = Intent(this, StepCounterService::class.java)
                    stopService(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
