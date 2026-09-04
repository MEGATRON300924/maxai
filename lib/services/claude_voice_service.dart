/// Temporary compatibility adapter for the legacy MAX Chat screen.
///
/// Voice execution remains owned by the existing MAX Voice/wake-word stack.
/// This adapter prevents the legacy screen from depending on a removed Claude
/// implementation while MAX Voice is being unified underneath the new runtime.
class ClaudeVoiceService {
  ClaudeVoiceService._();
  static final ClaudeVoiceService instance = ClaudeVoiceService._();

  Future<void> startSession() async {
    // Voice integration is intentionally delegated to MAX Voice.
  }
}
