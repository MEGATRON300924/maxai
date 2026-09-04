import 'package:flutter/widgets.dart';

class AppBootstrap {
  AppBootstrap._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initializeServices();
  }

  static Future<void> _initializeServices() async {
    // Supabase
    // Local Storage
    // Authentication
    // MAX Memory
    // Notifications
    // Overlay Service
    // Wake Engine
    // Analytics
    // Crash Reporting
  }
}