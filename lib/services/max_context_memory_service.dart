import 'max_memory_service.dart';



class MaxContextMemoryService {



  final MaxMemoryService memoryService;



  MaxContextMemoryService({

    required this.memoryService,

  });







  Future<List<Map<String,dynamic>>> getRelevantMemory({

    required String userId,

    required String query,

  }) async {



    final memories = await memoryService.getMemories(

      userId:userId,

    );





    return memories.where(

      (memory){



        final value = memory.value.toLowerCase();

        final search = query.toLowerCase();





        return value.contains(

          search,

        );



      },

    ).map(

      (memory)=>{

        "key":memory.key,

        "value":memory.value,

        "type":memory.type,

        "importance":memory.importance,

      },

    ).toList();


  }








  String buildMemoryPrompt(

      List<Map<String,dynamic>> memories

  ){



    if(memories.isEmpty){

      return "";

    }





    return memories.map(

      (memory)=>

      "${memory["key"]}: ${memory["value"]}",

    ).join("\n");


  }







}