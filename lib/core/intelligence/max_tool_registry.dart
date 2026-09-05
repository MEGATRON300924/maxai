import 'max_intent.dart';
import 'max_tool.dart';

class MaxToolRegistry {
  MaxToolRegistry([Iterable<MaxTool> tools = const []]) {
    for (final tool in tools) {
      register(tool);
    }
  }

  final Map<String, MaxTool> _tools = <String, MaxTool>{};

  void register(MaxTool tool) => _tools[tool.id] = tool;

  void unregister(String id) => _tools.remove(id);

  MaxTool? get(String id) => _tools[id];

  MaxTool? forIntent(MaxIntent intent) {
    for (final tool in _tools.values) {
      if (tool.supportedIntents.contains(intent)) return tool;
    }
    return null;
  }

  List<MaxTool> get tools => List.unmodifiable(_tools.values);
}
