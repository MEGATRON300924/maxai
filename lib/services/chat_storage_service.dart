import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';



class ChatStorageService {



  static const String key = "max_chat_history";







  Future<void> saveMessages(

      List<ChatMessage> messages

  ) async {



    final prefs = await SharedPreferences.getInstance();



    final data = messages.map(

      (message)=>{

        "id":message.id,

        "text":message.text,

        "isUser":message.isUser,

        "createdAt":

        message.createdAt.toIso8601String(),

        "sources":message.sources,

        "attachmentPath":

        message.attachmentPath,

        "attachmentType":

        message.attachmentType,

      },

    ).toList();





    await prefs.setString(

      key,

      jsonEncode(data),

    );


  }








  Future<List<ChatMessage>> loadMessages() async {



    final prefs = await SharedPreferences.getInstance();



    final raw = prefs.getString(

      key,

    );





    if(raw == null){

      return [];

    }






    final List data = jsonDecode(

      raw,

    );





    return data.map(

      (item)=>ChatMessage(

        id:item["id"],

        text:item["text"],

        isUser:item["isUser"],

        createdAt:

        DateTime.parse(

          item["createdAt"],

        ),

        sources:

        List<String>.from(

          item["sources"] ?? [],

        ),

        attachmentPath:

        item["attachmentPath"],

        attachmentType:

        item["attachmentType"],

      ),

    ).toList();


  }








  Future<void> clear() async {



    final prefs = await SharedPreferences.getInstance();



    await prefs.remove(

      key,

    );


  }





}