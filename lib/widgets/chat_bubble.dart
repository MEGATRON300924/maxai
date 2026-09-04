import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chat_message.dart';
import '../models/message_action.dart';

import '../services/link_service.dart';
import '../services/voice_service.dart';

import '../widgets/link_preview_card.dart';
import '../widgets/message_actions.dart';

import '../core/app_colors.dart';




class ChatBubble extends StatefulWidget {


  final ChatMessage message;



  const ChatBubble({

    super.key,

    required this.message,

  });



  @override
  State<ChatBubble> createState() =>
      _ChatBubbleState();

}



class _ChatBubbleState extends State<ChatBubble> {


  @override
  Widget build(BuildContext context) {


    final isUser =
        widget.message.sender ==
            MessageSender.user;



    return Align(

      alignment:

          isUser

              ? Alignment.centerRight

              : Alignment.centerLeft,



      child:

          Container(

        margin:

            const EdgeInsets.symmetric(

              horizontal:
                  16,

              vertical:
                  8,

            ),



        padding:

            const EdgeInsets.all(
              16,
            ),



        constraints:

            BoxConstraints(

          maxWidth:

              MediaQuery.of(context)
                  .size
                  .width *
                  0.82,

        ),



        decoration:

            BoxDecoration(

          color:

              isUser

                  ? AppColors.primary

                  : AppColors.darkCard,



          borderRadius:

              BorderRadius.circular(
                24,
              ),



          border:

              Border.all(

            color:

                isUser

                    ? AppColors.primary

                    : AppColors.darkBorder,

          ),

        ),



        child:

            Column(

          crossAxisAlignment:

              CrossAxisAlignment.start,



          children: [



            Text(

              widget.message.content,

              style:

                  const TextStyle(

                color:
                    Colors.white,

                fontSize:
                    15,

              ),

            ),



            FutureBuilder(

              future:

                  LinkService.instance
                      .getPreview(

                widget.message.content,

              ),



              builder:

                  (context, snapshot) {


                if(snapshot.hasData &&
                    snapshot.data != null) {


                  return LinkPreviewCard(

                    preview:
                        snapshot.data!,

                  );

                }



                return const SizedBox();

              },

            ),



            if(!isUser)

              Padding(

                padding:

                    const EdgeInsets.only(
                      top: 14,
                    ),



                child:

                    MessageActions(

                  onAction:

                      _handleAction,

                ),

              ),

          ],

        ),

      ),

    );

  }





  void _handleAction(
    MessageAction action,
  ) {


    switch(action) {


      case MessageAction.copy:


        Clipboard.setData(

          ClipboardData(

            text:
                widget.message.content,

          ),

        );


        break;



      case MessageAction.readAloud:


        VoiceService.instance.speak(

          widget.message.content,

        );


        break;



      case MessageAction.like:


        break;



      case MessageAction.dislike:


        break;



      case MessageAction.regenerate:


        break;



      case MessageAction.share:


        break;


    }

  }


}