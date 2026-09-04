enum MessageSender { user, assistant, system }

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;
  final List<String> sources;
  final String? attachmentPath;
  final String? attachmentType;
  final String? linkPreview;
  final bool isLiked;
  final bool isDisliked;
  final bool isCopied;
  final bool isVoicePlaying;

  ChatMessage({required this.id, required this.text, required this.isUser, required this.createdAt, this.sources = const [], this.attachmentPath, this.attachmentType, this.linkPreview, this.isLiked = false, this.isDisliked = false, this.isCopied = false, this.isVoicePlaying = false});

  MessageSender get sender => isUser ? MessageSender.user : MessageSender.assistant;
  String get content => text;

  ChatMessage copyWith({String? id, String? text, bool? isUser, DateTime? createdAt, List<String>? sources, String? attachmentPath, String? attachmentType, String? linkPreview, bool? isLiked, bool? isDisliked, bool? isCopied, bool? isVoicePlaying}) => ChatMessage(id: id ?? this.id, text: text ?? this.text, isUser: isUser ?? this.isUser, createdAt: createdAt ?? this.createdAt, sources: sources ?? this.sources, attachmentPath: attachmentPath ?? this.attachmentPath, attachmentType: attachmentType ?? this.attachmentType, linkPreview: linkPreview ?? this.linkPreview, isLiked: isLiked ?? this.isLiked, isDisliked: isDisliked ?? this.isDisliked, isCopied: isCopied ?? this.isCopied, isVoicePlaying: isVoicePlaying ?? this.isVoicePlaying);
}
