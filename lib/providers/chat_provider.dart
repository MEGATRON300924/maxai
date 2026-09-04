import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/chat_service.dart';



class ChatProvider extends ChangeNotifier {


  final ChatService chatService;


  ChatProvider({

    required this.chatService,

  });





  final List<ChatMessage> _messages = [];



  List<ChatMessage> get messages => _messages;





  bool _isTyping = false;


  bool get isTyping => _isTyping;





  Future<void> sendMessage({

    required String message,

    String? attachmentPath,

    String? attachmentType,

  }) async {



    if(message.trim().isEmpty && attachmentPath == null){

      return;

    }




    final userMessage = chatService.createUserMessage(

      message: message,

      attachmentPath: attachmentPath,

      attachmentType: attachmentType,

    );





    _messages.add(

      userMessage,

    );


    notifyListeners();





    _setTyping(true);





    try {



      final response = await chatService.sendMessage(

        message: message,

      );





      _messages.add(

        response,

      );





    } catch(e) {



      _messages.add(

        ChatMessage(

          id: DateTime.now()

              .millisecondsSinceEpoch

              .toString(),

          text:

          "I couldn't complete that request right now.",

          isUser:false,

          createdAt:DateTime.now(),

        ),

      );


    }





    _setTyping(false);


  }








  void updateMessage({

    required String id,

    required ChatMessage message,

  }){



    final index = _messages.indexWhere(

      (item)=>item.id == id,

    );





    if(index == -1){

      return;

    }





    _messages[index] = message;


    notifyListeners();


  }









  void copyMessage(

      String id

  ){



    final message = _findMessage(id);



    if(message == null){

      return;

    }





    updateMessage(

      id:id,

      message:

      message.copyWith(

        isCopied:true,

      ),

    );


  }








  void likeMessage(

      String id

  ){



    final message = _findMessage(id);



    if(message == null){

      return;

    }





    updateMessage(

      id:id,

      message:

      message.copyWith(

        isLiked:true,

        isDisliked:false,

      ),

    );


  }









  void dislikeMessage(

      String id

  ){



    final message = _findMessage(id);



    if(message == null){

      return;

    }





    updateMessage(

      id:id,

      message:

      message.copyWith(

        isLiked:false,

        isDisliked:true,

      ),

    );


  }









  void toggleVoicePlayback(

      String id

  ){



    final message = _findMessage(id);



    if(message == null){

      return;

    }





    updateMessage(

      id:id,

      message:

      message.copyWith(

        isVoicePlaying:

        !message.isVoicePlaying,

      ),

    );


  }









  void removeMessage(

      String id

  ){



    _messages.removeWhere(

      (message)=>message.id == id,

    );


    notifyListeners();


  }









  void clearChat(){



    _messages.clear();


    notifyListeners();


  }








  ChatMessage? _findMessage(

      String id

  ){



    try {



      return _messages.firstWhere(

        (message)=>message.id == id,

      );



    } catch(_){



      return null;


    }



  }








  void _setTyping(

      bool value

  ){



    _isTyping = value;


    notifyListeners();


  }




}