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
  const MaxMemory({required this.id, required this.content, required this.category, required this.createdAt, required this.updatedAt, required this.importance, required this.tags});
  factory MaxMemory.fromJson(Map<String, dynamic> json) { final now = DateTime.now(); return MaxMemory(id: json['id']?.toString() ?? '', content: json['content']?.toString() ?? json['value']?.toString() ?? '', category: json['category']?.toString() ?? json['type']?.toString() ?? 'general', createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? now, updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? now, importance: (json['importance'] as num?)?.toDouble() ?? 0.5, tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const []); }
  Map<String, dynamic> toJson() => {'id': id, 'content': content, 'category': category, 'createdAt': createdAt.toIso8601String(), 'updatedAt': updatedAt.toIso8601String(), 'importance': importance, 'tags': tags};
  String get value => content;
  String get key => id;
  String get type => category;
  MaxMemory copyWith({String? content, String? category, DateTime? updatedAt, double? importance, List<String>? tags}) => MaxMemory(id: id, content: content ?? this.content, category: category ?? this.category, createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt, importance: importance ?? this.importance, tags: tags ?? this.tags);
}

typedef MaxMemoryItem = MaxMemory;

class MaxMemoryService {
  MaxMemoryService({SharedPreferences? preferences}) : _preferences = preferences;
  static final MaxMemoryService instance = MaxMemoryService._();
  MaxMemoryService._();
  static const String _storageKey = 'max_memory_v2';
  SharedPreferences? _preferences;
  final List<MaxMemory> _memories = [];
  bool _initialized = false;
  Future<void> initialize() async { if (_initialized) return; _preferences ??= await SharedPreferences.getInstance(); final stored = _preferences!.getString(_storageKey); if (stored != null && stored.isNotEmpty) { try { final decoded = jsonDecode(stored); if (decoded is List) { _memories..clear()..addAll(decoded.whereType<Map>().map((e) => MaxMemory.fromJson(Map<String, dynamic>.from(e))).where((m) => m.content.trim().isNotEmpty)); } } catch (_) { _memories.clear(); } } _initialized = true; }
  List<MaxMemory> get memories { final result = List<MaxMemory>.from(_memories)..sort((a,b) => b.updatedAt.compareTo(a.updatedAt)); return List.unmodifiable(result); }
  Future<List<MaxMemory>> getMemories({String? userId}) async { await initialize(); return memories; }
  List<MaxMemory> get importantMemories { final result = _memories.where((m) => m.importance >= .7).toList()..sort((a,b) => b.importance.compareTo(a.importance)); return List.unmodifiable(result); }
  Future<MaxMemory?> save({required String content, String category='general', double importance=.5, List<String> tags=const []}) async { await initialize(); final normalized=content.trim(); if(normalized.isEmpty) return null; final i=_findSimilarMemory(normalized); if(i!=-1){ final old=_memories[i]; final updated=old.copyWith(updatedAt: DateTime.now(), importance: importance>old.importance?importance.clamp(0,1):old.importance, tags:_mergeTags(old.tags,tags)); _memories[i]=updated; await _persist(); return updated; } final now=DateTime.now(); final m=MaxMemory(id:now.microsecondsSinceEpoch.toString(),content:normalized,category:category.trim().isEmpty?'general':category.trim(),createdAt:now,updatedAt:now,importance:importance.clamp(0,1),tags:tags.map((e)=>e.trim().toLowerCase()).where((e)=>e.isNotEmpty).toSet().toList()); _memories.add(m); await _persist(); return m; }
  Future<MaxMemory?> saveMemory({String? content, String category='general', double importance=.5, List<String> tags=const [], String? userId, String? type, String? key, String? value}) => save(content: (content ?? value ?? key ?? '').trim(), category: type ?? category, importance: importance.toDouble().clamp(0,1), tags: tags);
  Future<void> saveConversationMemory({required String content,double importance=.6,List<String> tags=const ['conversation']}) async { await save(content:content,category:'conversation',importance:importance,tags:tags); }
  Future<void> saveVoiceMemory({required String content,double importance=.65,List<String> tags=const ['voice']}) async { await save(content:content,category:'voice',importance:importance,tags:tags); }
  Future<void> savePreference({required String content,List<String> tags=const ['preference']}) async { await save(content:content,category:'preference',importance:.9,tags:tags); }
  Future<void> saveImportantFact({required String content,List<String> tags=const ['important']}) async { await save(content:content,category:'important',importance:1,tags:tags); }
  List<MaxMemory> search(String query,{int limit=20}) { final q=query.trim().toLowerCase(); if(q.isEmpty)return memories.take(limit).toList(); final terms=q.split(RegExp(r'\s+')).where((e)=>e.length>=2).toSet(); final scored=<MapEntry<MaxMemory,double>>[]; for(final m in _memories){var s=0.0; final c=m.content.toLowerCase(), cat=m.category.toLowerCase(), t=m.tags.join(' ').toLowerCase(); for(final term in terms){if(c.contains(term))s+=3;if(cat.contains(term))s+=2;if(t.contains(term))s+=2.5;} if(s>0)scored.add(MapEntry(m,s+m.importance));} scored.sort((a,b)=>b.value.compareTo(a.value)); return scored.take(limit).map((e)=>e.key).toList(); }
  List<MaxMemory> relevantMemories(String q,{int limit=8}) { final r=search(q,limit:limit); return r.isNotEmpty?r:importantMemories.take(limit).toList(); }
  String buildMemoryContext(String q,{int limit=8}) => relevantMemories(q,limit:limit).map((m)=>'- ${m.content}').join('\n');
  Future<bool> update(String id,{String? content,String? category,double? importance,List<String>? tags}) async {await initialize();final i=_memories.indexWhere((m)=>m.id==id);if(i<0)return false;_memories[i]=_memories[i].copyWith(content:content,category:category,importance:importance,tags:tags,updatedAt:DateTime.now());await _persist();return true;}
  Future<bool> delete(String id) async {await initialize();final n=_memories.length;_memories.removeWhere((m)=>m.id==id);if(n==_memories.length)return false;await _persist();return true;}
  Future<bool> deleteMemory(String id)=>delete(id);
  Future<void> clear({bool keepImportant=true}) async {await initialize();if(keepImportant){_memories.removeWhere((m)=>m.importance<.9);}else{_memories.clear();}await _persist();}
  Future<void> clearAll({String? userId})=>clear(keepImportant:false);
  Future<void> clearConversationMemories() async {await initialize();_memories.removeWhere((m)=>m.category=='conversation'||m.tags.contains('conversation'));await _persist();}
  Future<void> clearVoiceMemories() async {await initialize();_memories.removeWhere((m)=>m.category=='voice'||m.tags.contains('voice'));await _persist();}
  Future<void> importMemories(List<Map<String,dynamic>> data) async {await initialize();for(final item in data){final m=MaxMemory.fromJson(item);if(m.content.trim().isEmpty)continue;final i=_memories.indexWhere((e)=>e.id==m.id);if(i<0)_memories.add(m);else if(m.updatedAt.isAfter(_memories[i].updatedAt))_memories[i]=m;}await _persist();}
  List<Map<String,dynamic>> exportMemories()=>_memories.map((m)=>m.toJson()).toList();
  int _findSimilarMemory(String c){final n=_normalize(c);for(var i=0;i<_memories.length;i++){final e=_normalize(_memories[i].content);if(e==n||_similarity(e,n)>=.92)return i;}return -1;}
  double _similarity(String a,String b){if(a.isEmpty||b.isEmpty)return 0;final x=a.split(' ').toSet(),y=b.split(' ').toSet(),u=x.union(y).length;return u==0?0:x.intersection(y).length/u;}
  String _normalize(String v)=>v.toLowerCase().replaceAll(RegExp(r'[^\w\s]'),'').replaceAll(RegExp(r'\s+'),' ').trim();
  List<String> _mergeTags(List<String>a,List<String>b)=>{...a,...b.map((e)=>e.trim().toLowerCase())}.where((e)=>e.isNotEmpty).toList();
  Future<void> _persist() async {_preferences ??= await SharedPreferences.getInstance();await _preferences!.setString(_storageKey,jsonEncode(_memories.map((m)=>m.toJson()).toList()));}
}
