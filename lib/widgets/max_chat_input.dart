import 'package:flutter/material.dart';

import '../core/app_colors.dart';

import '../widgets/max_svg_icon.dart';
import '../widgets/liquid_glass_container.dart';



class MaxChatInput extends StatefulWidget {


  final Function(String message) onSend;


  final VoidCallback onVoice;


  final VoidCallback onUpload;



  const MaxChatInput({

    super.key,

    required this.onSend,

    required this.onVoice,

    required this.onUpload,

  });



  @override
  State<MaxChatInput> createState() =>
      _MaxChatInputState();

}



class _MaxChatInputState
    extends State<MaxChatInput>
    with SingleTickerProviderStateMixin {



  final TextEditingController _controller =
      TextEditingController();



  final FocusNode _focusNode =
      FocusNode();



  bool _isFocused = false;



  late AnimationController _orbController;



  @override
  void initState() {

    super.initState();


    _focusNode.addListener(() {


      setState(() {

        _isFocused =
            _focusNode.hasFocus;

      });


    });



    _orbController =
        AnimationController(

      vsync:
          this,

      duration:
          const Duration(
            seconds: 3,
          ),

    )..repeat();

  }





  @override
  void dispose() {

    _controller.dispose();

    _focusNode.dispose();

    _orbController.dispose();

    super.dispose();

  }





  void _send() {


    final text =
        _controller.text.trim();



    if(text.isEmpty) {

      return;

    }



    widget.onSend(text);



    _controller.clear();


    _focusNode.requestFocus();

  }





  @override
  Widget build(BuildContext context) {


    return Padding(

      padding:

          const EdgeInsets.only(

            left:
                14,

            right:
                14,

            bottom:
                14,

          ),



      child:

          LiquidGlassContainer(

            radius:
                32,



            child:

                AnimatedContainer(

              duration:

                  const Duration(
                    milliseconds: 300,
                  ),



              padding:

                  const EdgeInsets.symmetric(

                    horizontal:
                        14,

                    vertical:
                        10,

                  ),



              decoration:

                  BoxDecoration(

                borderRadius:

                    BorderRadius.circular(
                      32,
                    ),



                boxShadow:

                    _isFocused

                        ? [

                            BoxShadow(

                              color:

                                  AppColors.primary
                                      .withValues(
                                        alpha: 0.35,
                                      ),

                              blurRadius:
                                  25,

                            )

                          ]

                        : [],

              ),



              child:

                  Row(

                crossAxisAlignment:

                    CrossAxisAlignment.end,



                children: [



                  _ActionButton(

                    icon:
                        "new",

                    onTap:
                        widget.onUpload,

                  ),



                  const SizedBox(
                    width: 10,
                  ),



                  Expanded(

                    child:

                        TextField(

                      controller:
                          _controller,



                      focusNode:
                          _focusNode,



                      minLines:
                          1,



                      maxLines:
                          6,



                      textInputAction:

                          TextInputAction.newline,



                      style:

                          const TextStyle(

                        color:
                            Colors.white,

                        fontSize:
                            15,

                      ),



                      decoration:

                          InputDecoration(

                        hintText:

                            "Message MAX...",



                        hintStyle:

                            TextStyle(

                          color:

                              Colors.white
                                  .withValues(
                                    alpha: 0.45,
                                  ),

                        ),



                        border:

                            InputBorder.none,

                      ),

                    ),

                  ),



                  const SizedBox(
                    width: 8,
                  ),



                  GestureDetector(

                    onTap:
                        widget.onVoice,



                    child:

                        AnimatedBuilder(

                      animation:
                          _orbController,



                      builder:

                          (context, child) {


                        return Transform.rotate(

                          angle:

                              _orbController.value *
                                  6.28,



                          child:

                              Container(

                            padding:

                                const EdgeInsets.all(
                                  4,
                                ),



                            decoration:

                                BoxDecoration(

                              shape:

                                  BoxShape.circle,



                              boxShadow: [

                                BoxShadow(

                                  color:

                                      AppColors.primary
                                          .withValues(
                                            alpha: 0.5,
                                          ),

                                  blurRadius:
                                      20,

                                ),

                              ],

                            ),



                            child:

                                const MaxSvgIcon(

                              asset:
                                  "voice",

                              size:
                                  42,

                            ),

                          ),

                        );

                      },

                    ),

                  ),



                  const SizedBox(
                    width: 8,
                  ),



                  _SendButton(

                    onTap:
                        _send,

                  ),

                ],

              ),

            ),

          ),

    );

  }

}





class _ActionButton extends StatelessWidget {


  final String icon;


  final VoidCallback onTap;



  const _ActionButton({

    required this.icon,

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:
          onTap,



      child:

          const MaxSvgIcon(

        asset:
            "new",

        size:
            38,

      ),

    );

  }

}





class _SendButton extends StatelessWidget {


  final VoidCallback onTap;



  const _SendButton({

    required this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:
          onTap,



      child:

          Container(

        width:
            42,

        height:
            42,



        decoration:

            BoxDecoration(

          shape:
              BoxShape.circle,



          gradient:

              const LinearGradient(

            colors: [

              Color(
                0xFF2563EB,
              ),

              Color(
                0xFF22D3EE,
              ),

            ],

          ),

        ),



        child:

            const MaxSvgIcon(

          asset:
              "next",

          size:
              24,

          color:
              Colors.white,

        ),

      ),

    );

  }

}