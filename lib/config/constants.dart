class AppConstants {
  AppConstants._();

  static const String appName = 'MAX AI';
  static const String companyName = 'The Tron Forge Limited';

  static const String basicPlan = 'MAX Basic';
  static const String proPlan = 'MAX Pro';
  static const String ultraPlan = 'MAX Ultra';

  static const int onboardingSteps = 5;

  static const Duration splashDuration = Duration(
    milliseconds: 2500,
  );
}

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = '';

  static const String apiVersion = 'v1';

  static const String aiEndpoint = '/ai';

  static const String authEndpoint = '/auth';

  static const String memoryEndpoint = '/memory';

  static const String searchEndpoint = '/search';

  static const String voiceEndpoint = '/voice';
}

class DatabaseConstants {
  DatabaseConstants._();

  static const String profiles = 'profiles';

  static const String subscriptions = 'subscriptions';

  static const String devices = 'devices';

  static const String memories = 'memories';

  static const String displayName = 'display_name';

  static const String interests = 'interests';

  static const String religion = 'religion';

  static const String goal = 'goal';

  static const String avatar = 'avatar';

  static const String theme = 'theme';

  static const String language = 'language';

  static const String completedOnboarding = 'completed_onboarding';
}

class StorageConstants {
  StorageConstants._();

  static const String avatars = 'avatars';

  static const String beta = 'beta';

  static const String maxCloud = 'max_cloud';
}

class PreferenceConstants {
  PreferenceConstants._();

  static const String firstLaunch = 'first_launch';

  static const String onboardingCompleted = 'onboarding_completed';

  static const String themeMode = 'theme_mode';

  static const String locale = 'locale';
}