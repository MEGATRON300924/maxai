import 'max_memory_analyzer.dart';

import 'max_memory_service.dart';



class MaxVoiceMemoryService {



  final MaxMemoryService memoryService;

  final MaxMemoryAnalyzer analyzer;



  MaxVoiceMemoryService({

    required this.memoryService,

    required this.analyzer,

  });







  Future<void> processVoiceText({

    required String userId,

    required String text,

  }) async {



    if(!analyzer.shouldRemember(text)){

      return;

    }



    await memoryService.saveMemory(

      userId: userId,

      type: "voice",

      key: analyzer.generateKey(

        text,

      ),

      value: text,

      importance: analyzer.calculateImportance(

        text,

      ),

    );

  }







}