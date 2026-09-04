import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/profile_provider.dart';

import '../widgets/chat_bubble.dart';
import '../widgets/max_chat_input.dart';

import '../core/app_colors.dart';
import '../core/app_spacing.dart';

import '../widgets/max_svg_icon.dart';



class ChatScreen extends StatefulWidget {

  const ChatScreen({
    super.key,
  });



  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();

}



class _ChatScreenState
    extends State<ChatScreen> {


  final ScrollController _controller =
      ScrollController();



  @override
  Widget build(BuildContext context) {


    final chat =
        context.watch<ChatProvider>();


    final profile =
        context.watch<ProfileProvider>();



    return Scaffold(

      backgroundColor:
          AppColors.darkBackground,



      body:

          SafeArea(

        child:

            Column(

          children: [



            _buildHeader(
              profile.displayName,
            ),



            Expanded(

              child:

                  chat.messages.isEmpty

                      ? _buildEmptyState(
                          profile.displayName,
                        )

                      :

                      ListView.builder(

                    controller:
                        _controller,



                    padding:

                        const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),



                    itemCount:

                        chat.messages.length,



                    itemBuilder:

                        (context, index) {


                      return ChatBubble(

                        message:

                            chat.messages[index],

                      );

                    },

                  ),

            ),



            MaxChatInput(

              onSend:

                  (message) {


                chat.sendMessage(
                  message,
                );


                _scrollDown();

              },



              onVoice:

                  () {


                chat.setAIState(
                  AIState.listening,
                );

              },



              onUpload:

                  () {


              },

            ),

          ],

        ),

      ),

    );

  }





  Widget _buildHeader(
    String name,
  ) {


    return Container(

      padding:

          const EdgeInsets.symmetric(

            horizontal:
                AppSpacing.lg,

            vertical:
                AppSpacing.md,

          ),



      decoration:

          BoxDecoration(

        color:

            Colors.white.withValues(
              alpha: 0.05,
            ),



        border:

            Border(

          bottom:

              BorderSide(

            color:

                AppColors.darkBorder,

          ),

        ),

      ),



      child:

          Row(

        children: [



          const MaxSvgIcon(

            asset:
                "profile",

            size:
                42,

          ),



          const SizedBox(
            width: 12,
          ),



          Expanded(

            child:

                Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [



                Text(

                  "MAX AI",

                  style:

                      TextStyle(

                    color:
                        Colors.white,

                    fontSize:
                        18,

                    fontWeight:
                        FontWeight.w700,

                  ),

                ),



                Text(

                  "Ready to help $name",

                  style:

                      TextStyle(

                    color:

                        Colors.white
                            .withValues(
                              alpha: 0.6,
                            ),

                    fontSize:
                        12,

                  ),

                ),

              ],

            ),

          ),



          const MaxSvgIcon(

            asset:
                "search",

            size:
                38,

          ),



        ],

      ),

    );

  }





  Widget _buildEmptyState(
    String name,
  ) {


    return Center(

      child:

          Column(

        mainAxisAlignment:

            MainAxisAlignment.center,



        children: [



          const MaxSvgIcon(

            asset:
                "voice",

            size:
                100,

          ),



          const SizedBox(
            height: 20,
          ),



          Text(

            "Hello $name",

            style:

                const TextStyle(

              color:
                  Colors.white,

              fontSize:
                  28,

              fontWeight:
                  FontWeight.bold,

            ),

          ),



          const SizedBox(
            height: 8,
          ),



          Text(

            "How can MAX help you today?",

            style:

                TextStyle(

              color:

                  Colors.white
                      .withValues(
                        alpha: 0.6,
                      ),

            ),

          ),

        ],

      ),

    );

  }





  void _scrollDown() {


    Future.delayed(

      const Duration(
        milliseconds: 300,
      ),

      () {


        if(_controller.hasClients) {


          _controller.animateTo(

            _controller.position.maxScrollExtent,

            duration:

                const Duration(
                  milliseconds: 300,
                ),

            curve:

                Curves.easeOut,

          );


        }


      },

    );

  }

}