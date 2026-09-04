import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/onboarding_provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';
import '../ai/memory_manager.dart';
import '../services/max_memory_service.dart';
import 'main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController controller = TextEditingController();
  bool saving = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> continueSetup() async {
    final onboarding = context.read<OnboardingProvider>();
    final answer = controller.text.trim();

    if (answer.isEmpty) return;

    onboarding.saveAnswer(answer);
    controller.clear();

    if (onboarding.currentStep < onboarding.questions.length - 1) {
      onboarding.next();
      return;
    }

    setState(() => saving = true);

    final name = onboarding.answerForStep(0).isEmpty
        ? 'User'
        : onboarding.answerForStep(0);
    final interests = onboarding.answerForStep(1);
    final helpGoals = onboarding.answerForStep(2);
    final communicationStyle = onboarding.answerForStep(3);
    final importantMemory = onboarding.answerForStep(4);

    final profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: '',
      interests: interests.isEmpty ? null : interests,
      preferences: [
        if (helpGoals.isNotEmpty) 'help_goals: $helpGoals',
        if (communicationStyle.isNotEmpty)
          'communication_style: $communicationStyle',
      ].join('\n'),
    );

    context.read<ProfileProvider>().loadProfile(profile);

    // Keep the legacy in-memory manager populated for existing UI callers.
    final memory = context.read<MemoryManager>();
    memory.save('name', name);
    if (interests.isNotEmpty) memory.save('interests', interests);
    if (helpGoals.isNotEmpty) memory.save('help_goals', helpGoals);
    if (communicationStyle.isNotEmpty) {
      memory.save('communication_style', communicationStyle);
    }
    if (importantMemory.isNotEmpty) {
      memory.save('important_memory', importantMemory);
    }

    // Persist the same onboarding facts into MAX's canonical memory service
    // so the AI brain can use them after app restarts.
    final maxMemory = MaxMemoryService.instance;
    await maxMemory.initialize();
    await maxMemory.savePreference(content: 'User name: $name');
    if (interests.isNotEmpty) {
      await maxMemory.savePreference(content: 'Interests: $interests');
    }
    if (helpGoals.isNotEmpty) {
      await maxMemory.savePreference(content: 'Help goals: $helpGoals');
    }
    if (communicationStyle.isNotEmpty) {
      await maxMemory.savePreference(
        content: 'Preferred communication style: $communicationStyle',
      );
    }
    if (importantMemory.isNotEmpty) {
      await maxMemory.saveImportantFact(content: importantMemory);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;
    setState(() => saving = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to MAX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                onboarding.questions[onboarding.currentStep],
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .7),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller,
                enabled: !saving,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your answer...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: .4),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: .08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saving ? null : continueSetup,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          onboarding.currentStep ==
                                  onboarding.questions.length - 1
                              ? 'Finish'
                              : 'Continue',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
