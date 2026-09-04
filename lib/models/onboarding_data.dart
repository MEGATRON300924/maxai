class OnboardingData {
  String? name;
  List<String> interests;
  String? religion;
  String? goal;

  OnboardingData({
    this.name,
    this.interests = const [],
    this.religion,
    this.goal,
  });

  bool get isComplete =>
      name != null &&
      name!.trim().isNotEmpty &&
      interests.isNotEmpty &&
      goal != null &&
      goal!.trim().isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'display_name': name,
      'interests': interests,
      'religion': religion,
      'goal': goal,
      'completed_onboarding': true,
    };
  }

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      name: json['display_name'],
      interests: List<String>.from(json['interests'] ?? []),
      religion: json['religion'],
      goal: json['goal'],
    );
  }

  OnboardingData copyWith({
    String? name,
    List<String>? interests,
    String? religion,
    String? goal,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      interests: interests ?? this.interests,
      religion: religion ?? this.religion,
      goal: goal ?? this.goal,
    );
  }
}