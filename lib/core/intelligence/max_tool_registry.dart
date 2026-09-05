import 'max_intent.dart';
import 'max_tool.dart';

/// Registry for MAX capability tools.
class MaxToolRegistry {
  MaxToolRegistry([Iterable<MaxTool> tools = const <MaxTool>[]]) {
    registerAll(tools);
  }

  final Map<String, MaxTool> _tools = <String, MaxTool>{};

  void register(MaxTool tool) {
    final id = tool.id.trim();
    if (id.isEmpty) {
      throw ArgumentError.value(tool.id, 'tool.id', 'Tool id cannot be empty.');
    }
    _tools[id] = tool;
  }

  void registerAll(Iterable<MaxTool> tools) {
    for (final tool in tools) {
      register(tool);
    }
  }

  MaxTool? unregister(String id) => _tools.remove(id);

  MaxTool? get(String id) => _tools[id];

  bool contains(String id) => _tools.containsKey(id);

  MaxTool? forIntent(MaxIntent intent) {
    for (final tool in _tools.values) {
      if (tool.supportedIntents.contains(intent)) return tool;
    }
    return null;
  }

  List<MaxTool> forIntentAll(MaxIntent intent) {
    return List<MaxTool>.unmodifiable(
      _tools.values.where((tool) => tool.supportedIntents.contains(intent)),
    );
  }

  void clear() => _tools.clear();

  List<MaxTool> get tools => List<MaxTool>.unmodifiable(_tools.values);

  int get length => _tools.length;
  bool get isEmpty => _tools.isEmpty;
  bool get isNotEmpty => _tools.isNotEmpty;
}
