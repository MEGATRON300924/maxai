import '../core/contracts/max_ai_contract.dart';
import '../core/contracts/max_auth_contract.dart';
import '../core/intelligence/max_request_router.dart';
import '../core/intelligence/max_tool.dart';
import '../core/intelligence/max_tool_registry.dart';
import 'gemini_service.dart';
import 'max_memory_service.dart';

/// Unified intelligence gateway for MAX AI and future MAX ecosystem surfaces.
///
/// Requests are classified first. A registered native tool gets the first
/// opportunity to handle the request; otherwise Gemini remains the fallback
/// conversational model. This keeps the app useful while ecosystem providers
/// are added independently.
class MaxAIService implements MaxAIContract {
  MaxAIService({
    required GeminiService model,
    MaxAuthContract? auth,
    MaxMemoryService? memory,
    MaxRequestRouter router = const MaxRequestRouter(),
    MaxToolRegistry? tools,
  })  : _model = model,
        _auth = auth,
        _memory = memory ?? MaxMemoryService.instance,
        _router = router,
        _tools = tools ?? MaxToolRegistry();

  final GeminiService _model;
  final MaxAuthContract? _auth;
  final MaxMemoryService _memory;
  final MaxRequestRouter _router;
  final MaxToolRegistry _tools;

  MaxToolRegistry get tools => _tools;

  @override
  Future<MaxAIResponse> send(MaxAIRequest request) async {
    final message = request.message.trim();
    if (message.isEmpty) {
      throw const MaxAIException('MAX cannot process an empty message.');
    }

    final route = _router.route(message);
    final user = await _auth?.currentUser();
    if (_auth != null && user == null) {
      throw const MaxAIAuthenticationException();
    }

    final tool = _tools.forIntent(route.intent);
    if (tool != null) {
      final result = await tool.execute(
        MaxToolRequest(
          message: message,
          intent: route.intent,
          userId: user?.id,
          conversationId: request.conversationId,
          arguments: request.metadata,
        ),
      );

      if (result.isSuccess && result.text != null && result.text!.trim().isNotEmpty) {
        return MaxAIResponse(
          text: result.text!.trim(),
          provider: 'tool:${tool.id}',
          conversationId: request.conversationId,
        );
      }
    }

    await _memory.initialize();
    final memories = _memory.relevantMemories(message, limit: 8);

    final response = await _model.sendMessage(
      message: message,
      memories: memories,
      userProfile: {
        if (user != null) 'id': user.id,
        if (user != null) 'email': user.email,
        if (user?.displayName != null) 'name': user!.displayName,
        'intent': route.intent.name,
        'intent_confidence': route.confidence,
        'requires_tool': route.requiresTool,
        ...request.metadata,
      },
    );

    return MaxAIResponse(
      text: response.trim(),
      provider: 'gemini',
      conversationId: request.conversationId,
    );
  }
}

class MaxAIException implements Exception {
  const MaxAIException(this.message);
  final String message;

  @override
  String toString() => 'MaxAIException: $message';
}

class MaxAIAuthenticationException extends MaxAIException {
  const MaxAIAuthenticationException() : super('Please sign in to use MAX.');
}
