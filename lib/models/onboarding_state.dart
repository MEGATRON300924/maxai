import 'package:flutter/foundation.dart';

import 'onboarding_question.dart';

@immutable
class OnboardingState {
  final int currentStep;

  final OnboardingQuestion currentQuestion;

  final Map<OnboardingQuestionType, dynamic> answers;

  final bool canContinue;

  final bool isLoading;

  final bool completed;

  const OnboardingState({
    required this.currentStep,
    required this.currentQuestion,
    required this.answers,
    this.canContinue = false,
    this.isLoading = false,
    this.completed = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    OnboardingQuestion? currentQuestion,
    Map<OnboardingQuestionType, dynamic>? answers,
    bool? canContinue,
    bool? isLoading,
    bool? completed,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      answers: answers ?? this.answers,
      canContinue: canContinue ?? this.canContinue,
      isLoading: isLoading ?? this.isLoading,
      completed: completed ?? this.completed,
    );
  }
}