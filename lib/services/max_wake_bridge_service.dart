import 'package:flutter/services.dart';
import 'max_wake_controller.dart';

/// Compatibility facade for the native MAX wake-word bridge.
/// New code should prefer [MaxWakeController].
class MaxWakeBridgeService {
  static const MethodChannel _channel = MethodChannel('com.maxai/wake');
  static const EventChannel _events = EventChannel('com.maxai/wake_events');

  Stream<Map<String, dynamic>> get wakeEvents =>
      _events.receiveBroadcastStream().map((event) {
        if (event is Map) return Map<String, dynamic>.from(event);
        return <String, dynamic>{'event': event};
      });

  Future<bool> startWakeEngine() async {
    final controller = MaxWakeController();
    return controller.startWakeEngine();
  }

  Future<void> stopWakeEngine() async {
    await _channel.invokeMethod('stopWake');
  }
}
