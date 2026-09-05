import 'max_intent.dart';

abstract interface class MaxTool {
  String get id;
  Set<MaxIntent> get supportedIntents;
  Future<MaxToolResult> execute(MaxToolRequest request);
}

class MaxToolRequest {
  const MaxToolRequest({
    required this.message,
    required this.intent,
    this.userId,
    this.conversationId,
    this.arguments = const <String, dynamic>{},
  });

  final String message;
  final MaxIntent intent;
  final String? userId;
  final String? conversationId;
  final Map<String, dynamic> arguments;
}

class MaxToolResult {
  const MaxToolResult.success({this.text, this.data}) : isSuccess = true, error = null;
  const MaxToolResult.failure(this.error) : isSuccess = false, text = null, data = null;

  final bool isSuccess;
  final String? text;
  final Map<String, dynamic>? data;
  final String? error;
}
