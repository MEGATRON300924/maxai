import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'max_memory_service.dart';

class MaxVoiceService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speech = SpeechToText();
  final MaxMemoryService memoryService;
  bool listening = false;

  MaxVoiceService({required this.memoryService});

  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(.5);
    await _speech.initialize();
    await memoryService.initialize();
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() => _tts.stop();

  Future<void> stop() async {
    await _tts.stop();
    await cancelListening();
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<String?> listen({required String userId}) async {
    if (listening) return null;

    listening = true;
    var result = '';

    try {
      await _speech.listen(
        onResult: (value) {
          result = value.recognizedWords;
        },
      );

      while (_speech.isListening) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } finally {
      listening = false;
    }

    final transcript = result.trim();
    if (transcript.isEmpty) return null;

    await memoryService.saveVoiceMemory(
      content: transcript,
      importance: .65,
      tags: ['voice', 'user:$userId'],
    );
    return transcript;
  }

  Future<void> cancelListening() async {
    await _speech.stop();
    listening = false;
  }

  Future<void> setVoiceSettings({double speed = .5, double pitch = 1}) async {
    await _tts.setSpeechRate(speed.clamp(.1, 1));
    await _tts.setPitch(pitch.clamp(.5, 2));
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _speech.stop();
  }
}
