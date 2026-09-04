import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/max_voice_service.dart';


final maxVoiceProvider = Provider<MaxVoiceService>((ref) {

  return MaxVoiceService();

});