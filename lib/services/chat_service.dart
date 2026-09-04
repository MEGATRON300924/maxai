import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import 'max_ai_brain.dart';
import 'memory_filter.dart';

class ChatService {
  ChatService({required this.brain});

  final MaxAIBrain brain;
  final Uuid _uuid = const Uuid();

  Future<ChatMessage> sendMessage({required String message}) async {
    final response = await brain.askMAX(message: message);
    await _processMemory(message);

    return ChatMessage(
      id: _uuid.v4(),
      text: response,
      isUser: false,
      createdAt: DateTime.now(),
      sources: _extractLinks(response),
      linkPreview: _findLink(response),
    );
  }

  ChatMessage createUserMessage({
    required String message,
    String? attachmentPath,
    String? attachmentType,
  }) {
    return ChatMessage(
      id: _uuid.v4(),
      text: message,
      isUser: true,
      createdAt: DateTime.now(),
      attachmentPath: attachmentPath,
      attachmentType: attachmentType,
      linkPreview: _findLink(message),
    );
  }

  Future<void> _processMemory(String message) async {
    if (!MemoryFilter.shouldRemember(message)) return;

    final user = await brain.auth.currentUser();
    if (user == null) return;

    await brain.memoryService.saveConversationMemory(
      content: message,
      importance: MemoryFilter.importance(message) / 5.0,
      tags: const ['conversation'],
    );
  }

  List<String> _extractLinks(String text) {
    return RegExp(r'https?:\/\/[^\s]+')
        .allMatches(text)
        .map((match) => match.group(0)!)
        .toList();
  }

  String? _findLink(String text) {
    final links = _extractLinks(text);
    return links.isEmpty ? null : links.first;
  }
}
