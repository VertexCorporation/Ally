# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter embedding v2
-keep class io.flutter.embedding.** { *; }

# Flutter plugin registry
-keep class androidx.lifecycle.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Firebase Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

# Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }

# Google Sign-In
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.tasks.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# AndroidX
-keep class androidx.** { *; }
-dontwarn androidx.**

# Foreground Task (flutter_foreground_task)
-keep class com.pravera.flutter_foreground_task.** { *; }

# Secure Storage (flutter_secure_storage)
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Internet Connection Checker
-keep class com.datachef.internet_connection_checker_plus.** { *; }

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# WebView
-keep class androidx.webkit.** { *; }

# Play Install Referrer
-keep class com.android.installreferrer.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Prevent stripping of serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Suppress warnings for missing classes that are intentionally optional
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
