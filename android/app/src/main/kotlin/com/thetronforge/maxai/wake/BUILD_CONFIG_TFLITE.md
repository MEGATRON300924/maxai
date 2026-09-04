# File: android/app/build.gradle
# Updated with TensorFlow Lite dependencies

# Add these inside the dependencies { } block:

# ==================== KOTLIN & COROUTINES ====================
implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.0"
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.1"
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.1"

# ==================== ANDROID ====================
implementation "androidx.core:core:1.10.0"
implementation "androidx.appcompat:appcompat:1.6.0"
implementation "androidx.localbroadcastmanager:localbroadcastmanager:1.1.0"

# ==================== TENSORFLOW LITE (CORE - REQUIRED) ====================
# TensorFlow Lite runtime for inference
implementation "org.tensorflow:tensorflow-lite:2.12.0"

# TensorFlow Lite GPU Delegate (optional, for faster inference)
# implementation "org.tensorflow:tensorflow-lite-gpu:2.12.0"

# TensorFlow Lite NNAPI Delegate (optional, for hardware acceleration)
# implementation "org.tensorflow:tensorflow-lite-nnapi:2.12.0"

# TensorFlow Lite Support Library (optional, for preprocessing)
# implementation "org.tensorflow:tensorflow-lite-support:0.4.3"

# ==================== OPTIONAL: GOOGLE CLOUD STT (IF NEEDED) ====================
# If using Google Cloud Speech-to-Text as fallback
# implementation "com.google.cloud:google-cloud-speech:2.3.0"

# ==================== BUILD CONFIG ====================
# Add these inside android { } block:

android {
    compileSdk 34
    
    defaultConfig {
        minSdk 24           # Android 7.0+
        targetSdk 34
        
        // Enable multiDex if needed
        multiDexEnabled true
    }
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = '17'
    }
    
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        
        debug {
            minifyEnabled false
        }
    }
    
    # For TensorFlow Lite, reduce build output
    packagingOptions {
        exclude 'META-INF/proguard/androidx-*.pro'
    }
}

# ==================== GRADLE PROPERTIES ====================
# File: android/gradle.properties

# Enable AndroidX
android.useAndroidX=true
android.enableJetifier=true

# Kotlin
kotlin.code.style=official

# Performance
android.enableAapt2=true
android.enableR8=true
org.gradle.jvmargs=-Xmx2048m

# Enable incremental compilation
kotlin.incremental=true

# ==================== KEY NOTES ====================

# 1. TensorFlow Lite is lightweight (~3.5MB base library)
# 2. Models (.tflite files) stored in assets/ directory
# 3. No internet required - fully on-device
# 4. Supports CPU, GPU, and NNAPI acceleration
# 5. Compatible with Android API 24+ (Android 7.0)

# ==================== ANDROID MANIFEST UPDATES ====================
# Add to AndroidManifest.xml if using GPU/NNAPI:

# For GPU acceleration (optional):
# <uses-feature android:name="android.hardware.vulkan.version" android:required="false" />

# For NNAPI (optional):
# <!-- Already covered by standard runtime permissions -->

# ==================== GRADLE BUILD COMMAND ====================

# Build APK:
# ./gradlew assembleDebug

# Build Release:
# ./gradlew assembleRelease

# Build App Bundle (for Play Store):
# ./gradlew bundleRelease

# ==================== MODEL PLACEMENT ====================

# Place your .tflite model file here:
# android/app/src/main/assets/wake_model.tflite

# If assets folder doesn't exist:
# mkdir -p android/app/src/main/assets
# cp your_trained_model.tflite android/app/src/main/assets/wake_model.tflite
