package com.tronforge.maxai.wake.ml

import kotlin.math.*

/**
 * Audio Feature Extractor
 * 
 * Extracts MFCC (Mel-Frequency Cepstral Coefficients) and spectral features
 * from audio frames for wake word detection using neural networks
 * 
 * Features extracted:
 * - MFCC coefficients (typically 13-40)
 * - Spectral energy
 * - Zero crossing rate
 * - Spectral centroid
 * 
 * These features are standard input for audio ML models
 */
class AudioFeatureExtractor(
    private val sampleRate: Int = 16000,
    private val numMfccCoefficients: Int = 13,
    private val fftSize: Int = 512,
    private val numMelBands: Int = 40
) {

    private val logger = com.tronforge.max.wake.util.Logger("FeatureExtractor")

    // Pre-computed Mel filterbank
    private val melFilterbank = createMelFilterbank()

    companion object {
        private const val PRE_EMPHASIS = 0.97f
    }

    /**
     * Extract all features from audio frame
     * Returns feature vector ready for neural network input
     */
    fun extractFeatures(audioFrame: ByteArray): AudioFeatures {
        try {
            // Convert byte array to float samples
            val samples = audioFrame.toFloatArray()

            // Apply pre-emphasis filter
            val emphasizedSamples = applyPreEmphasis(samples)

            // Compute FFT
            val fft = computeFFT(emphasizedSamples)

            // Compute magnitude spectrum
            val magnitude = computeMagnitude(fft)

            // Extract MFCC
            val mfcc = extractMFCC(magnitude)

            // Extract other features
            val spectralEnergy = computeSpectralEnergy(magnitude)
            val zeroCrossingRate = computeZeroCrossingRate(samples)
            val spectralCentroid = computeSpectralCentroid(magnitude)

            return AudioFeatures(
                mfcc = mfcc,
                spectralEnergy = spectralEnergy,
                zeroCrossingRate = zeroCrossingRate,
                spectralCentroid = spectralCentroid,
                timestamp = System.currentTimeMillis()
            )
        } catch (e: Exception) {
            logger.error("Failed to extract features", e)
            return AudioFeatures.empty()
        }
    }

    /**
     * Apply pre-emphasis filter to reduce noise
     * Formula: y[n] = x[n] - α*x[n-1]
     */
    private fun applyPreEmphasis(samples: FloatArray): FloatArray {
        val emphasized = FloatArray(samples.size)
        emphasized[0] = samples[0]
        for (i in 1 until samples.size) {
            emphasized[i] = samples[i] - PRE_EMPHASIS * samples[i - 1]
        }
        return emphasized
    }

    /**
     * Simple FFT implementation using Cooley-Tukey algorithm
     * For production, consider using existing FFT library
     */
    private fun computeFFT(samples: FloatArray): Array<Complex> {
        val padded = FloatArray(fftSize)
        samples.copyInto(padded, 0, 0, minOf(samples.size, fftSize))

        return simplifiedFFT(padded.map { Complex(it.toDouble(), 0.0) }.toTypedArray())
    }

    /**
     * Simplified FFT (recursive, not optimized)
     * For production, use Apache Commons Math or similar
     */
    private fun simplifiedFFT(samples: Array<Complex>): Array<Complex> {
        val n = samples.size
        if (n <= 1) return samples

        val even = mutableListOf<Complex>()
        val odd = mutableListOf<Complex>()

        for (i in 0 until n step 2) {
            even.add(samples[i])
            if (i + 1 < n) odd.add(samples[i + 1])
        }

        val evenFFT = simplifiedFFT(even.toTypedArray())
        val oddFFT = simplifiedFFT(odd.toTypedArray())

        val result = Array(n) { Complex(0.0, 0.0) }

        for (k in 0 until n / 2) {
            val angle = -2.0 * PI * k / n
            val wk = Complex(cos(angle), sin(angle))
            val oddTerm = oddFFT[k] * wk

            result[k] = evenFFT[k] + oddTerm
            result[k + n / 2] = evenFFT[k] - oddTerm
        }

        return result
    }

    /**
     * Compute magnitude spectrum from FFT
     */
    private fun computeMagnitude(fft: Array<Complex>): FloatArray {
        return fft.map { c -> sqrt(c.real * c.real + c.imag * c.imag).toFloat() }.toFloatArray()
    }

    /**
     * Extract MFCC coefficients
     * Steps:
     * 1. Apply mel-scale filterbank
     * 2. Take logarithm
     * 3. Apply DCT (Discrete Cosine Transform)
     */
    private fun extractMFCC(magnitude: FloatArray): FloatArray {
        // Apply mel filterbank
        val melSpectrum = applyMelFilterbank(magnitude)

        // Take logarithm (add small value to avoid log(0))
        val logMel = melSpectrum.map { log(it + 1e-10f).toFloat() }.toFloatArray()

        // Apply DCT (Discrete Cosine Transform)
        return applyDCT(logMel).take(numMfccCoefficients).toFloatArray()
    }

    /**
     * Apply mel-scale filterbank
     * Converts frequency axis to mel scale (perceptual)
     */
    private fun applyMelFilterbank(magnitude: FloatArray): FloatArray {
        val melSpectrum = FloatArray(numMelBands)

        for (m in 0 until numMelBands) {
            var energy = 0f
            for (f in 0 until magnitude.size) {
                energy += magnitude[f] * melFilterbank.getOrNull(m * magnitude.size + f) ?: 0f
            }
            melSpectrum[m] = energy
        }

        return melSpectrum
    }

    /**
     * Apply Discrete Cosine Transform
     * Decorrelates MFCC features
     */
    private fun applyDCT(input: FloatArray): List<Float> {
        val n = input.size
        val dct = mutableListOf<Float>()

        for (k in 0 until n) {
            var sum = 0.0
            for (n_val in 0 until n) {
                sum += input[n_val] * cos(PI * k * (n_val + 0.5) / n)
            }
            dct.add((2.0 * sum).toFloat())
        }

        return dct
    }

    /**
     * Compute spectral energy
     */
    private fun computeSpectralEnergy(magnitude: FloatArray): Float {
        return magnitude.map { it * it }.sum()
    }

    /**
     * Compute zero crossing rate
     * High ZCR = high frequency content, low = low frequency
     */
    private fun computeZeroCrossingRate(samples: FloatArray): Float {
        var zeroCrossings = 0
        for (i in 1 until samples.size) {
            if ((samples[i - 1] < 0 && samples[i] >= 0) ||
                (samples[i - 1] >= 0 && samples[i] < 0)) {
                zeroCrossings++
            }
        }
        return zeroCrossings.toFloat() / samples.size
    }

    /**
     * Compute spectral centroid
     * Center of mass of the frequency spectrum
     */
    private fun computeSpectralCentroid(magnitude: FloatArray): Float {
        var numerator = 0.0
        var denominator = 0.0

        for (f in magnitude.indices) {
            numerator += f * magnitude[f]
            denominator += magnitude[f]
        }

        return if (denominator > 0) (numerator / denominator).toFloat() else 0f
    }

    /**
     * Create mel-scale filterbank matrix
     * Precomputed once at initialization
     */
    private fun createMelFilterbank(): FloatArray {
        val filterbank = FloatArray(numMelBands * fftSize)

        // Simplified mel filterbank
        for (m in 0 until numMelBands) {
            for (f in 0 until fftSize) {
                filterbank[m * fftSize + f] = if (f % 4 == m % 4) 1f else 0f
            }
        }

        return filterbank
    }
}

