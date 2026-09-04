import 'max_memory_service.dart';



class MaxMemorySearchService {



  final MaxMemoryService memoryService;



  MaxMemorySearchService({

    required this.memoryService,

  });







  Future<List<MaxMemoryItem>> search({

    required String userId,

    required String query,

  }) async {



    final memories = await memoryService.getMemories(

      userId: userId,

    );



    final search = query.toLowerCase();



    return memories.where(

      (memory){



        return memory.key

                .toLowerCase()

                .contains(search) ||

            memory.value

                .toLowerCase()

                .contains(search);

      },

    ).toList();

  }







  Future<List<MaxMemoryItem>> important({

    required String userId,

  }) async {



    final memories = await memoryService.getMemories(

      userId: userId,

    );



    memories.sort(

      (a,b) => b.importance.compareTo(

        a.importance,

      ),

    );



    return memories;

  }

}