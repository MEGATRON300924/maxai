import '../models/chat_message.dart';



class ConversationContextService {



  List<Map<String,String>> buildContext(

      List<ChatMessage> messages

  ){



    return messages

        .take(20)

        .map(

          (message)=>{

            "role":

            message.isUser

                ? "user"

                : "assistant",


            "content":

            message.text,

          },

        )

        .toList();


  }







  String buildPrompt(

      List<ChatMessage> messages

  ){



    final context = buildContext(

      messages,

    );





    return context

        .map(

          (item)=>

          "${item["role"]}: ${item["content"]}",

        )

        .join("\n");


  }






}