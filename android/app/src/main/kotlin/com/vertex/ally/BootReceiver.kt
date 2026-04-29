package com.vertex.ally

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Only handle actual device boot - not package replacement
        // Package replacement (flutter run / app update) is handled by Flutter on app open
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || 
            intent.action == Intent.ACTION_LOCKED_BOOT_COMPLETED) {
            
            // Check permission before starting to avoid RemoteServiceException
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                if (androidx.core.content.ContextCompat.checkSelfPermission(context, android.Manifest.permission.ACTIVITY_RECOGNITION)
                    != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                    android.util.Log.e("BootReceiver", "ACTIVITY_RECOGNITION permission not granted, not starting service")
                    return
                }
            }

            try {
                android.util.Log.d("BootReceiver", "Starting StepCounterService after boot")
                val serviceIntent = Intent(context, StepCounterService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
            } catch (e: Exception) {
                android.util.Log.e("BootReceiver", "Failed to start service: ${e.message}")
            }
        }
    }
}
