import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';


class GlassCard extends StatelessWidget {

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final BorderRadius? borderRadius;

  final VoidCallback? onTap;


  const GlassCard({

    super.key,

    required this.child,

    this.padding,

    this.borderRadius,

    this.onTap,

  });



  @override
  Widget build(BuildContext context) {

    final card = ClipRRect(

      borderRadius:
          borderRadius ??
              BorderRadius.circular(24),


      child: BackdropFilter(

        filter:
            ImageFilter.blur(

          sigmaX:
              18,

          sigmaY:
              18,

        ),


        child: Container(

          padding:
              padding ??
                  const EdgeInsets.all(20),


          decoration:
              BoxDecoration(

            color:
                Colors.white.withValues(
                  alpha:
                      .08,
                ),


            borderRadius:
                borderRadius ??
                    BorderRadius.circular(24),


            border:
                Border.all(

              color:
                  Colors.white.withValues(
                    alpha:
                        .14,
                  ),

            ),


            boxShadow: [

              BoxShadow(

                color:
                    AppColors.shadow,

                blurRadius:
                    20,

                offset:
                    const Offset(
                      0,
                      8,
                    ),

              ),

            ],

          ),


          child:
              child,

        ),

      ),

    );


    if (onTap == null) {

      return card;

    }


    return InkWell(

      borderRadius:
          borderRadius ??
              BorderRadius.circular(24),


      onTap:
          onTap,


      child:
          card,

    );

  }

}