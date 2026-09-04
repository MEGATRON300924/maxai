import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MaxMemory {
  final String id;
  final String content;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double importance;
  final List<String> tags;

  const MaxMemory({
    required this.id,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.importance,
    required this.tags,
  });

  factory MaxMemory.fromJson(Map<String, dynamic> json) {
    return MaxMemory(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      category: json['category']?.toString() ?? 'general',
      createdAt: DateTime.tryParse(
            json['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
            json['updatedAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      importance: (json['importance'] as num?)?.toDouble() ?? 0.5,
      tags: List<String>.from(
        json['tags'] ?? const <String>[],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'importance': importance,
      'tags': tags,
    };
  }

  MaxMemory copyWith({
    String? content,
    String? category,
    DateTime? updatedAt,
    double? importance,
    List<String>? tags,
  }) {
    return MaxMemory(
      id: id,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      importance: importance ?? this.importance,
      tags: tags ?? this.tags,
    );
  }
}

class MaxMemoryService {
  MaxMemoryService._();

  static final MaxMemoryService instance = MaxMemoryService._();

  static const String _storageKey = 'max_memory_v2';

  SharedPreferences? _preferences;
  final List<MaxMemory> _memories = [];

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _preferences = await SharedPreferences.getInstance();

    final stored = _preferences?.getString(_storageKey);

    if (stored != null && stored.isNotEmpty) {
      try {
        final decoded = jsonDecode(stored);

        if (decoded is List) {
          _memories
            ..clear()
            ..addAll(
              decoded
                  .whereType<Map>()
                  .map(
                    (item) => MaxMemory.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .where((memory) => memory.content.trim().isNotEmpty),
            );
        }
      } catch (_) {
        _memories.clear();
      }
    }

    _initialized = true;
  }

  List<MaxMemory> get memories {
    final result = List<MaxMemory>.from(_memories);
    result.sort(
      (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );
    return List.unmodifiable(result);
  }

  List<MaxMemory> get importantMemories {
    final result = _memories
        .where((memory) => memory.importance >= 0.7)
        .toList();

    result.sort(
      (a, b) => b.importance.compareTo(a.importance),
    );

    return List.unmodifiable(result);
  }

  Future<MaxMemory?> save({
    required String content,
    String category = 'general',
    double importance = 0.5,
    List<String> tags = const [],
  }) async {
    await initialize();

    final normalizedContent = content.trim();

    if (normalizedContent.isEmpty) return null;

    final existingIndex = _findSimilarMemory(normalizedContent);

    if (existingIndex != -1) {
      final existing = _memories[existingIndex];

      final updated = existing.copyWith(
        updatedAt: DateTime.now(),
        importance: importance > existing.importance
            ? importance.clamp(0.0, 1.0)
            : existing.importance,
        tags: _mergeTags(existing.tags, tags),
      );

      _memories[existingIndex] = updated;
      await _persist();

      return updated;
    }

    final now = DateTime.now();

    final memory = MaxMemory(
      id: '${now.microsecondsSinceEpoch}',
      content: normalizedContent,
      category: category.trim().isEmpty ? 'general' : category.trim(),
      createdAt: now,
      updatedAt: now,
      importance: importance.clamp(0.0, 1.0),
      tags: tags
          .map((tag) => tag.trim().toLowerCase())
          .where((tag) => tag.isNotEmpty)
          .toSet()
          .toList(),
    );

    _memories.add(memory);
    await _persist();

    return memory;
  }

  Future<void> saveConversationMemory({
    required String content,
    double importance = 0.6,
    List<String> tags = const ['conversation'],
  }) async {
    await save(
      content: content,
      category: 'conversation',
      importance: importance,
      tags: tags,
    );
  }

  Future<void> saveVoiceMemory({
    required String content,
    double importance = 0.65,
    List<String> tags = const ['voice'],
  }) async {
    await save(
      content: content,
      category: 'voice',
      importance: importance,
      tags: tags,
    );
  }

  Future<void> savePreference({
    required String content,
    List<String> tags = const ['preference'],
  }) async {
    await save(
      content: content,
      category: 'preference',
      importance: 0.9,
      tags: tags,
    );
  }

  Future<void> saveImportantFact({
    required String content,
    List<String> tags = const ['important'],
  }) async {
    await save(
      content: content,
      category: 'important',
      importance: 1.0,
      tags: tags,
    );
  }

  List<MaxMemory> search(
    String query, {
    int limit = 20,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return memories.take(limit).toList();
    }

    final terms = normalizedQuery
        .split(RegExp(r'\s+'))
        .where((term) => term.length >= 2)
        .toSet();

    final scored = <_MemoryScore>[];

    for (final memory in _memories) {
      final content = memory.content.toLowerCase();
      final category = memory.category.toLowerCase();
      final tags = memory.tags.join(' ').toLowerCase();

      var score = 0.0;

      for (final term in terms) {
        if (content.contains(term)) {
          score += 3.0;
        }

        if (category.contains(term)) {
          score += 2.0;
        }

        if (tags.contains(term)) {
          score += 2.5;
        }
      }

      if (score > 0) {
        score += memory.importance;
        scored.add(
          _MemoryScore(
            memory: memory,
            score: score,
          ),
        );
      }
    }

    scored.sort(
      (a, b) => b.score.compareTo(a.score),
    );

    return scored
        .take(limit)
        .map((item) => item.memory)
        .toList();
  }

  List<MaxMemory> relevantMemories(
    String query, {
    int limit = 8,
  }) {
    final results = search(
      query,
      limit: limit,
    );

    if (results.isNotEmpty) {
      return results;
    }

    return importantMemories.take(limit).toList();
  }

  String buildMemoryContext(
    String query, {
    int limit = 8,
  }) {
    final relevant = relevantMemories(
      query,
      limit: limit,
    );

    if (relevant.isEmpty) return '';

    return relevant
        .map(
          (memory) => '- ${memory.content}',
        )
        .join('\n');
  }

  Future<bool> update(
    String id, {
    String? content,
    String? category,
    double? importance,
    List<String>? tags,
  }) async {
    await initialize();

    final index = _memories.indexWhere(
      (memory) => memory.id == id,
    );

    if (index == -1) return false;

    final updated = _memories[index].copyWith(
      content: content,
      category: category,
      importance: importance,
      tags: tags,
      updatedAt: DateTime.now(),
    );

    _memories[index] = updated;
    await _persist();

    return true;
  }

  Future<bool> delete(String id) async {
    await initialize();

    final previousLength = _memories.length;

    _memories.removeWhere(
      (memory) => memory.id == id,
    );

    if (_memories.length == previousLength) {
      return false;
    }

    await _persist();
    return true;
  }

  Future<void> clear({
    bool keepImportant = true,
  }) async {
    await initialize();

    if (keepImportant) {
      _memories.removeWhere(
        (memory) => memory.importance < 0.9,
      );
    } else {
      _memories.clear();
    }

    await _persist();
  }

  Future<void> clearConversationMemories() async {
    await initialize();

    _memories.removeWhere(
      (memory) => memory.category == 'conversation',
    );

    await _persist();
  }

  Future<void> clearVoiceMemories() async {
    await initialize();

    _memories.removeWhere(
      (memory) => memory.category == 'voice',
    );

    await _persist();
  }

  Map<String, int> getCategoryCounts() {
    final counts = <String, int>{};

    for (final memory in _memories) {
      counts[memory.category] =
          (counts[memory.category] ?? 0) + 1;
    }

    return Map.unmodifiable(counts);
  }

  Future<void> importMemories(
    List<Map<String, dynamic>> data,
  ) async {
    await initialize();

    for (final item in data) {
      try {
        final memory = MaxMemory.fromJson(item);

        if (memory.content.trim().isEmpty) continue;

        final existingIndex = _memories.indexWhere(
          (existing) => existing.id == memory.id,
        );

        if (existingIndex == -1) {
          _memories.add(memory);
        } else if (
            memory.updatedAt.isAfter(
              _memories[existingIndex].updatedAt,
            )) {
          _memories[existingIndex] = memory;
        }
      } catch (_) {}
    }

    await _persist();
  }

  List<Map<String, dynamic>> exportMemories() {
    return _memories
        .map((memory) => memory.toJson())
        .toList();
  }

  int _findSimilarMemory(String content) {
    final normalized = _normalize(content);

    for (var i = 0; i < _memories.length; i++) {
      final existing = _normalize(
        _memories[i].content,
      );

      if (existing == normalized) {
        return i;
      }

      if (_similarity(existing, normalized) >= 0.92) {
        return i;
      }
    }

    return -1;
  }

  double _similarity(
    String first,
    String second,
  ) {
    if (first.isEmpty || second.isEmpty) {
      return 0;
    }

    if (first == second) return 1;

    final firstWords = first.split(' ').toSet();
    final secondWords = second.split(' ').toSet();

    if (firstWords.isEmpty || secondWords.isEmpty) {
      return 0;
    }

    final intersection =
        firstWords.intersection(secondWords).length;

    final union =
        firstWords.union(secondWords).length;

    return union == 0 ? 0 : intersection / union;
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<String> _mergeTags(
    List<String> first,
    List<String> second,
  ) {
    return {
      ...first,
      ...second.map(
        (tag) => tag.trim().toLowerCase(),
      ),
    }.where((tag) => tag.isNotEmpty).toList();
  }

  Future<void> _persist() async {
    final preferences = _preferences ??
        await SharedPreferences.getInstance();

    _preferences = preferences;

    await preferences.setString(
      _storageKey,
      jsonEncode(
        _memories
            .map((memory) => memory.toJson())
            .toList(),
      ),
    );
  }
}

class _MemoryScore {
  final MaxMemory memory;
  final double score;

  const _MemoryScore({
    required this.memory,
    required this.score,
  });
}