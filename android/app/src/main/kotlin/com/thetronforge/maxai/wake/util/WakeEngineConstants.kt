package com.thetronforge.maxai.wake.util

object WakeEngineConstants {
    const val SAMPLE_RATE = 16000
    const val CHANNEL_CONFIG = android.media.AudioFormat.CHANNEL_IN_MONO
    const val AUDIO_FORMAT = android.media.AudioFormat.ENCODING_PCM_16BIT
    const val FRAME_SIZE_SAMPLES = 512
    const val FRAME_SIZE_BYTES = FRAME_SIZE_SAMPLES * 2

    enum class ListeningMode {
        FOREGROUND,
        BACKGROUND,
    }
}
