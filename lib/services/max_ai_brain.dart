import '../core/contracts/max_auth_contract.dart';
import 'gemini_service.dart';
import 'max_memory_service.dart';

/// Compatibility facade for older callers while MAX AI moves to the unified core.
/// New code should depend on MaxAIService.
class MaxAIBrain {
  MaxAIBrain({
    required this.gemini,
    MaxAuthContract? auth,
    MaxMemoryService? memory,
  })  : auth = auth ?? MaxAuthService(),
        memoryService = memory ?? MaxMemoryService.instance;

  final GeminiService gemini;
  final MaxAuthContract auth;
  final MaxMemoryService memoryService;

  Future<String> askMAX({required String message}) async {
    final user = await auth.currentUser();
    if (user == null) return 'Please sign in to use MAX.';

    await memoryService.initialize();
    final memories = memoryService.relevantMemories(message, limit: 8);

    return gemini.sendMessage(
      message: message,
      memories: memories,
      userProfile: {
        'id': user.id,
        'email': user.email,
        'name': user.displayName,
      },
    );
  }
}
