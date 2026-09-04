import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/app_radius.dart';
import '../core/app_shadow.dart';
import '../core/app_typography.dart';



class GlassChip extends StatelessWidget {

  final String text;

  final Widget? icon;

  final Color? color;

  final Color? textColor;

  final VoidCallback? onTap;


  const GlassChip({

    super.key,

    required this.text,

    this.icon,

    this.color,

    this.textColor,

    this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:
          onTap,


      child:
          ClipRRect(

        borderRadius:
            BorderRadius.circular(
              AppRadius.pill,
            ),


        child:
            BackdropFilter(

          filter:
              ImageFilter.blur(

            sigmaX:
                16,

            sigmaY:
                16,

          ),


          child:
              Container(

            padding:
                const EdgeInsets.symmetric(

              horizontal:
                  14,

              vertical:
                  8,

            ),


            decoration:
                BoxDecoration(

              color:
                  color ??
                  Colors.white.withValues(
                    alpha:
                        .08,
                  ),


              borderRadius:
                  BorderRadius.circular(
                    AppRadius.pill,
                  ),


              border:
                  Border.all(

                color:
                    Colors.white.withValues(
                      alpha:
                          .14,
                    ),

              ),


              boxShadow:
                  AppShadow.glass,

            ),


            child:
                Row(

              mainAxisSize:
                  MainAxisSize.min,


              children: [

                if (icon != null)
                  Padding(

                    padding:
                        const EdgeInsets.only(

                      right:
                          6,

                    ),

                    child:
                        icon!,

                  ),



                Text(

                  text,


                  style:
                      AppTypography.labelMedium.copyWith(

                    color:
                        textColor ??
                        Colors.white,

                  ),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}