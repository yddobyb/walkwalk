# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Play Integrity (App Check)
-keep class com.google.android.play.core.integrity.** { *; }

# Isar
-keep class dev.isar.** { *; }

# RevenueCat
-keep class com.revenuecat.** { *; }

# Gson (used by Firebase)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
