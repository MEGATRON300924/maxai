package com.thetronforge.maxai.wake.ml

import android.content.Context
import com.thetronforge.maxai.wake.util.Logger
import java.io.FileInputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.channels.FileChannel
import org.tensorflow.lite.Interpreter

class WakeWordTFLiteDetector(
    private val context: Context,
    private val modelPath: String = "flutter_assets/models/hey_max_model.tflite",
    private var threshold: Float = 0.75f
) {
    private val logger = Logger("TFLiteWakeDetector")
    private var interpreter: Interpreter? = null
    private val featureExtractor = AudioFeatureExtractor()

    fun initialize(): Boolean = try {
        val modelBuffer = loadModelFile(modelPath)
        interpreter = Interpreter(modelBuffer, Interpreter.Options().apply { setNumThreads(2) })
        true
    } catch (e: Exception) {
        logger.error("TFLite init failed", e)
        false
    }

    fun detectWakeWord(audioFrame: ByteArray): DetectionResult {
        val engine = interpreter ?: return DetectionResult.notWake(0f)
        return try {
            val vector = featureExtractor.extractFeatures(audioFrame).toFeatureVector()
            val input = ByteBuffer.allocateDirect(vector.size * 4).order(ByteOrder.nativeOrder())
            vector.forEach(input::putFloat)
            input.rewind()
            val output = Array(1) { FloatArray(2) }
            engine.run(input, output)
            val wake = output[0].getOrElse(1) { 0f }
            if (wake >= threshold) DetectionResult.wake(wake) else DetectionResult.notWake(wake)
        } catch (e: Exception) {
            logger.error("Inference failed", e)
            DetectionResult.error(e.message ?: "Unknown inference error")
        }
    }

    private fun loadModelFile(filename: String): ByteBuffer {
        val descriptor = context.assets.openFd(filename)
        FileInputStream(descriptor.fileDescriptor).use { stream ->
            return stream.channel.map(
                FileChannel.MapMode.READ_ONLY,
                descriptor.startOffset,
                descriptor.declaredLength
            )
        }
    }

    fun setThreshold(value: Float) {
        threshold = value.coerceIn(0f, 1f)
    }

    fun release() {
        interpreter?.close()
        interpreter = null
    }

    fun getModelInfo(): Map<String, Any> = mapOf(
        "model" to modelPath,
        "loaded" to (interpreter != null),
        "threshold" to threshold
    )
}

data class DetectionResult(
    val isWake: Boolean,
    val confidence: Float,
    val message: String = ""
) {
    companion object {
        fun wake(confidence: Float) = DetectionResult(true, confidence, "Wake detected")
        fun notWake(confidence: Float) = DetectionResult(false, confidence, "Not wake")
        fun error(message: String) = DetectionResult(false, 0f, message)
    }
}

interface IWakeWordDetector {
    fun initialize(): Boolean
    fun detectWakeWord(audioFrame: ByteArray): DetectionResult
    fun release()
    fun setThreshold(threshold: Float)
    fun getModelInfo(): Map<String, Any>
}
