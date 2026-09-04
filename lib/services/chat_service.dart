import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import 'max_ai_brain.dart';
import 'max_memory_service.dart';
import 'memory_filter.dart';



class ChatService {


  final MaxAIBrain brain;


  final MaxMemoryService memoryService =
      MaxMemoryService();


  final Uuid _uuid = const Uuid();





  ChatService({

    required this.brain,

  });







  Future<ChatMessage> sendMessage({

    required String message,

  }) async {



    final response = await brain.askMAX(

      message: message,

    );





    await _processMemory(

      message,

    );





    return ChatMessage(

      id: _uuid.v4(),

      text: response,

      isUser: false,

      createdAt: DateTime.now(),

      sources:

          _extractLinks(response),

      linkPreview:

          _findLink(response),

    );


  }








  ChatMessage createUserMessage({

    required String message,

    String? attachmentPath,

    String? attachmentType,

  }){


    return ChatMessage(

      id: _uuid.v4(),

      text: message,

      isUser: true,

      createdAt: DateTime.now(),

      attachmentPath:

          attachmentPath,

      attachmentType:

          attachmentType,

      linkPreview:

          _findLink(message),

    );


  }








  Future<void> _processMemory(

      String message

  ) async {



    if(!MemoryFilter.shouldRemember(message)){

      return;

    }




    final user =

        memoryService.client.auth.currentUser;



    if(user == null){

      return;

    }





    final exists =

        await memoryService.memoryExists(

          userId: user.id,

          value: message,

        );





    if(exists){

      return;

    }







    await memoryService.saveMemory(

      userId: user.id,

      type: "conversation",

      key: "user_statement",

      value: message,

      importance:

          MemoryFilter.importance(

            message,

          ),

    );



  }








  List<String> _extractLinks(

      String text

  ){



    final regex = RegExp(

      r'https?:\/\/[^\s]+',

    );





    return regex

        .allMatches(text)

        .map(

          (match)=>match.group(0)!,

        )

        .toList();


  }








  String? _findLink(

      String text

  ){



    final links = _extractLinks(text);



    if(links.isEmpty){

      return null;

    }



    return links.first;


  }





}