package com.thetronforge.maxai.wake.session

import android.content.Context
import com.thetronforge.maxai.wake.audio.AudioCaptureManager
import com.thetronforge.maxai.wake.audio.AudioFocusManager
import com.thetronforge.maxai.wake.config.WakeConfiguration
import com.thetronforge.maxai.wake.events.EventDispatcher
import com.thetronforge.maxai.wake.ml.HybridDetectionResult
import com.thetronforge.maxai.wake.ml.HybridWakeDetector
import com.thetronforge.maxai.wake.optimization.BatteryOptimizer
import com.thetronforge.maxai.wake.util.Logger
import com.thetronforge.maxai.wake.util.WakeEngineConstants
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.isActive
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlin.math.log10
import kotlin.math.sqrt

/** Controls the native MAX wake-word pipeline from microphone to TFLite. */
class WakeSessionManagerV2(
    private val context: Context,
    private val configuration: WakeConfiguration,
    private val eventDispatcher: EventDispatcher,
    private val audioFocusManager: AudioFocusManager,
    private val batteryOptimizer: BatteryOptimizer,
    private val logger: Logger,
) {
    private var listening = false
    private var currentMode = WakeEngineConstants.ListeningMode.FOREGROUND
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var audioCaptureManager: AudioCaptureManager? = null
    private val hybridDetector = HybridWakeDetector(
        context = context,
        vadThreshold = configuration.getVadThreshold(),
        wakeThreshold = configuration.getWakeThreshold(),
        modelPath = "flutter_assets/models/hey_max_model.tflite",
    )
    private var lastWakeTime = 0L
    private val wakeCooldown = 1000L

    fun startListening(mode: WakeEngineConstants.ListeningMode) {
        if (listening) {
            logger.info("Already listening")
            return
        }

        try {
            currentMode = mode
            if (batteryOptimizer.shouldPauseDueToBattery()) {
                eventDispatcher.publishError("Battery too low", "BATTERY_LOW")
                return
            }
            if (!hybridDetector.initialize()) {
                eventDispatcher.publishError("Wake detector failed", "TFLITE_FAILED")
                return
            }
            if (!audioFocusManager.requestFocus(duckOthers = true)) {
                eventDispatcher.publishError("Audio focus failed", "AUDIO_FOCUS_FAILED")
                hybridDetector.release()
                return
            }

            audioCaptureManager = AudioCaptureManager(
                context = context,
                onFrameCallback = ::processFrame,
                onErrorCallback = ::handleAudioError,
            )
            audioCaptureManager?.initialize()
            audioCaptureManager?.startCapture(scope)
            listening = true
            eventDispatcher.publishListeningStarted(mode.name)
            logger.info("MAX Wake Engine started")
        } catch (e: Exception) {
            listening = false
            audioCaptureManager?.release()
            audioCaptureManager = null
            hybridDetector.release()
            audioFocusManager.abandonFocus()
            eventDispatcher.publishError(e.message ?: "Failed to start wake engine", "START_FAILED", e)
            logger.error("Failed starting wake engine", e)
        }
    }

    fun stopListening() {
        try {
            listening = false
            audioCaptureManager?.stopCapture()
            audioCaptureManager?.release()
            audioCaptureManager = null
            hybridDetector.release()
            hybridDetector.reset()
            audioFocusManager.abandonFocus()
            eventDispatcher.publishListeningStopped("user")
        } catch (e: Exception) {
            logger.error("Stop failed", e)
        }
    }

    private fun processFrame(frame: ByteArray) {
        if (!listening) return
        try {
            val result = hybridDetector.detectWakeWord(frame)
            val level = estimateLevel(frame)
            eventDispatcher.publishAudioLevel(
                db = level.db,
                normalized = level.normalized,
                isVoice = result.message != "No speech detected",
            )
            if (result.isWake) handleWake(result)
        } catch (e: Exception) {
            logger.error("Frame processing failed", e)
        }
    }

    private fun handleWake(result: HybridDetectionResult) {
        val now = System.currentTimeMillis()
        if (now - lastWakeTime < wakeCooldown) return
        lastWakeTime = now
        logger.info("HEY MAX DETECTED ${result.nnConfidence}")
        eventDispatcher.publishWakeDetected("Hey MAX", result.nnConfidence)
    }

    private fun estimateLevel(frame: ByteArray): AudioLevel {
        if (frame.size < 2) return AudioLevel(-60f, 0f)
        var sum = 0.0
        var samples = 0
        for (i in 0 until frame.size - 1 step 2) {
            val low = frame[i].toInt() and 0xff
            val high = frame[i + 1].toInt()
            val sample = ((high shl 8) or low).toShort().toInt()
            sum += sample.toDouble() * sample.toDouble()
            samples++
        }
        if (samples == 0) return AudioLevel(-60f, 0f)
        val rms = sqrt(sum / samples)
        val db = if (rms <= 0.0) -60f else (20.0 * log10(rms / 32768.0)).toFloat().coerceIn(-60f, 0f)
        return AudioLevel(db, ((db + 60f) / 60f).coerceIn(0f, 1f))
    }

    private fun handleAudioError(message: String, error: Exception) {
        logger.error(message, error)
        eventDispatcher.publishError(message, "AUDIO_ERROR", error)
    }

    fun isActive(): Boolean = listening

    fun cleanup() {
        stopListening()
        scope.cancel()
    }
}

data class AudioLevel(val db: Float, val normalized: Float)
