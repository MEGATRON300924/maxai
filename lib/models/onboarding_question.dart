enum OnboardingQuestionType {
  name,
  goals,
  interests,
  religion,
  personality,
}

class OnboardingQuestion {
  final int step;

  final OnboardingQuestionType type;

  final String question;

  final String? subtitle;

  final List<String> options;

  const OnboardingQuestion({
    required this.step,
    required this.type,
    required this.question,
    this.subtitle,
    this.options = const [],
  });
}