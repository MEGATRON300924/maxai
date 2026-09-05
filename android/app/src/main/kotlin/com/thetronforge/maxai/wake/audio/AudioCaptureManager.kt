package com.thetronforge.maxai.wake.audio

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioRecord
import android.media.MediaRecorder
import androidx.core.content.ContextCompat
import com.thetronforge.maxai.wake.util.WakeEngineConstants
import com.thetronforge.maxai.wake.util.Logger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch

class AudioCaptureManager(
    private val context: Context,
    private val onFrameCallback: (ByteArray) -> Unit,
    private val onErrorCallback: (String, Exception) -> Unit
) {
    private val logger = Logger("MAXAudioCapture")
    private var audioRecord: AudioRecord? = null
    private var captureJob: Job? = null
    private var running = false

    fun initialize() {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
            throw SecurityException("RECORD_AUDIO permission is required for Hey MAX.")
        }
        val minBuffer = AudioRecord.getMinBufferSize(
            WakeEngineConstants.SAMPLE_RATE,
            WakeEngineConstants.CHANNEL_CONFIG,
            WakeEngineConstants.AUDIO_FORMAT
        )
        require(minBuffer > 0) { "Unable to initialize microphone." }
        val bufferSize = maxOf(minBuffer, WakeEngineConstants.FRAME_SIZE_BYTES * 4)
        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.VOICE_RECOGNITION,
            WakeEngineConstants.SAMPLE_RATE,
            WakeEngineConstants.CHANNEL_CONFIG,
            WakeEngineConstants.AUDIO_FORMAT,
            bufferSize
        )
    }

    fun startCapture(scope: CoroutineScope) {
        if (running) return
        val recorder = audioRecord ?: run {
            initialize()
            audioRecord ?: return
        }
        try {
            recorder.startRecording()
            running = true
            captureJob?.cancel()
            captureJob = scope.launch(Dispatchers.IO) {
                val buffer = ByteArray(WakeEngineConstants.FRAME_SIZE_BYTES)
                while (isActive && running) {
                    val read = recorder.read(buffer, 0, buffer.size, AudioRecord.READ_BLOCKING)
                    if (read > 0) onFrameCallback(buffer.copyOf(read))
                    else if (read < 0) throw IllegalStateException("AudioRecord read failed: $read")
                }
            }
        } catch (e: Exception) {
            running = false
            onErrorCallback("Microphone capture failed", e)
        }
    }

    fun stopCapture() {
        running = false
        captureJob?.cancel()
        captureJob = null
        try {
            if (audioRecord?.recordingState == AudioRecord.RECORDSTATE_RECORDING) audioRecord?.stop()
        } catch (e: Exception) {
            logger.warn("Audio recorder stop failed", e)
        }
    }

    fun release() {
        stopCapture()
        audioRecord?.release()
        audioRecord = null
    }
}
