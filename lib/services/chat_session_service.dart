import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';



class ChatSessionService {



  final Uuid _uuid = const Uuid();





  String _sessionId = "";



  String get sessionId => _sessionId;







  void createSession(){



    _sessionId = _uuid.v4();


  }







  void resetSession(){



    _sessionId = "";


  }







  ChatMessage createSystemMessage(

      String text

  ){



    return ChatMessage(

      id:_uuid.v4(),

      text:text,

      isUser:false,

      createdAt:DateTime.now(),

    );


  }







}