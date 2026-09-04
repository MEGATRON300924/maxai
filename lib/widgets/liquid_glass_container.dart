import 'package:flutter/material.dart';



class LiquidGlassContainer extends StatelessWidget {


  final Widget child;


  final double radius;



  const LiquidGlassContainer({

    super.key,

    required this.child,

    this.radius = 24,

  });



  @override
  Widget build(BuildContext context) {


    return Container(

      decoration:

          BoxDecoration(

        borderRadius:

            BorderRadius.circular(
              radius,
            ),



        color:

            Colors.white.withValues(
              alpha: 0.08,
            ),



        border:

            Border.all(

          color:

              Colors.white.withValues(
                alpha: 0.15,
              ),

        ),



        boxShadow: [

          BoxShadow(

            color:

                Colors.black.withValues(
                  alpha: 0.25,
                ),

            blurRadius:
                25,

            spreadRadius:
                2,

          ),

        ],

      ),



      child:
          child,

    );

  }

}