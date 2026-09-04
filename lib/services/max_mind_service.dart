import 'dart:math';

import '../models/mind_response.dart';

class MaxMindService {
  final Random _random = Random();

  MindResponse onboardingName(String name) {
    final value = name.trim();

    if (value.isEmpty) {
      return const MindResponse(
        message: "I'd like a name I can call you.",
        canContinue: false,
        shouldSaveToSupabase: false,
        saveMemory: false,
        requiresCorrection: true,
      );
    }

    if (value.length == 1) {
      return const MindResponse(
        message: "That's quite short. Is that the name you'd like me to use?",
        canContinue: false,
        shouldSaveToSupabase: false,
        saveMemory: false,
        requiresCorrection: true,
      );
    }

    if (RegExp(r'^[😀-🙏]+$').hasMatch(value)) {
      return const MindResponse(
        message: "I can use emojis, but I'd still like to know your name.",
        canContinue: false,
        shouldSaveToSupabase: false,
        saveMemory: false,
        requiresCorrection: true,
      );
    }

    if (value.contains(' ')) {
      final firstName = value.split(' ').first;

      return MindResponse(
        message:
            "Would you prefer I call you $firstName or $value?",
      );
    }

    final replies = [
      "Nice name you've got there, $value.",
      "It's great to meet you, $value.",
      "$value... I like that.",
      "Welcome, $value.",
      "Looking forward to getting to know you, $value.",
      "Glad you're here, $value.",
    ];

    return MindResponse(
      message: replies[_random.nextInt(replies.length)],
    );
  }
}