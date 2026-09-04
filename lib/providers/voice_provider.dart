import 'package:flutter/material.dart';

import '../services/max_voice_service.dart';



class VoiceProvider extends ChangeNotifier {


  final MaxVoiceService voiceService;



  VoiceProvider({

    required this.voiceService,

  });





  bool _isSpeaking = false;



  bool get isSpeaking => _isSpeaking;







  Future<void> speak(

      String text

  ) async {



    _isSpeaking = true;


    notifyListeners();





    try {



      await voiceService.speak(

        text,

      );



    } finally {



      _isSpeaking = false;


      notifyListeners();



    }



  }








  Future<void> stop() async {



    await voiceService.stop();



    _isSpeaking = false;


    notifyListeners();


  }







  Future<void> pause() async {



    await voiceService.pause();


  }





}