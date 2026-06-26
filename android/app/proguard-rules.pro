# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Play Integrity (App Check) — 사용함, keep
-keep class com.google.android.play.core.integrity.** { *; }

# Play Core (Flutter deferred-components/split-install 참조) — 앱 미사용 → R8 누락 클래스 경고 무시
-dontwarn com.google.android.play.core.**

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
