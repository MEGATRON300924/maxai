package com.thetronforge.maxai.wake.ml

import com.thetronforge.maxai.wake.util.Logger
import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.log
import kotlin.math.sqrt

class AudioFeatureExtractor(
    private val sampleRate: Int = 16000,
    private val numMfccCoefficients: Int = 13,
    private val fftSize: Int = 512,
    private val numMelBands: Int = 40
) {
    private val logger = Logger("FeatureExtractor")
    private val melFilterbank = createMelFilterbank()

    companion object {
        private const val PRE_EMPHASIS = 0.97f
    }

    fun extractFeatures(audioFrame: ByteArray): AudioFeatures {
        return try {
            val samples = audioFrame.toFloatArray()
            if (samples.isEmpty()) return AudioFeatures.empty()
            val emphasized = applyPreEmphasis(samples)
            val magnitude = computeMagnitude(computeFFT(emphasized))
            AudioFeatures(
                mfcc = extractMFCC(magnitude),
                spectralEnergy = computeSpectralEnergy(magnitude),
                zeroCrossingRate = computeZeroCrossingRate(samples),
                spectralCentroid = computeSpectralCentroid(magnitude),
                timestamp = System.currentTimeMillis()
            )
        } catch (e: Exception) {
            logger.error("Failed to extract features", e)
            AudioFeatures.empty()
        }
    }

    private fun applyPreEmphasis(samples: FloatArray): FloatArray {
        if (samples.isEmpty()) return samples
        val emphasized = FloatArray(samples.size)
        emphasized[0] = samples[0]
        for (i in 1 until samples.size) emphasized[i] = samples[i] - PRE_EMPHASIS * samples[i - 1]
        return emphasized
    }

    private fun computeFFT(samples: FloatArray): Array<Complex> {
        val padded = FloatArray(fftSize)
        samples.copyInto(padded, 0, 0, minOf(samples.size, fftSize))
        return simplifiedFFT(Array(fftSize) { Complex(padded[it].toDouble(), 0.0) })
    }

    private fun simplifiedFFT(samples: Array<Complex>): Array<Complex> {
        val n = samples.size
        if (n <= 1) return samples
        val even = Array(n / 2) { samples[it * 2] }
        val odd = Array(n / 2) { samples[it * 2 + 1] }
        val evenFft = simplifiedFFT(even)
        val oddFft = simplifiedFFT(odd)
        val result = Array(n) { Complex(0.0, 0.0) }
        for (k in 0 until n / 2) {
            val angle = -2.0 * PI * k / n
            val factor = Complex(cos(angle), kotlin.math.sin(angle))
            val oddTerm = oddFft[k] * factor
            result[k] = evenFft[k] + oddTerm
            result[k + n / 2] = evenFft[k] - oddTerm
        }
        return result
    }

    private fun computeMagnitude(fft: Array<Complex>): FloatArray =
        fft.map { sqrt(it.real * it.real + it.imag * it.imag).toFloat() }.toFloatArray()

    private fun extractMFCC(magnitude: FloatArray): FloatArray {
        val melSpectrum = applyMelFilterbank(magnitude)
        val logMel = melSpectrum.map { log(it.toDouble() + 1e-10).toFloat() }.toFloatArray()
        return applyDCT(logMel).take(numMfccCoefficients).toFloatArray()
    }

    private fun applyMelFilterbank(magnitude: FloatArray): FloatArray {
        val result = FloatArray(numMelBands)
        for (m in 0 until numMelBands) {
            var energy = 0f
            for (f in magnitude.indices) energy += magnitude[f] * melFilterbank[m * fftSize + f]
            result[m] = energy
        }
        return result
    }

    private fun applyDCT(input: FloatArray): List<Float> {
        val n = input.size
        return List(n) { k ->
            var sum = 0.0
            for (i in 0 until n) sum += input[i] * cos(PI * k * (i + 0.5) / n)
            (2.0 * sum).toFloat()
        }
    }

    private fun computeSpectralEnergy(magnitude: FloatArray): Float = magnitude.sumOf { (it * it).toDouble() }.toFloat()

    private fun computeZeroCrossingRate(samples: FloatArray): Float {
        if (samples.size < 2) return 0f
        var crossings = 0
        for (i in 1 until samples.size) {
            if ((samples[i - 1] < 0 && samples[i] >= 0) || (samples[i - 1] >= 0 && samples[i] < 0)) crossings++
        }
        return crossings.toFloat() / samples.size
    }

    private fun computeSpectralCentroid(magnitude: FloatArray): Float {
        var numerator = 0.0
        var denominator = 0.0
        for (f in magnitude.indices) {
            numerator += f * magnitude[f]
            denominator += magnitude[f]
        }
        return if (denominator > 0) (numerator / denominator).toFloat() else 0f
    }

    private fun createMelFilterbank(): FloatArray {
        val filterbank = FloatArray(numMelBands * fftSize)
        for (m in 0 until numMelBands) {
            for (f in 0 until fftSize) filterbank[m * fftSize + f] = if (f % numMelBands == m) 1f else 0f
        }
        return filterbank
    }
}

data class Complex(val real: Double, val imag: Double) {
    operator fun plus(other: Complex) = Complex(real + other.real, imag + other.imag)
    operator fun minus(other: Complex) = Complex(real - other.real, imag - other.imag)
    operator fun times(other: Complex) = Complex(real * other.real - imag * other.imag, real * other.imag + imag * other.real)
}

data class AudioFeatures(
    val mfcc: FloatArray,
    val spectralEnergy: Float,
    val zeroCrossingRate: Float,
    val spectralCentroid: Float,
    val timestamp: Long = System.currentTimeMillis()
) {
    fun toFeatureVector(): FloatArray = FloatArray(mfcc.size + 3).apply {
        mfcc.copyInto(this, 0)
        this[mfcc.size] = spectralEnergy
        this[mfcc.size + 1] = zeroCrossingRate
        this[mfcc.size + 2] = spectralCentroid
    }

    companion object {
        fun empty() = AudioFeatures(FloatArray(13), 0f, 0f, 0f)
    }
}

private fun ByteArray.toFloatArray(): FloatArray {
    val samples = FloatArray(size / 2)
    for (i in samples.indices) {
        val low = this[i * 2].toInt() and 0xFF
        val high = this[i * 2 + 1].toInt()
        samples[i] = ((high shl 8) or low).toShort().toFloat() / 32768f
    }
    return samples
}
