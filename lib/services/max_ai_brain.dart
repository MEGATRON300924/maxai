import '../core/contracts/max_ai_contract.dart';
import '../core/contracts/max_auth_contract.dart';
import '../core/intelligence/max_memory_tool.dart';
import '../core/intelligence/max_request_router.dart';
import '../core/intelligence/max_tool_registry.dart';
import 'gemini_service.dart';
import 'max_ai_service.dart';
import 'max_auth_service.dart';
import 'max_memory_service.dart';

/// Compatibility facade for older callers while MAX AI uses the unified core.
class MaxAIBrain {
  MaxAIBrain({
    required this.gemini,
    MaxAuthContract? auth,
    MaxMemoryService? memory,
    MaxRequestRouter router = const MaxRequestRouter(),
    MaxToolRegistry? tools,
  })  : auth = auth ?? MaxAuthService(),
        memoryService = memory ?? MaxMemoryService.instance,
        _service = MaxAIService(
          model: gemini,
          auth: auth,
          memory: memory,
          router: router,
          tools: tools ?? MaxToolRegistry(),
        ) {
    if (tools == null) {
      _service.tools.register(MaxMemoryTool(memory: memoryService));
    }
  }

  final GeminiService gemini;
  final MaxAuthContract auth;
  final MaxMemoryService memoryService;
  final MaxAIService _service;

  MaxAIService get service => _service;

  Future<String> askMAX({required String message}) async {
    final response = await _service.send(
      MaxAIRequest(message: message),
    );
    return response.text;
  }
}
