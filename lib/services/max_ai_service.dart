import '../core/contracts/max_ai_contract.dart';
import '../core/contracts/max_auth_contract.dart';
import 'gemini_service.dart';
import 'max_memory_service.dart';

/// Unified intelligence gateway for MAX AI and future MAX ecosystem surfaces.
class MaxAIService implements MaxAIContract {
  MaxAIService({
    required GeminiService model,
    MaxAuthContract? auth,
    MaxMemoryService? memory,
  })  : _model = model,
        _auth = auth,
        _memory = memory ?? MaxMemoryService.instance;

  final GeminiService _model;
  final MaxAuthContract? _auth;
  final MaxMemoryService _memory;

  @override
  Future<MaxAIResponse> send(MaxAIRequest request) async {
    final message = request.message.trim();
    if (message.isEmpty) {
      throw const MaxAIException('MAX cannot process an empty message.');
    }

    final user = await _auth?.currentUser();
    if (_auth != null && user == null) {
      throw const MaxAIAuthenticationException();
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
