import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/max_memory_analyzer.dart';
import '../services/max_memory_service.dart';
import '../services/max_voice_memory_service.dart';
import '../services/max_voice_service.dart';

final maxVoiceProvider = Provider<MaxVoiceService>((ref) {
  final memory = MaxMemoryService.instance;
  final voiceMemory = MaxVoiceMemoryService(memoryService: memory, analyzer: MaxMemoryAnalyzer());
  return MaxVoiceService(memoryService: voiceMemory);
});
