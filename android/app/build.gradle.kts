plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

configurations.all {
    resolutionStrategy {
        // Force Maven Central compatible version since maven.arthenica.com is unreachable
        eachDependency {
            if (requested.group == "com.arthenica" && requested.name == "ffmpeg-kit-full") {
                useVersion("6.0.LTS")
            }
        }
    }
}

android {
    namespace = "com.mallikarjun.video_speed_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.mallikarjun.video_speed_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
