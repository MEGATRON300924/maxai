package com.thetronforge.maxai.wake.events

class EventDispatcher {
    interface Listener {
        fun onEvent(event: Map<String, Any?>)
    }

    private val listeners = mutableSetOf<Listener>()

    @Synchronized
    fun addListener(listener: Listener) {
        listeners.add(listener)
    }

    @Synchronized
    fun removeListener(listener: Listener) {
        listeners.remove(listener)
    }

    fun publishListeningStarted(mode: String) = publish(
        mapOf("type" to "listening_started", "mode" to mode)
    )

    fun publishListeningStopped(reason: String) = publish(
        mapOf("type" to "listening_stopped", "reason" to reason)
    )

    fun publishWakeDetected(phrase: String, confidence: Float) = publish(
        mapOf("type" to "wake_detected", "phrase" to phrase, "confidence" to confidence)
    )

    fun publishAudioLevel(db: Float, normalized: Float, isVoice: Boolean) = publish(
        mapOf("type" to "audio_level", "db" to db, "normalized" to normalized, "isVoice" to isVoice)
    )

    fun publishError(message: String, code: String, error: Throwable? = null) = publish(
        mapOf("type" to "error", "message" to message, "code" to code, "error" to error?.message)
    )

    private fun publish(event: Map<String, Any?>) {
        val snapshot = synchronized(this) { listeners.toList() }
        snapshot.forEach { it.onEvent(event) }
    }
}
