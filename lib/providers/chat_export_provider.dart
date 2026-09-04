import 'package:flutter/material.dart';

import '../models/chat_message.dart';

import '../services/chat_export_service.dart';



class ChatExportProvider extends ChangeNotifier {



  final ChatExportService service;



  ChatExportProvider({

    required this.service,

  });







  String? _exportedData;



  String? get exportedData => _exportedData;








  void exportChat(

      List<ChatMessage> messages

  ){



    _exportedData = service.exportConversation(

      messages,

    );



    notifyListeners();


  }







  void clear(){



    _exportedData = null;


    notifyListeners();


  }





}