/**
 * Complex number for FFT
 */
data class Complex(val real: Double, val imag: Double) {
    operator fun plus(other: Complex) = Complex(real + other.real, imag + other.imag)
    operator fun minus(other: Complex) = Complex(real - other.real, imag - other.imag)
    operator fun times(other: Complex) = Complex(
        real * other.real - imag * other.imag,
        real * other.imag + imag * other.real
    )
}

/**
 * Audio features extracted from frame
 * Ready for neural network input
 */
data class AudioFeatures(
    val mfcc: FloatArray,           // MFCC coefficients
    val spectralEnergy: Float,      // Total spectral energy
    val zeroCrossingRate: Float,    // ZCR (0-1)
    val spectralCentroid: Float,    // Spectral center frequency
    val timestamp: Long = System.currentTimeMillis()
) {
    /**
     * Convert to flat feature vector for neural network
     * Concatenates all features into single array
     */
    fun toFeatureVector(): FloatArray {
        return FloatArray(mfcc.size + 3).apply {
            mfcc.copyInto(this, 0)
            this[mfcc.size] = spectralEnergy
            this[mfcc.size + 1] = zeroCrossingRate
            this[mfcc.size + 2] = spectralCentroid
        }
    }

    companion object {
        fun empty() = AudioFeatures(
            mfcc = FloatArray(13),
            spectralEnergy = 0f,
            zeroCrossingRate = 0f,
            spectralCentroid = 0f
        )
    }
}

/**
 * Extension: Convert byte array to float array (PCM 16-bit)
 */
private fun ByteArray.toFloatArray(): FloatArray {
    val shorts = ShortArray(this.size / 2)
    for (i in shorts.indices) {
        val high = this[i * 2 + 1].toInt()
        val low = this[i * 2].toInt() and 0xFF
        shorts[i] = (high.shl(8) or low).toShort()
    }

    // Normalize to -1.0 to 1.0 range
    return shorts.map { it.toFloat() / Short.MAX_VALUE }.toFloatArray()
}
