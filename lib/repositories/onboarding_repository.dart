import '../models/onboarding_data.dart';

abstract class OnboardingRepository {
  Future<void> saveName(String name);

  Future<void> saveInterests(List<String> interests);

  Future<void> saveReligion(String? religion);

  Future<void> saveGoal(String goal);

  Future<void> save(OnboardingData data);

  Future<OnboardingData?> load();

  Future<void> complete();

  Future<bool> isCompleted();

  Future<void> clear();
}