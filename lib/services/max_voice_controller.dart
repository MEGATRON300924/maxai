import 'package:flutter/material.dart';


enum MaxVoiceState {

  idle,

  listening,

  thinking,

  speaking,

}





class MaxVoiceController extends ChangeNotifier {


  MaxVoiceController._();



  static final MaxVoiceController instance =

      MaxVoiceController._();




  MaxVoiceState _state =

      MaxVoiceState.idle;



  MaxVoiceState get state =>

      _state;





  bool get listening =>

      _state == MaxVoiceState.listening;





  bool get speaking =>

      _state == MaxVoiceState.speaking;





  Future<void> startSession() async {



    _state =

        MaxVoiceState.listening;



    notifyListeners();



    // Connects to native MAX Wake Engine v2.0

    // Kotlin foreground service communicates here

    

  }







  Future<void> stopSession() async {



    _state =

        MaxVoiceState.idle;



    notifyListeners();


  }







  void setThinking(){



    _state =

        MaxVoiceState.thinking;



    notifyListeners();


  }







  void setSpeaking(){



    _state =

        MaxVoiceState.speaking;



    notifyListeners();


  }







  void reset(){



    _state =

        MaxVoiceState.idle;



    notifyListeners();


  }


}