package com.thetronforge.maxai

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import com.thetronforge.maxai.wake.audio.AudioFocusManager
import com.thetronforge.maxai.wake.config.WakeConfiguration
import com.thetronforge.maxai.wake.events.EventDispatcher
import com.thetronforge.maxai.wake.optimization.BatteryOptimizer
import com.thetronforge.maxai.wake.session.WakeSessionManagerV2
import com.thetronforge.maxai.wake.util.Logger
import com.thetronforge.maxai.wake.util.WakeEngineConstants

class MainActivity : FlutterActivity() {
    companion object {
        private const val METHOD_CHANNEL = "com.maxai/wake"
        private const val EVENT_CHANNEL = "com.maxai/wake_events"
    }

    private lateinit var wakeManager: WakeSessionManagerV2
    private val eventDispatcher = EventDispatcher()
    private var eventSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initializeWakeEngine()
    }

    private fun initializeWakeEngine() {
        wakeManager = WakeSessionManagerV2(
            context = this,
            configuration = WakeConfiguration(),
            eventDispatcher = eventDispatcher,
            audioFocusManager = AudioFocusManager(this),
            batteryOptimizer = BatteryOptimizer(this),
            logger = Logger("MAX")
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startWake" -> {
                    wakeManager.startListening(WakeEngineConstants.ListeningMode.BACKGROUND)
                    result.success(wakeManager.isActive())
                }
                "stopWake" -> {
                    wakeManager.stopListening()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private val listener = object : EventDispatcher.Listener {
                    override fun onEvent(event: Map<String, Any?>) {
                        runOnUiThread { eventSink?.success(event) }
                    }
                }

                override fun onListen(args: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    eventDispatcher.addListener(listener)
                }

                override fun onCancel(args: Any?) {
                    eventDispatcher.removeListener(listener)
                    eventSink = null
                }
            }
        )
    }

    override fun onDestroy() {
        if (::wakeManager.isInitialized) wakeManager.cleanup()
        super.onDestroy()
    }
}
