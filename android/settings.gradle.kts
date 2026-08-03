pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    // START: FlutterFire Configuration
    // 4.3.10 → 4.4.2: Crashlytics Gradle 플러그인 3이 4.4.1+ 를 요구함
    id("com.google.gms.google-services") version("4.4.2") apply false
    // Crashlytics: R8 난독화된 릴리스 스택트레이스를 읽으려면
    // 매핑 파일 업로드가 필요한데, 그걸 이 플러그인이 한다.
    id("com.google.firebase.crashlytics") version("3.0.2") apply false
    // END: FlutterFire Configuration
    // 2.1.0 → 2.3.0: google_mobile_ads 9의 play-services-ads가 Kotlin 2.3.0 메타데이터로 컴파일됨
    id("org.jetbrains.kotlin.android") version "2.3.0" apply false
}

include(":app")
