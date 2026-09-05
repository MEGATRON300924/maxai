import 'max_intent.dart';
import 'max_tool.dart';
import '../../services/max_memory_service.dart';

/// Native memory capability used by MAX before falling back to Gemini.
class MaxMemoryTool implements MaxTool {
  MaxMemoryTool({MaxMemoryService? memory})
      : _memory = memory ?? MaxMemoryService.instance;

  final MaxMemoryService _memory;

  @override
  String get id => 'memory';

  @override
  Set<MaxIntent> get supportedIntents => const {MaxIntent.memory};

  @override
  Future<MaxToolResult> execute(MaxToolRequest request) async {
    await _memory.initialize();
    final message = request.message.trim();
    final lower = message.toLowerCase();

    if (_isRecall(lower)) {
      final memories = _memory.relevantMemories(message, limit: 8);
      if (memories.isEmpty) {
        return const MaxToolResult.success(
          text: "I don't have any saved memories about that yet.",
        );
      }

      final lines = memories.map((memory) => '• ${memory.content}').join('\n');
      return MaxToolResult.success(
        text: 'Here is what I remember:\n$lines',
        data: {'count': memories.length},
      );
    }

    if (_isForget(lower)) {
      final query = _stripCommand(message, [
        'forget that',
        'forget this',
        'forget ',
      ]);
      final matches = _memory.search(query, limit: 1);
      if (matches.isEmpty) {
        return const MaxToolResult.success(
          text: "I couldn't find a saved memory matching that.",
        );
      }

      final deleted = await _memory.delete(matches.first.id);
      return MaxToolResult.success(
        text: deleted
            ? 'Done. I forgot that memory.'
            : "I couldn't remove that memory.",
        data: {'deleted': deleted, 'id': matches.first.id},
      );
    }

    final content = _stripCommand(message, [
      'remember that',
      'remember this',
      'save this',
    ]);
    if (content.isEmpty) {
      return const MaxToolResult.failure(
        'Tell me what you want me to remember.',
      );
    }

    final memory = await _memory.save(
      content: content,
      category: 'important',
      importance: 1,
      tags: const ['max-tool'],
    );

    if (memory == null) {
      return const MaxToolResult.failure('I could not save that memory.');
    }

    return MaxToolResult.success(
      text: 'Got it. I’ll remember that.',
      data: {'id': memory.id},
    );
  }

  bool _isRecall(String message) =>
      message.contains('what do you remember') ||
      message.contains('my memories') ||
      message.contains('what do you know about me');

  bool _isForget(String message) =>
      message.startsWith('forget that') ||
      message.startsWith('forget this') ||
      message.startsWith('forget ');

  String _stripCommand(String message, List<String> commands) {
    var value = message.trim();
    for (final command in commands) {
      if (value.toLowerCase().startsWith(command)) {
        value = value.substring(command.length).trim();
        break;
      }
    }
    if (value.endsWith('.')) value = value.substring(0, value.length - 1).trim();
    return value;
  }
}
