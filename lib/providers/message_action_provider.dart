import 'package:flutter/material.dart';

import '../services/message_action_service.dart';



class MessageActionProvider extends ChangeNotifier {


  final MessageActionService service;



  MessageActionProvider({

    required this.service,

  });





  String? _copiedMessage;



  String? get copiedMessage => _copiedMessage;







  Future<void> copyMessage(

      String text

  ) async {



    await service.copy(

      text,

    );



    _copiedMessage = text;


    notifyListeners();



  }








  Future<void> speakMessage(

      String text

  ) async {



    await service.readAloud(

      text,

    );


  }








  Future<void> stopSpeaking() async {



    await service.stopVoice();


  }







  void clearCopied(){



    _copiedMessage = null;


    notifyListeners();


  }




}