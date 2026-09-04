import 'package:flutter/material.dart';

import '../services/max_memory_service.dart';



class MemoryProvider extends ChangeNotifier {



  final MaxMemoryService service;



  MemoryProvider({

    required this.service,

  });







  List<MaxMemoryItem> memories = [];



  bool loading = false;







  Future<void> load(

      String userId,

  ) async {



    loading = true;

    notifyListeners();



    memories = await service.getMemories(

      userId: userId,

    );



    loading = false;

    notifyListeners();


  }







  Future<void> addMemory({

    required String userId,

    required String type,

    required String key,

    required String value,

    int importance = 1,

  }) async {



    await service.saveMemory(

      userId: userId,

      type: type,

      key: key,

      value: value,

      importance: importance,

    );



    await load(

      userId,

    );

  }







  Future<void> delete(

      String id,

      String userId,

  ) async {



    await service.deleteMemory(

      id,

    );



    await load(

      userId,

    );

  }







  Future<void> clear(

      String userId,

  ) async {



    await service.clearAll(

      userId: userId,

    );



    await load(

      userId,

    );

  }





}