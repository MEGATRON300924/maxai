class SuggestedPrompt {
  const SuggestedPrompt({required this.text, this.id});

  final String text;
  final String? id;

  SuggestedPrompt copyWith({String? text, String? id}) => SuggestedPrompt(text: text ?? this.text, id: id ?? this.id);
}
