package com.thetronforge.maxai.wake.ml

import android.content.Context
import com.thetronforge.maxai.wake.audio.VoiceActivityDetector
import com.thetronforge.maxai.wake.util.Logger

/**
 * Hybrid wake-word detector: VAD filters silence before the TFLite model runs.
 */
class HybridWakeDetector(
    private val context: Context,
    private val vadThreshold: Float = 0.5f,
    private var wakeThreshold: Float = 0.75f,
    private val modelPath: String = "flutter_assets/models/hey_max_model.tflite"
) {
    private val logger = Logger("HybridDetector")
    private val vad = VoiceActivityDetector()
    private val tfliteDetector = WakeWordTFLiteDetector(
        context = context,
        modelPath = modelPath,
        threshold = wakeThreshold,
    )

    private var initialized = false
    private var vadFrames = 0
    private var nnFrames = 0

    fun initialize(): Boolean = try {
        logger.info("Initializing Hybrid Wake Detector")
        vad.setThreshold(vadThreshold)
        initialized = tfliteDetector.initialize()
        logger.info("Hybrid detector ready: $initialized")
        initialized
    } catch (e: Exception) {
        logger.error("Hybrid initialization failed", e)
        false
    }

    fun detectWakeWord(audioFrame: ByteArray): HybridDetectionResult {
        if (!initialized) return HybridDetectionResult.error("Detector not initialized")

        return try {
            vadFrames++
            val voiceResult = vad.processFrame(audioFrame)
            if (!voiceResult.isVoiceDetected || voiceResult.confidence < vadThreshold) {
                return HybridDetectionResult.noSpeech(voiceResult.confidence)
            }

            nnFrames++
            val result = tfliteDetector.detectWakeWord(audioFrame)
            if (result.isWake) {
                HybridDetectionResult.wake(result.confidence, voiceResult.confidence)
            } else {
                HybridDetectionResult.notWake(result.confidence, voiceResult.confidence)
            }
        } catch (e: Exception) {
            logger.error("Detection failed", e)
            HybridDetectionResult.error(e.message ?: "Unknown error")
        }
    }

    fun reset() {
        vad.reset()
    }

    fun release() {
        try {
            tfliteDetector.release()
            initialized = false
            logger.info("Detector released")
        } catch (e: Exception) {
            logger.error("Release failed", e)
        }
    }

    fun setThresholds(vadValue: Float, wakeValue: Float) {
        require(vadValue in 0f..1f)
        require(wakeValue in 0f..1f)
        vad.setThreshold(vadValue)
        wakeThreshold = wakeValue
        tfliteDetector.setThreshold(wakeValue)
    }

    fun getStatistics(): Map<String, Any> = mapOf(
        "initialized" to initialized,
        "vadFrames" to vadFrames,
        "nnFrames" to nnFrames,
        "nnUsage" to if (vadFrames > 0) nnFrames.toFloat() / vadFrames else 0f,
        "model" to tfliteDetector.getModelInfo(),
    )
}

data class HybridDetectionResult(
    val isWake: Boolean,
    val nnConfidence: Float = 0f,
    val vadConfidence: Float = 0f,
    val stage: String = "",
    val message: String = "",
) {
    companion object {
        fun wake(confidence: Float, vadConfidence: Float) = HybridDetectionResult(
            isWake = true,
            nnConfidence = confidence,
            vadConfidence = vadConfidence,
            stage = "NN_CONFIRMED",
            message = "Wake detected",
        )

        fun notWake(confidence: Float, vadConfidence: Float) = HybridDetectionResult(
            isWake = false,
            nnConfidence = confidence,
            vadConfidence = vadConfidence,
            stage = "NN_REJECTED",
            message = "Not wake",
        )

        fun noSpeech(vadConfidence: Float) = HybridDetectionResult(
            isWake = false,
            vadConfidence = vadConfidence,
            stage = "VAD_FILTERED",
            message = "No speech detected",
        )

        fun error(message: String) = HybridDetectionResult(
            isWake = false,
            stage = "ERROR",
            message = message,
        )
    }
}
