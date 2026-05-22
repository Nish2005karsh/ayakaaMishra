plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.android.libraries.mapsplatform.secrets-gradle-plugin")
}

android {
    namespace = "com.example.ayakaa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.ayakaa"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Forces Navigation SDK to use the GMS Cronet provider instead of the
        // fallback JavaCronetEngine (which can't authenticate → Nav SDK error 4).
        manifestPlaceholders["cronetProviderPackage"] = "com.google.android.gms"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs_nio:2.0.4")
    implementation("com.google.android.libraries.mapsplatform.transportation:transportation-driver:6.0.0")
    implementation("com.google.android.libraries.navigation:navigation:5.0.0")
    // KEY FIX: GMS Cronet provider. Without this, Navigation SDK falls back
    // to JavaCronetEngine which cannot authenticate → "Navigation SDK error: 4".
    // (Confirmed by the client's reference app having the same fix.)
    implementation("com.google.android.gms:play-services-cronet:18.1.0")
}

flutter {
    source = "../.."
}
