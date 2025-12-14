package com.vertex.ally

import android.Manifest
import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import java.text.SimpleDateFormat
import java.util.*

class StepCounterService : Service(), SensorEventListener {
    
    private lateinit var sensorManager: SensorManager
    private var stepCounterSensor: Sensor? = null
    private var stepDetectorSensor: Sensor? = null
    
    private var initialSteps = -1
    private var currentSteps = 0
    private val PREFS_NAME = "FlutterSharedPreferences"
    private val PREFS_KEY_PREFIX = "flutter."
    private val CHANNEL_ID = "step_counter_channel"
    private val NOTIFICATION_ID = 1
    
    override fun onCreate() {
        super.onCreate()
        
        android.util.Log.d("StepService", "🚀 Service onCreate called")
        
        // Önce izin kontrolü
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACTIVITY_RECOGNITION)
                != PackageManager.PERMISSION_GRANTED) {
                android.util.Log.e("StepService", "❌ ACTIVITY_RECOGNITION permission not granted!")
                stopSelf()
                return
            }
        }
        
        // Sensor Manager'ı başlat
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        
        // Step Counter sensörü (API 19+)
        stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        
        // Step Detector sensörü (alternatif)
        stepDetectorSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR)
        
        android.util.Log.d("StepService", "Step Counter available: ${stepCounterSensor != null}")
        android.util.Log.d("StepService", "Step Detector available: ${stepDetectorSensor != null}")
        
        // Sensör detayları
        stepCounterSensor?.let {
            android.util.Log.d("StepService", "Step Counter name: ${it.name}, vendor: ${it.vendor}, power: ${it.power}mA")
        }
        stepDetectorSensor?.let {
            android.util.Log.d("StepService", "Step Detector name: ${it.name}, vendor: ${it.vendor}, power: ${it.power}mA")
        }
        
        // Sensörleri dinlemeye başla
        var anyRegistered = false
        
        stepCounterSensor?.let {
            val registered = sensorManager.registerListener(
                this, 
                it, 
                SensorManager.SENSOR_DELAY_UI
            )
            android.util.Log.d("StepService", "Step Counter registered: $registered")
            anyRegistered = anyRegistered || registered
        }
        
        stepDetectorSensor?.let {
            val registered = sensorManager.registerListener(
                this, 
                it, 
                SensorManager.SENSOR_DELAY_UI
            )
            android.util.Log.d("StepService", "Step Detector registered: $registered")
            anyRegistered = anyRegistered || registered
        }
        
        if (!anyRegistered) {
            if (stepCounterSensor == null && stepDetectorSensor == null) {
                android.util.Log.e("StepService", "❌ NO STEP SENSORS AVAILABLE ON THIS DEVICE!")
            } else {
                android.util.Log.e("StepService", "❌ SENSORS AVAILABLE BUT REGISTRATION FAILED!")
                // Tekrar dene
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    stepCounterSensor?.let { sensor ->
                        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI)
                    }
                    stepDetectorSensor?.let { sensor ->
                        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI)
                    }
                }, 1000)
            }
        }
        
        // Foreground service olarak başlat (bildirimle)
        startForeground(NOTIFICATION_ID, createNotification())
        android.util.Log.d("StepService", "✅ Foreground service started")
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Service yeniden başlatılırsa devam etsin
        return START_STICKY
    }
    
    override fun onBind(intent: Intent?): IBinder? = null
    
    override fun onSensorChanged(event: SensorEvent?) {
        android.util.Log.d("StepService", "🔔 onSensorChanged CALLED!")
        
        event?.let {
            android.util.Log.d("StepService", "📊 Sensor event received: ${it.sensor.name}, type: ${it.sensor.type}")
            android.util.Log.d("StepService", "📊 Event values: ${it.values.joinToString()}")
            
            when (it.sensor.type) {
                Sensor.TYPE_STEP_COUNTER -> {
                    // Cihaz açıldığından beri toplam adım
                    val totalSteps = it.values[0].toInt()
                    android.util.Log.d("StepService", "🚶 Step Counter value: $totalSteps")
                    
                    // İlk değer
                    if (initialSteps == -1) {
                        initialSteps = totalSteps
                        loadTodaySteps()
                        android.util.Log.d("StepService", "Initial steps: $initialSteps, Today: $currentSteps")
                    }
                    
                    // Bugünkü adımlar
                    val todaySteps = totalSteps - initialSteps + currentSteps
                    saveTodaySteps(todaySteps)
                    android.util.Log.d("StepService", "✅ Today total: $todaySteps (total: $totalSteps, initial: $initialSteps, current: $currentSteps)")
                    
                    // Bildirimi güncelle
                    updateNotification(todaySteps)
                }
                
                Sensor.TYPE_STEP_DETECTOR -> {
                    // Her adımda tetiklenir
                    currentSteps++
                    saveTodaySteps(currentSteps)
                    android.util.Log.d("StepService", "👣 STEP DETECTED! Total: $currentSteps")
                    updateNotification(currentSteps)
                }
                
                else -> {
                    android.util.Log.d("StepService", "⚠️ Unknown sensor type: ${it.sensor.type}")
                }
            }
        } ?: run {
            android.util.Log.e("StepService", "❌ Event is NULL!")
        }
    }
    
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Sensör hassasiyeti değişirse
    }
    
    private fun loadTodaySteps() {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val today = getTodayDate()
        val key = "${PREFS_KEY_PREFIX}steps_$today"
        currentSteps = prefs.getInt(key, 0)
        android.util.Log.d("StepService", "📂 Loaded from SharedPrefs: $key = $currentSteps")
    }
    
    private fun saveTodaySteps(steps: Int) {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val today = getTodayDate()
        val key = "${PREFS_KEY_PREFIX}steps_$today"
        prefs.edit().putInt(key, steps).apply()
        android.util.Log.d("StepService", "💾 Saved to SharedPrefs: $key = $steps")
    }
    
    private fun getTodayDate(): String {
        val dateFormat = SimpleDateFormat("d/M/yyyy", Locale.getDefault())
        return dateFormat.format(Date())
    }
    
    private fun createNotification(): Notification {
        createNotificationChannel()
        
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Ally - Step Counter Active")
            .setContentText("Tracking your steps...")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }
    
    private fun updateNotification(steps: Int) {
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Ally - $steps steps today")
            .setContentText("Keep moving!")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .setOngoing(true)
            .build()
        
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID, notification)
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Step Counter Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Background step counting"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        sensorManager.unregisterListener(this)
    }
}
