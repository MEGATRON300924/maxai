import 'package:flutter/material.dart';

import 'max_svg_icon.dart';

import '../models/message_action.dart';



class MessageActions extends StatelessWidget {


  final Function(MessageAction action) onAction;



  const MessageActions({

    super.key,

    required this.onAction,

  });



  @override
  Widget build(BuildContext context) {


    return Row(

      mainAxisAlignment:
          MainAxisAlignment.start,

      children: [


        _button(

          "copy",

          MessageAction.copy,

        ),



        const SizedBox(
          width: 8,
        ),



        _button(

          "like",

          MessageAction.like,

        ),



        const SizedBox(
          width: 8,
        ),



        _button(

          "dislike",

          MessageAction.dislike,

        ),



        const SizedBox(
          width: 8,
        ),



        _button(

          "voice",

          MessageAction.readAloud,

        ),



        const SizedBox(
          width: 8,
        ),



        _button(

          "share_action",

          MessageAction.share,

        ),



        const SizedBox(
          width: 8,
        ),



        _button(

          "next",

          MessageAction.regenerate,

        ),

      ],

    );

  }





  Widget _button(

    String icon,

    MessageAction action,

  ) {


    return GestureDetector(

      onTap: () =>
          onAction(action),



      child:

          MaxSvgIcon(

        asset:
            icon,

        size:
            36,

      ),

    );

  }


}