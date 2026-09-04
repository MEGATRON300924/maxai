import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/conversation_message.dart';
import '../models/mind_response.dart';
import '../services/max_mind_service.dart';
import '../services/max_voice_service.dart';


class OnboardingController
    extends StateNotifier<List<ConversationMessage>> {


  final MaxMindService maxMind;

  final MaxVoiceService voice;


  OnboardingController({

    required this.maxMind,

    required this.voice,

  }) : super([]);



  Future<void> startConversation() async {


    final messages = [

      ConversationMessage(

        text: "Hi, I'm MAX.",

        fromMax: true,

        createdAt: DateTime.now(),

        spoken: true,

      ),



      ConversationMessage(

        text: "Welcome to The MAX AI Ecosystem.",

        fromMax: true,

        createdAt: DateTime.now(),

        spoken: true,

      ),



      ConversationMessage(

        text: "What name should I use?",

        fromMax: true,

        createdAt: DateTime.now(),

        spoken: true,

      ),

    ];


    state = messages;


    for (final message in messages) {

      if (message.spoken) {

        await voice.speak(
          message.text,
        );

      }

    }

  }




  Future<MindResponse> handleName(
    String name,
  ) async {


    final response =
        maxMind.onboardingName(name);



    state = [

      ...state,


      ConversationMessage(

        text: name,

        fromMax: false,

        createdAt: DateTime.now(),

      ),



      ConversationMessage(

        text: response.message,

        fromMax: true,

        createdAt: DateTime.now(),

        spoken: response.speak,

      ),

    ];



    if (response.speak) {

      await voice.speak(
        response.message,
      );

    }


    return response;

  }

}