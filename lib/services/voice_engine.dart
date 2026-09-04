import 'dart:async';

import 'package:flutter/services.dart';

import 'max_memory_service.dart';

enum MaxVoiceState {
  idle,
  listening,
  thinking,
  speaking,
  error,
}

class VoiceEngine {
  VoiceEngine._();

  static final VoiceEngine instance = VoiceEngine._();

  static const MethodChannel _methodChannel =
      MethodChannel('com.thetronforge.maxai/voice');

  static const EventChannel _eventChannel =
      EventChannel('com.thetronforge.maxai/voice/events');

  final MaxMemoryService _memory = MaxMemoryService.instance;

  StreamSubscription<dynamic>? _eventSubscription;

  final StreamController<MaxVoiceState> _stateController =
      StreamController<MaxVoiceState>.broadcast();

  final StreamController<String> _transcriptionController =
      StreamController<String>.broadcast();

  final StreamController<String> _speechController =
      StreamController<String>.broadcast();

  final StreamController<double> _audioLevelController =
      StreamController<double>.broadcast();

  MaxVoiceState _state = MaxVoiceState.idle;
  bool _initialized = false;
  bool _listening = false;
  bool _wakeEngineEnabled = false;

  Stream<MaxVoiceState> get stateStream => _stateController.stream;

  Stream<String> get transcriptionStream =>
      _transcriptionController.stream;

  Stream<String> get speechStream => _speechController.stream;

  Stream<double> get audioLevelStream =>
      _audioLevelController.stream;

  MaxVoiceState get state => _state;

  bool get isListening => _listening;

  bool get isWakeEngineEnabled => _wakeEngineEnabled;

  Future<void> initialize() async {
    if (_initialized) return;

    await _memory.initialize();

    try {
      await _methodChannel.invokeMethod('initialize');

      _eventSubscription = _eventChannel
          .receiveBroadcastStream()
          .listen(
            _handleNativeEvent,
            onError: _handleNativeError,
          );

      _initialized = true;
      _setState(MaxVoiceState.idle);
    } catch (_) {
      _initialized = true;
      _setState(MaxVoiceState.idle);
    }
  }

  Future<bool> startListening() async {
    await initialize();

    if (_listening) return true;

    try {
      final result = await _methodChannel.invokeMethod<bool>(
        'startListening',
      );

      if (result == false) {
        _setState(MaxVoiceState.error);
        return false;
      }

      _listening = true;
      _setState(MaxVoiceState.listening);
      return true;
    } catch (_) {
      _listening = false;
      _setState(MaxVoiceState.error);
      return false;
    }
  }

  Future<void> stopListening() async {
    if (!_initialized) return;

    try {
      await _methodChannel.invokeMethod('stopListening');
    } catch (_) {}

    _listening = false;
    _setState(MaxVoiceState.idle);
  }

  Future<bool> startWakeEngine() async {
    await initialize();

    try {
      final result = await _methodChannel.invokeMethod<bool>(
        'startWakeEngine',
      );

      _wakeEngineEnabled = result ?? true;
      return _wakeEngineEnabled;
    } catch (_) {
      return false;
    }
  }

  Future<void> stopWakeEngine() async {
    if (!_initialized) return;

    try {
      await _methodChannel.invokeMethod('stopWakeEngine');
    } catch (_) {}

    _wakeEngineEnabled = false;
  }

  Future<void> toggleWakeEngine(bool enabled) async {
    if (enabled) {
      await startWakeEngine();
    } else {
      await stopWakeEngine();
    }
  }

  Future<String?> recognize() async {
    final started = await startListening();

    if (!started) return null;

    try {
      final result = await _methodChannel.invokeMethod<String>(
        'recognize',
      );

      if (result == null || result.trim().isEmpty) {
        await stopListening();
        return null;
      }

      final text = result.trim();

      _transcriptionController.add(text);

      await _saveVoiceMemory(text);

      await stopListening();

      return text;
    } catch (_) {
      await stopListening();
      return null;
    }
  }

  Future<void> speak(
    String text, {
    bool saveToMemory = true,
  }) async {
    final normalized = text.trim();

    if (normalized.isEmpty) return;

    await initialize();

    _setState(MaxVoiceState.speaking);

    if (saveToMemory) {
      await _memory.saveVoiceMemory(
        content: 'MAX said: $normalized',
        importance: 0.35,
      );
    }

    _speechController.add(normalized);

    try {
      await _methodChannel.invokeMethod(
        'speak',
        {
          'text': normalized,
        },
      );
    } catch (_) {}

    _setState(
      _listening
          ? MaxVoiceState.listening
          : MaxVoiceState.idle,
    );
  }

