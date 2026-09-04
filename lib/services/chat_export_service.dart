import 'dart:convert';

import '../models/chat_message.dart';



class ChatExportService {



  String exportConversation(

      List<ChatMessage> messages

  ){



    final data = messages.map(

      (message)=>{

        "sender":

        message.isUser

            ? "User"

            : "MAX",


        "message":

        message.text,


        "time":

        message.createdAt

            .toIso8601String(),

      },

    ).toList();





    return const JsonEncoder

        .withIndent("  ")

        .convert(

          data,

        );


  }







}