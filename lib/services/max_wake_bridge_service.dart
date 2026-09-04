import 'package:flutter/services.dart';

/// Compatibility facade for the native MAX wake-word bridge.
///
/// New code should prefer [MaxWakeController]. The channel names are kept
/// identical to the native MainActivity contract so both paths interoperate.
class MaxWakeBridgeService {
  static const MethodChannel _channel = MethodChannel('com.maxai/wake');
  static const EventChannel _events = EventChannel('com.maxai/wake_events');

  Stream<dynamic> get wakeEvents => _events.receiveBroadcastStream();

  Future<void> startWakeEngine() async {
    await _channel.invokeMethod('startWake');
  }

  Future<void> stopWakeEngine() async {
    await _channel.invokeMethod('stopWake');
  }
}
