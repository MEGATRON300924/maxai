import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class MaxWakeController {
  static const MethodChannel _channel = MethodChannel('com.maxai/wake');
  static const EventChannel _events = EventChannel('com.maxai/wake_events');

  Stream<Map<String, dynamic>> get wakeEvents =>
      _events.receiveBroadcastStream().map((event) {
        if (event is Map) {
          return Map<String, dynamic>.from(event);
        }
        return <String, dynamic>{'event': event};
      });

  Future<bool> startWakeEngine() async {
    final permission = await Permission.microphone.request();
    if (!permission.isGranted) return false;

    final active = await _channel.invokeMethod<bool>('startWake');
    return active ?? false;
  }

  Future<void> stopWakeEngine() async {
    await _channel.invokeMethod('stopWake');
  }
}
