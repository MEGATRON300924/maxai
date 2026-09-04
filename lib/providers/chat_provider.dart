import 'package:flutter/material.dart';

import '../models/ai_state.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService chatService;

  ChatProvider({required this.chatService});

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  AIState _aiState = AIState.idle;
  AIState get aiState => _aiState;

  void setAIState(AIState state) {
    _aiState = state;
    notifyListeners();
  }

  Future<void> sendMessage({
    required String message,
    String? attachmentPath,
    String? attachmentType,
  }) async {
    if (message.trim().isEmpty && attachmentPath == null) return;

    _messages.add(chatService.createUserMessage(
      message: message,
      attachmentPath: attachmentPath,
      attachmentType: attachmentType,
    ));
    notifyListeners();

    _setTyping(true);
    setAIState(AIState.thinking);

    try {
      final response = await chatService.sendMessage(message: message);
      _messages.add(response);
      setAIState(AIState.speaking);
    } catch (_) {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "I couldn't complete that request right now.",
        isUser: false,
        createdAt: DateTime.now(),
      ));
      setAIState(AIState.idle);
    }

    _setTyping(false);
  }

  Future<void> sendVoiceMessage() async {
    if (_isTyping || _aiState == AIState.listening) return;

    setAIState(AIState.listening);
    try {
      final turn = await chatService.listenAndRespond();
      if (turn == null) {
        setAIState(AIState.idle);
        return;
      }

      _messages.add(
        chatService.createUserMessage(message: turn.transcript),
      );
      _messages.add(turn.response);
      setAIState(AIState.speaking);
    } catch (_) {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "I couldn't hear or process that. Please try again.",
        isUser: false,
        createdAt: DateTime.now(),
      ));
      setAIState(AIState.idle);
    } finally {
      _setTyping(false);
    }
  }

  void updateMessage({required String id, required ChatMessage message}) {
    final index = _messages.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _messages[index] = message;
    notifyListeners();
  }

  void copyMessage(String id) {
    final message = _findMessage(id);
    if (message == null) return;
    updateMessage(id: id, message: message.copyWith(isCopied: true));
  }

  void likeMessage(String id) {
    final message = _findMessage(id);
    if (message == null) return;
    updateMessage(id: id, message: message.copyWith(isLiked: true, isDisliked: false));
  }

  void dislikeMessage(String id) {
    final message = _findMessage(id);
    if (message == null) return;
    updateMessage(id: id, message: message.copyWith(isLiked: false, isDisliked: true));
  }

  void toggleVoicePlayback(String id) {
    final message = _findMessage(id);
    if (message == null) return;
    updateMessage(id: id, message: message.copyWith(isVoicePlaying: !message.isVoicePlaying));
  }

  void removeMessage(String id) {
    _messages.removeWhere((message) => message.id == id);
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    setAIState(AIState.idle);
    notifyListeners();
  }

  ChatMessage? _findMessage(String id) {
    try {
      return _messages.firstWhere((message) => message.id == id);
    } catch (_) {
      return null;
    }
  }

  void _setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }
}
