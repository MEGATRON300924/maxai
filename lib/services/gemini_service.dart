import 'dart:convert';

import 'package:http/http.dart' as http;

import 'max_memory_model.dart';




class GeminiService {


  final String apiKey;


  GeminiService({

    required this.apiKey,

  });







  Future<String> sendMessage({

    required String message,

    required List<MaxMemory> memories,

    required Map<String,dynamic> userProfile,

  }) async {



    final context = _buildMemoryContext(

      memories,

      userProfile,

    );





    final prompt = """

You are MAX, the personal AI assistant created by The Tron Forge Limited.

Your personality:
- Friendly
- Intelligent
- Helpful
- Professional
- Voice-first assistant
- Understand the user's identity and preferences

IMPORTANT USER CONTEXT:

$context


USER MESSAGE:

$message


Instructions:
- Use the memory context when relevant.
- Do not reveal private memory data unless needed.
- If the user asks you to remember something, mark it for memory storage.
- Answer naturally like a personal assistant.


""";






    final response = await http.post(

      Uri.parse(

        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",

      ),


      headers: {

        "Content-Type":"application/json",

      },


      body: jsonEncode({

        "contents":[

          {

            "parts":[

              {

                "text":prompt

              }

            ]

          }

        ],


        "generationConfig":{


          "temperature":0.7,


          "maxOutputTokens":2048


        }


      }),


    );






    if(response.statusCode != 200){


      throw Exception(

        "Gemini request failed ${response.body}"

      );


    }





    final data = jsonDecode(

      response.body,

    );





    return data['candidates'][0]['content']['parts'][0]['text'];



  }








  String _buildMemoryContext(

      List<MaxMemory> memories,

      Map<String,dynamic> profile,

  ){



    String result = "";





    result += """

USER PROFILE:

Name: ${profile['name'] ?? "Unknown"}

Email: ${profile['email'] ?? "Unknown"}

""";





    if(memories.isNotEmpty){


      result += """



LONG TERM MEMORY:

""";



      for(final memory in memories){


        result +=

        "- ${memory.key}: ${memory.value}\n";


      }



    }



    return result;


  }




}