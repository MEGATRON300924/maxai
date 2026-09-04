import 'package:flutter/material.dart';

import '../services/chat_state_service.dart';



class ChatStateProvider extends ChangeNotifier {



  final ChatStateService service;



  ChatStateProvider({

    required this.service,

  });







  bool get isGenerating => service.isGenerating;







  void start(){



    service.startGenerating();



    notifyListeners();


  }







  void stop(){



    service.stopGenerating();



    notifyListeners();


  }







  void reset(){



    service.reset();



    notifyListeners();


  }





}