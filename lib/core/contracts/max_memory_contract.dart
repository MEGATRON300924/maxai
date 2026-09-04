import '../../services/max_memory_service.dart';

/// Stable memory boundary shared by MAX AI, MAX Voice, and future surfaces.
abstract interface class MaxMemoryContract {
  Future<void> initialize();
  List<MaxMemory> get memories;
  List<MaxMemory> get importantMemories;
  Future<MaxMemory?> save({
    required String content,
    String category,
    double importance,
    List<String> tags,
  });
  List<MaxMemory> relevantMemories(String query, {int limit});
  String buildMemoryContext(String query, {int limit});
  Future<bool> update(String id, {String? content, String? category, double? importance, List<String>? tags});
  Future<bool> delete(String id);
  Future<void> clear({bool keepImportant});
  Future<void> importMemories(List<Map<String, dynamic>> data);
  List<Map<String, dynamic>> exportMemories();
}

/// Adapter keeps the concrete local store replaceable by cloud memory later.
class LocalMaxMemoryAdapter implements MaxMemoryContract {
  LocalMaxMemoryAdapter({MaxMemoryService? service}) : _service = service ?? MaxMemoryService.instance;

  final MaxMemoryService _service;

  @override
  Future<void> initialize() => _service.initialize();

  @override
  List<MaxMemory> get memories => _service.memories;

  @override
  List<MaxMemory> get importantMemories => _service.importantMemories;

  @override
  Future<MaxMemory?> save({required String content, String category = 'general', double importance = 0.5, List<String> tags = const []}) =>
      _service.save(content: content, category: category, importance: importance, tags: tags);

  @override
  List<MaxMemory> relevantMemories(String query, {int limit = 8}) => _service.relevantMemories(query, limit: limit);

  @override
  String buildMemoryContext(String query, {int limit = 8}) => _service.buildMemoryContext(query, limit: limit);

  @override
  Future<bool> update(String id, {String? content, String? category, double? importance, List<String>? tags}) =>
      _service.update(id, content: content, category: category, importance: importance, tags: tags);

  @override
  Future<bool> delete(String id) => _service.delete(id);

  @override
  Future<void> clear({bool keepImportant = true}) => _service.clear(keepImportant: keepImportant);

  @override
  Future<void> importMemories(List<Map<String, dynamic>> data) => _service.importMemories(data);

  @override
  List<Map<String, dynamic>> exportMemories() => _service.exportMemories();
}
