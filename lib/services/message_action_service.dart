import 'package:flutter/services.dart';

import 'max_voice_service.dart';



class MessageActionService {


  final MaxVoiceService voiceService;



  MessageActionService({

    required this.voiceService,

  });







  Future<void> copy(

      String text

  ) async {



    await Clipboard.setData(

      ClipboardData(

        text:text,

      ),

    );


  }








  Future<void> readAloud(

      String text

  ) async {



    await voiceService.speak(

      text,

    );


  }







  Future<void> stopVoice() async {



    await voiceService.stop();


  }







  String shareText(

      String text

  ){



    return text;


  }





}