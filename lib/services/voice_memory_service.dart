import 'services/max_memory_service.dart';



class VoiceMemoryService {



  final MaxMemoryService memoryService;



  VoiceMemoryService({

    required this.memoryService,

  });







  Future<void> processVoiceText({

    required String userId,

    required String text,

  }) async {



    if(text.trim().isEmpty){

      return;

    }





    await memoryService.saveMemory(

      userId:userId,

      type:"voice",

      key:"voice_conversation",

      value:text,

      importance:2,

    );


  }







}