import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import 'max_ai_brain.dart';
import 'max_voice_service.dart';
import 'memory_filter.dart';

class ChatService {
  ChatService({required this.brain, MaxVoiceService? voiceService})
      : _voiceService = voiceService;

  final MaxAIBrain brain;
  final MaxVoiceService? _voiceService;
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

  Future<VoiceTurn?> listenAndRespond() async {
    final voice = _voiceService;
    if (voice == null) return null;

    // Voice chat also works in the development guest mode. Once MAX Auth is
    // connected, the authenticated ID is used automatically for voice memory.
    final user = await brain.auth.currentUser();
    final userId = user?.id ?? 'guest';

    final text = await voice.listen(userId: userId);
    if (text == null || text.trim().isEmpty) return null;

    final response = await sendMessage(message: text);
    await voice.speak(response.text);
    return VoiceTurn(transcript: text, response: response);
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

class VoiceTurn {
  const VoiceTurn({required this.transcript, required this.response});

  final String transcript;
  final ChatMessage response;
}
