class MindResponse {
  final String message;

  final bool canContinue;

  final bool speak;

  final bool saveMemory;

  final bool shouldSaveToSupabase;

  final bool requiresCorrection;

  const MindResponse({
    required this.message,
    this.canContinue = true,
    this.speak = true,
    this.saveMemory = true,
    this.shouldSaveToSupabase = true,
    this.requiresCorrection = false,
  });
}