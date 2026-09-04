import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chat_message.dart';
import '../models/message_action.dart';

import '../services/voice_service.dart';
import '../services/link_service.dart';

import 'link_preview_card.dart';
import 'message_actions.dart';
import 'liquid_glass_container.dart';



class MaxMessageBubble extends StatefulWidget {


  final ChatMessage message;


  const MaxMessageBubble({

    super.key,

    required this.message,

  });



  @override
  State<MaxMessageBubble> createState() =>
      _MaxMessageBubbleState();

}



class _MaxMessageBubbleState
    extends State<MaxMessageBubble>
    with SingleTickerProviderStateMixin {


  late AnimationController _animation;



  @override
  void initState() {

    super.initState();


    _animation =
        AnimationController(

      vsync:
          this,

      duration:
          const Duration(
            milliseconds: 350,
          ),

    );



    _animation.forward();

  }



  @override
  void dispose() {

    _animation.dispose();

    super.dispose();

  }



  bool get isUser =>

      widget.message.sender ==
      MessageSender.user;



  @override
  Widget build(BuildContext context) {


    return FadeTransition(

      opacity:

          CurvedAnimation(

            parent:
                _animation,

            curve:
                Curves.easeOut,

          ),



      child:

          SlideTransition(

        position:

            Tween<Offset>(

              begin:
                  const Offset(
                    0,
                    .15,
                  ),

              end:
                  Offset.zero,

            ).animate(

              CurvedAnimation(

                parent:
                    _animation,

                curve:
                    Curves.easeOut,

              ),

            ),



        child:

            Align(

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



            constraints:

                BoxConstraints(

              maxWidth:

                  MediaQuery.of(context)
                      .size
                      .width *
                      .82,

            ),



            child:

                isUser

                    ? _userBubble()

                    : _maxBubble(),

          ),

        ),

      ),

    );

  }





  Widget _userBubble() {


    return Container(

      padding:

          const EdgeInsets.all(
            16,
          ),



      decoration:

          BoxDecoration(

        borderRadius:

            BorderRadius.circular(
              24,
            ),



        gradient:

            const LinearGradient(

          colors: [

            Color(
              0xFF2563EB,
            ),

            Color(
              0xFF3B82F6,
            ),

          ],

        ),

      ),



      child:

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

    );

  }





  Widget _maxBubble() {


    return Column(

      crossAxisAlignment:

          CrossAxisAlignment.start,



      children: [



        LiquidGlassContainer(

          radius:
              24,



          child:

              Padding(

            padding:

                const EdgeInsets.all(
                  16,
                ),



            child:

                Text(

              widget.message.content,

              style:

                  const TextStyle(

                color:
                    Colors.white,

                fontSize:
                    15,

                height:
                    1.4,

              ),

            ),

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



        const SizedBox(
          height: 8,
        ),



        MessageActions(

          onAction:
              _action,

        ),

      ],

    );

  }





  void _action(
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


        VoiceService.instance
            .speak(

              widget.message.content,

            );


        break;



      case MessageAction.like:


        break;



      case MessageAction.dislike:


        break;



      case MessageAction.share:


        break;



      case MessageAction.regenerate:


        break;


    }


  }

}