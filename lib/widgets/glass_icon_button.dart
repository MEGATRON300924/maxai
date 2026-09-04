import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/app_duration.dart';
import '../core/app_radius.dart';
import '../core/app_shadow.dart';



class GlassIconButton extends StatefulWidget {

  final Widget icon;

  final VoidCallback? onPressed;

  final double size;

  final Color? iconColor;

  final Color? backgroundColor;


  const GlassIconButton({

    super.key,

    required this.icon,

    this.onPressed,

    this.size = 52,

    this.iconColor,

    this.backgroundColor,

  });



  @override
  State<GlassIconButton> createState() =>
      _GlassIconButtonState();

}



class _GlassIconButtonState
    extends State<GlassIconButton> {


  bool pressed = false;



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTapDown: (_) {

        setState(() {

          pressed = true;

        });

      },


      onTapUp: (_) {

        setState(() {

          pressed = false;

        });


        widget.onPressed?.call();

      },


      onTapCancel: () {

        setState(() {

          pressed = false;

        });

      },


      child:
          AnimatedScale(

        duration:
            AppDuration.fast,


        scale:
            pressed ? .92 : 1,


        child:
            ClipRRect(

          borderRadius:
              BorderRadius.circular(
                AppRadius.lg,
              ),


          child:
              BackdropFilter(

            filter:
                ImageFilter.blur(

              sigmaX:
                  18,

              sigmaY:
                  18,

            ),


            child:
                Container(

              width:
                  widget.size,


              height:
                  widget.size,


              decoration:
                  BoxDecoration(

                color:
                    widget.backgroundColor ??
                    Colors.white.withValues(
                      alpha: .08,
                    ),


                borderRadius:
                    BorderRadius.circular(
                      AppRadius.lg,
                    ),


                border:
                    Border.all(

                  color:
                      Colors.white.withValues(
                        alpha: .12,
                      ),

                ),


                boxShadow:
                    AppShadow.glass,

              ),


              child:
                  Center(

                child:
                    IconTheme(

                  data:
                      IconThemeData(

                    color:
                        widget.iconColor ??
                        Colors.white,

                    size:
                        24,

                  ),


                  child:
                      widget.icon,

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}