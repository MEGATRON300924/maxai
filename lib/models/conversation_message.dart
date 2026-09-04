class ConversationMessage {
  final String text;

  final bool fromMax;

  final DateTime createdAt;

  final bool spoken;


  const ConversationMessage({
    required this.text,
    required this.fromMax,
    required this.createdAt,
    this.spoken = false,
  });


  ConversationMessage copyWith({
    String? text,
    bool? fromMax,
    DateTime? createdAt,
    bool? spoken,
  }) {
    return ConversationMessage(
      text: text ?? this.text,
      fromMax: fromMax ?? this.fromMax,
      createdAt: createdAt ?? this.createdAt,
      spoken: spoken ?? this.spoken,
    );
  }
}