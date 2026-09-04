import 'package:flutter/material.dart';

import '../models/chat_message.dart';

import '../services/message_action_service.dart';



class ChatActionsProvider extends ChangeNotifier {



  final MessageActionService actionService;



  ChatActionsProvider({

    required this.actionService,

  });







  Future<void> copyMessage(

      ChatMessage message

  ) async {



    await actionService.copy(

      message.text,

    );





    notifyListeners();


  }









  Future<void> speakMessage(

      ChatMessage message

  ) async {



    await actionService.readAloud(

      message.text,

    );





    notifyListeners();


  }








  Future<void> stopVoice() async {



    await actionService.stopVoice();



    notifyListeners();


  }








  ChatMessage like(

      ChatMessage message

  ){



    return message.copyWith(

      isLiked:true,

      isDisliked:false,

    );


  }








  ChatMessage dislike(

      ChatMessage message

  ){



    return message.copyWith(

      isLiked:false,

      isDisliked:true,

    );


  }







}