  Future<void> stopSpeaking() async {
    try {
      await _methodChannel.invokeMethod('stopSpeaking');
    } catch (_) {}

    _setState(
      _listening
          ? MaxVoiceState.listening
          : MaxVoiceState.idle,
    );
  }

  Future<void> setVoiceVolume(double volume) async {
    final normalized = volume.clamp(0.0, 1.0);

    try {
      await _methodChannel.invokeMethod(
        'setVolume',
        {
          'volume': normalized,
        },
      );
    } catch (_) {}
  }

  Future<void> setSpeechRate(double rate) async {
    final normalized = rate.clamp(0.1, 3.0);

    try {
      await _methodChannel.invokeMethod(
        'setSpeechRate',
        {
          'rate': normalized,
        },
      );
    } catch (_) {}
  }

  Future<void> setSpeechPitch(double pitch) async {
    final normalized = pitch.clamp(0.5, 2.0);

    try {
      await _methodChannel.invokeMethod(
        'setSpeechPitch',
        {
          'pitch': normalized,
        },
      );
    } catch (_) {}
  }

  Future<void> _saveVoiceMemory(String text) async {
    final normalized = text.trim();

    if (normalized.isEmpty) return;

    final importance = _calculateImportance(normalized);

    if (importance >= 0.55) {
      await _memory.saveVoiceMemory(
        content: 'User said: $normalized',
        importance: importance,
      );
    }
  }

  double _calculateImportance(String text) {
    final lower = text.toLowerCase();

    const importantPatterns = [
      'remember',
      'my name',
      'i am',
      "i'm",
      'i like',
      'i love',
      'i hate',
      'i prefer',
      'my favorite',
      'my favourite',
      'i prefer',
      'always',
      'never',
      'dont',
      "don't",
      'do not',
      'important',
      'from now on',
      'call me',
    ];

    final matches = importantPatterns.where(
      lower.contains,
    ).length;

    if (matches >= 2) return 0.95;
    if (matches == 1) return 0.8;

    if (text.length > 120) return 0.65;

    return 0.4;
  }

  void _handleNativeEvent(dynamic event) {
    if (event is! Map) return;

    final data = Map<String, dynamic>.from(event);

    final type = data['type']?.toString();

    switch (type) {
      case 'wakeDetected':
      case 'wake_detected':
        _setState(MaxVoiceState.listening);
        _listening = true;
        break;

      case 'listeningStarted':
      case 'listening_started':
        _listening = true;
        _setState(MaxVoiceState.listening);
        break;

      case 'listeningStopped':
      case 'listening_stopped':
        _listening = false;
        _setState(MaxVoiceState.idle);
        break;

      case 'transcription':
      case 'transcribed':
        final text = data['text']?.toString().trim();

        if (text != null && text.isNotEmpty) {
          _transcriptionController.add(text);
          unawaited(_saveVoiceMemory(text));
        }
        break;

      case 'audioLevel':
      case 'audio_level':
        final value = data['normalized'];

        if (value is num) {
          _audioLevelController.add(
            value.toDouble().clamp(0.0, 1.0),
          );
        }
        break;

      case 'thinking':
        _setState(MaxVoiceState.thinking);
        break;

      case 'speaking':
        _setState(MaxVoiceState.speaking);
        break;

      case 'speechFinished':
      case 'speech_finished':
        _setState(
          _listening
              ? MaxVoiceState.listening
              : MaxVoiceState.idle,
        );
        break;

      case 'error':
        _setState(MaxVoiceState.error);
        break;
    }
  }

  void _handleNativeError(Object error) {
    _setState(MaxVoiceState.error);
  }

  void _setState(MaxVoiceState value) {
    _state = value;

    if (!_stateController.isClosed) {
      _stateController.add(value);
    }
  }

  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    _eventSubscription = null;

    await _stateController.close();
    await _transcriptionController.close();
    await _speechController.close();
    await _audioLevelController.close();

    _initialized = false;
    _listening = false;
    _wakeEngineEnabled = false;
  }
}