import 'package:flutter/material.dart';

import '../models/chat_message.dart';

import '../services/chat_storage_service.dart';



class ChatHistoryProvider extends ChangeNotifier {



  final ChatStorageService storageService;



  ChatHistoryProvider({

    required this.storageService,

  });







  final List<ChatMessage> _messages = [];



  List<ChatMessage> get messages => _messages;







  bool _loaded = false;



  bool get loaded => _loaded;







  Future<void> loadHistory() async {



    final saved = await storageService.loadMessages();



    _messages.clear();



    _messages.addAll(

      saved,

    );





    _loaded = true;



    notifyListeners();


  }









  Future<void> saveHistory() async {



    await storageService.saveMessages(

      _messages,

    );


  }








  Future<void> addMessage(

      ChatMessage message

  ) async {



    _messages.add(

      message,

    );



    notifyListeners();



    await saveHistory();


  }








  Future<void> updateMessage(

      ChatMessage message

  ) async {



    final index = _messages.indexWhere(

      (item)=>item.id == message.id,

    );





    if(index == -1){

      return;

    }





    _messages[index] = message;



    notifyListeners();



    await saveHistory();


  }








  Future<void> removeMessage(

      String id

  ) async {



    _messages.removeWhere(

      (message)=>message.id == id,

    );



    notifyListeners();



    await saveHistory();


  }








  Future<void> clearHistory() async {



    _messages.clear();



    await storageService.clear();



    notifyListeners();


  }





}