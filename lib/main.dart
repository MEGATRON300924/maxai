import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'providers/home_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/plan_provider.dart';
import 'providers/onboarding_provider.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/gemini_service.dart';
import 'services/max_ai_brain.dart';
import 'services/max_memory_service.dart';
import 'services/max_voice_service.dart';
import 'services/max_wake_controller.dart';
import 'ai/context_provider.dart';
import 'ai/memory_manager.dart';
import 'core/app_colors.dart';
import 'core/runtime/max_runtime_scope.dart';

const _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final runtime = await MaxRuntimeScope.instance.initialize();
  final brain = MaxAIBrain(
    gemini: GeminiService(apiKey: _geminiApiKey),
    auth: runtime.auth,
  );

  final voiceService = MaxVoiceService(memoryService: MaxMemoryService.instance);
  try {
    await voiceService.initialize();
  } catch (_) {
    // Voice permissions/devices are initialized lazily when voice is used.
  }

  runApp(
    MaxAIApp(
      chatService: ChatService(brain: brain, voiceService: voiceService),
      wakeController: MaxWakeController(),
    ),
  );
}

class MaxAIApp extends StatelessWidget {
  const MaxAIApp({
    super.key,
    required this.chatService,
    this.wakeController,
  });

  final ChatService chatService;
  final MaxWakeController? wakeController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            chatService: chatService,
            wakeController: wakeController,
          ),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => MaxContextProvider()),
        ChangeNotifierProvider.value(value: MemoryManager.instance),
        ChangeNotifierProvider.value(value: AuthService.instance),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MAX AI',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.darkBackground,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
