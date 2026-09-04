import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _themeMode = "theme_mode";
  static const _dynamicColor = "dynamic_color";
  static const _fontScale = "font_scale";
  static const _voiceSpeed = "voice_speed";
  static const _voicePitch = "voice_pitch";
  static const _voiceEnabled = "voice_enabled";
  static const _wakeWord = "wake_word";
  static const _offlineMode = "offline_mode";
  static const _saveHistory = "save_history";
  static const _saveMemory = "save_memory";
  static const _notifications = "notifications";
  static const _privacyMode = "privacy_mode";
  static const _developerMode = "developer_mode";
  static const _betaFeatures = "beta_features";
  static const _language = "language";
  static const _region = "region";
  static const _model = "model";
  static const _temperature = "temperature";

  ThemeMode themeMode = ThemeMode.dark;

  bool dynamicColor = true;

  double fontScale = 1.0;

  double voiceSpeed = 0.5;

  double voicePitch = 1.0;

  bool voiceEnabled = true;

  bool wakeWord = true;

  bool offlineMode = false;

  bool saveHistory = true;

  bool saveMemory = true;

  bool notifications = true;

  bool privacyMode = false;

  bool developerMode = false;

  bool betaFeatures = false;

  String language = "English";

  String region = "Nigeria";

  String model = "gemini-2.5-flash";

  double temperature = 0.7;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    themeMode = ThemeMode.values[
        prefs.getInt(_themeMode) ?? ThemeMode.dark.index];

    dynamicColor = prefs.getBool(_dynamicColor) ?? true;

    fontScale = prefs.getDouble(_fontScale) ?? 1;

    voiceSpeed = prefs.getDouble(_voiceSpeed) ?? .5;

    voicePitch = prefs.getDouble(_voicePitch) ?? 1;

    voiceEnabled = prefs.getBool(_voiceEnabled) ?? true;

    wakeWord = prefs.getBool(_wakeWord) ?? true;

    offlineMode = prefs.getBool(_offlineMode) ?? false;

    saveHistory = prefs.getBool(_saveHistory) ?? true;

    saveMemory = prefs.getBool(_saveMemory) ?? true;

    notifications = prefs.getBool(_notifications) ?? true;

    privacyMode = prefs.getBool(_privacyMode) ?? false;

    developerMode = prefs.getBool(_developerMode) ?? false;

    betaFeatures = prefs.getBool(_betaFeatures) ?? false;

    language = prefs.getString(_language) ?? "English";

    region = prefs.getString(_region) ?? "Nigeria";

    model = prefs.getString(_model) ?? "gemini-2.5-flash";

    temperature = prefs.getDouble(_temperature) ?? .7;

    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_themeMode, themeMode.index);

    await prefs.setBool(_dynamicColor, dynamicColor);

    await prefs.setDouble(_fontScale, fontScale);

    await prefs.setDouble(_voiceSpeed, voiceSpeed);

    await prefs.setDouble(_voicePitch, voicePitch);

    await prefs.setBool(_voiceEnabled, voiceEnabled);

    await prefs.setBool(_wakeWord, wakeWord);

    await prefs.setBool(_offlineMode, offlineMode);

    await prefs.setBool(_saveHistory, saveHistory);

    await prefs.setBool(_saveMemory, saveMemory);

    await prefs.setBool(_notifications, notifications);

    await prefs.setBool(_privacyMode, privacyMode);

    await prefs.setBool(_developerMode, developerMode);

    await prefs.setBool(_betaFeatures, betaFeatures);

    await prefs.setString(_language, language);

    await prefs.setString(_region, region);

    await prefs.setString(_model, model);

    await prefs.setDouble(_temperature, temperature);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    await _save();
    notifyListeners();
  }

  Future<void> setDynamicColor(bool value) async {
    dynamicColor = value;
    await _save();
    notifyListeners();
  }

  Future<void> setFontScale(double value) async {
    fontScale = value;
    await _save();
    notifyListeners();
  }

  Future<void> setVoiceSpeed(double value) async {
    voiceSpeed = value;
    await _save();
    notifyListeners();
  }

  Future<void> setVoicePitch(double value) async {
    voicePitch = value;
    await _save();
    notifyListeners();
  }

  Future<void> setVoiceEnabled(bool value) async {
    voiceEnabled = value;
    await _save();
    notifyListeners();
  }

  Future<void> setWakeWord(bool value) async {
    wakeWord = value;
    await _save();
    notifyListeners();
  }

  Future<void> setOfflineMode(bool value) async {
    offlineMode = value;
    await _save();
    notifyListeners();
  }

  Future<void> setSaveHistory(bool value) async {
    saveHistory = value;
    await _save();
    notifyListeners();
  }

  Future<void> setSaveMemory(bool value) async {
    saveMemory = value;
    await _save();
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    notifications = value;
    await _save();
    notifyListeners();
  }

  Future<void> setPrivacyMode(bool value) async {
    privacyMode = value;
    await _save();
    notifyListeners();
  }

  Future<void> setDeveloperMode(bool value) async {
    developerMode = value;
    await _save();
    notifyListeners();
  }

  Future<void> setBetaFeatures(bool value) async {
    betaFeatures = value;
    await _save();
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    language = value;
    await _save();
    notifyListeners();
  }

  Future<void> setRegion(String value) async {
    region = value;
    await _save();
    notifyListeners();
  }

  Future<void> setModel(String value) async {
    model = value;
    await _save();
    notifyListeners();
  }

  Future<void> setTemperature(double value) async {
    temperature = value;
    await _save();
    notifyListeners();
  }
}