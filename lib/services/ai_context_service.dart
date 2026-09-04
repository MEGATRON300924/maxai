import 'conversation_context_service.dart';

import 'max_context_memory_service.dart';

import '../models/chat_message.dart';



class AIContextService {



  final ConversationContextService conversationService;

  final MaxContextMemoryService memoryService;



  AIContextService({

    required this.conversationService,

    required this.memoryService,

  });







  Future<String> buildContext({

    required String userId,

    required String query,

    required List<ChatMessage> messages,

  }) async {



    final memories = await memoryService.getRelevantMemory(

      userId:userId,

      query:query,

    );





    final memoryPrompt = memoryService.buildMemoryPrompt(

      memories,

    );





    final conversation = conversationService.buildPrompt(

      messages,

    );





    return """

USER MEMORY:

$memoryPrompt


CONVERSATION:

$conversation

""";


  }







}