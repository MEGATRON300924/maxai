import 'package:flutter_tts/flutter_tts.dart';

import 'package:speech_to_text/speech_to_text.dart';

import 'max_voice_memory_service.dart';



class MaxVoiceService {



  final FlutterTts _tts = FlutterTts();

  final SpeechToText _speech = SpeechToText();

  final MaxVoiceMemoryService memoryService;



  bool listening = false;



  MaxVoiceService({

    required this.memoryService,

  });







  Future<void> initialize() async {



    await _tts.setLanguage(

      "en-US",

    );



    await _tts.setSpeechRate(

      0.5,

    );



    await _speech.initialize();

  }







  Future<void> speak(

      String text,

  ) async {



    await _tts.stop();



    await _tts.speak(

      text,

    );

  }







  Future<void> stopSpeaking() async {



    await _tts.stop();

  }







  Future<String?> listen({

    required String userId,

  }) async {



    if(listening){

      return null;

    }



    listening = true;



    String result = "";



    await _speech.listen(

      onResult: (speechResult){



        result = speechResult.recognizedWords;



      },

    );





    while(_speech.isListening){

      await Future.delayed(

        const Duration(

          milliseconds: 200,

        ),

      );

    }



    listening = false;



    if(result.trim().isNotEmpty){



      await memoryService.processVoiceText(

        userId: userId,

        text: result,

      );



      return result;

    }



    return null;

  }







  Future<void> cancelListening() async {



    await _speech.stop();



    listening = false;

  }







  Future<void> setVoiceSettings({

    double speed = 0.5,

    double pitch = 1,

  }) async {



    await _tts.setSpeechRate(

      speed,

    );



    await _tts.setPitch(

      pitch,

    );

  }







  Future<void> dispose() async {



    await _tts.stop();

    await _speech.stop();

  }

}