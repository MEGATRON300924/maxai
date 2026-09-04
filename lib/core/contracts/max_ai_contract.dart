/// Provider-neutral contract for the MAX intelligence layer.
///
/// Screens and controllers should depend on this boundary instead of a model
/// vendor such as Gemini. That keeps MAX AI replaceable and ecosystem-wide.
abstract interface class MaxAIContract {
  Future<MaxAIResponse> send(MaxAIRequest request);
}

class MaxAIRequest {
  const MaxAIRequest({
    required this.message,
    this.conversationId,
    this.metadata = const <String, dynamic>{},
  });

  final String message;
  final String? conversationId;
  final Map<String, dynamic> metadata;
}

class MaxAIResponse {
  const MaxAIResponse({
    required this.text,
    this.provider,
    this.conversationId,
    this.fromCache = false,
  });

  final String text;
  final String? provider;
  final String? conversationId;
  final bool fromCache;
}
