import 'package:flutter/material.dart';

import 'max_context.dart';



class MaxContextProvider extends ChangeNotifier {


  MaxContext _context = const MaxContext(

    currentScreen: "unknown",

  );



  MaxContext get context =>
      _context;



  void updateScreen(
    String screen,
  ) {

    _context =
        _context.copyWith(

      currentScreen:
          screen,

    );


    notifyListeners();

  }



  void updateUser({

    String? name,

    String? plan,

  }) {

    _context =
        _context.copyWith(

      userName:
          name,

      subscriptionPlan:
          plan,

    );


    notifyListeners();

  }



  void updateState(
    Map<String,dynamic> state,
  ) {

    _context =
        _context.copyWith(

      appState:
          state,

    );


    notifyListeners();

  }



  void setVoiceActive(
    bool value,
  ) {

    _context =
        _context.copyWith(

      voiceActive:
          value,

    );


    notifyListeners();

  }


}