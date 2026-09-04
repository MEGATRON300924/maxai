import 'memory_manager.dart';

class MaxContext {
  final String currentScreen;
  final String? userName;
  final String? subscriptionPlan;
  final bool voiceActive;
  final Map<String, dynamic> appState;

  const MaxContext({required this.currentScreen, this.userName, this.subscriptionPlan, this.voiceActive = false, this.appState = const {}});

  MaxContext copyWith({String? currentScreen, String? userName, String? subscriptionPlan, bool? voiceActive, Map<String, dynamic>? appState}) => MaxContext(currentScreen: currentScreen ?? this.currentScreen, userName: userName ?? this.userName, subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan, voiceActive: voiceActive ?? this.voiceActive, appState: appState ?? this.appState);
}

class MaxMemoryContext {
  static String build() {
    final memory = MemoryManager.instance.memory;
    if (memory.isEmpty) return 'No saved memory.';
    return memory.entries.map((item) => '${item.key}: ${item.value}').join('\n');
  }
}
