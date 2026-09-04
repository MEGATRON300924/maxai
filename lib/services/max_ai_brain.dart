import 'package:supabase_flutter/supabase_flutter.dart';

import 'gemini_service.dart';

import 'max_memory_service.dart';

import 'max_memory_model.dart';





class MaxAIBrain {



  final GeminiService gemini;


  final MaxMemoryService memoryService =

      MaxMemoryService();





  MaxAIBrain({

    required this.gemini,

  });







  Future<String> askMAX({

    required String message,

  }) async {



    final user =

        Supabase.instance.client.auth.currentUser;





    if(user == null){


      return "Please sign in to use MAX.";

    }







    final memories = await memoryService

        .getMemories(

          user.id,

        );







    final profile = await _getProfile(

      user.id,

    );








    return await gemini.sendMessage(

      message:message,

      memories:memories,

      userProfile:profile,

    );



  }








  Future<Map<String,dynamic>> _getProfile(

      String userId

  ) async {



    final response = await Supabase

        .instance

        .client

        .from('user_profiles')

        .select()

        .eq(

          'id',

          userId,

        )

        .maybeSingle();





    return response ?? {};



  }



}