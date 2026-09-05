import 'max_wake_controller.dart';

/// Compatibility facade for the native MAX wake-word bridge.
/// New code should prefer [MaxWakeController].
class MaxWakeBridgeService {
  final MaxWakeController _controller = MaxWakeController();

  Stream<Map<String, dynamic>> get wakeEvents => _controller.wakeEvents;

  Future<bool> startWakeEngine() => _controller.startWakeEngine();

  Future<void> stopWakeEngine() => _controller.stopWakeEngine();
}
