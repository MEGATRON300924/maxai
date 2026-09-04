import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int currentStep = 0;

  final Map<String, String> answers = {};

  final List<String> questions = [
    'What should MAX call you?',
    'What are your interests?',
    'What do you want MAX to help you with?',
    'What is your preferred communication style?',
    'Anything MAX should remember about you?',
  ];

  String answerForStep(int step) => answers[step.toString()] ?? '';

  bool hasAnswer(int step) => answerForStep(step).trim().isNotEmpty;

  void saveAnswer(String value) {
    answers[currentStep.toString()] = value.trim();
    notifyListeners();
  }

  void next() {
    if (currentStep < questions.length - 1) {
      currentStep++;
      notifyListeners();
    }
  }

  void previous() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void reset() {
    currentStep = 0;
    answers.clear();
    notifyListeners();
  }

  bool get finished => currentStep == questions.length - 1;
}
