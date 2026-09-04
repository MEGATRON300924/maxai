import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/max_orb_state.dart';
import '../models/max_orb_state.dart';


class MaxOrbPainter extends CustomPainter {

  final MaxOrbState state;

  final double animationValue;

  final double intensity;


  MaxOrbPainter({

    required this.state,

    required this.animationValue,

    required this.intensity,

  });



  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {


    final center = Offset(
      size.width / 2,
      size.height / 2,
    );


    final radius =
        size.width / 2;



    final theme =
        MaxOrbTheme.fromState(
          state,
        );



    _drawOuterGlow(
      canvas,
      center,
      radius,
      theme,
    );



    _drawCore(
      canvas,
      center,
      radius,
      theme,
    );



    _drawReflection(
      canvas,
      center,
      radius,
    );

  }





  void _drawOuterGlow(

    Canvas canvas,

    Offset center,

    double radius,

    MaxOrbTheme theme,

  ) {


    final paint = Paint()

      ..shader = RadialGradient(

        colors: [

          theme.primary.withValues(
            alpha: .45,
          ),

          theme.primary.withValues(
            alpha: 0,
          ),

        ],

      ).createShader(

        Rect.fromCircle(

          center: center,

          radius:
              radius * 1.8,

        ),

      );



    canvas.drawCircle(

      center,

      radius * 1.8,

      paint,

    );

  }





  void _drawCore(

    Canvas canvas,

    Offset center,

    double radius,

    MaxOrbTheme theme,

  ) {


    final gradient =
        RadialGradient(

      center: const Alignment(
        -0.3,
        -0.35,
      ),

      colors: [

        theme.secondary,

        theme.primary,

        theme.primary.withValues(
          alpha: .7,
        ),

      ],

    );



    final paint = Paint()

      ..shader = gradient.createShader(

        Rect.fromCircle(

          center: center,

          radius: radius,

        ),

      );



    canvas.drawCircle(

      center,

      radius,

      paint,

    );

  }





  void _drawReflection(

    Canvas canvas,

    Offset center,

    double radius,

  ) {


    final paint = Paint()

      ..shader = LinearGradient(

        begin: Alignment.topLeft,

        end: Alignment.bottomRight,

        colors: [

          Colors.white.withValues(
            alpha: .28,
          ),

          Colors.transparent,

        ],

      ).createShader(

        Rect.fromCircle(

          center: center,

          radius: radius,

        ),

      );



    canvas.drawCircle(

      Offset(

        center.dx - radius * .15,

        center.dy - radius * .15,

      ),

      radius * .65,

      paint,

    );

  }





  @override
  bool shouldRepaint(
    covariant MaxOrbPainter oldDelegate,
  ) {

    return oldDelegate.animationValue !=
            animationValue ||

        oldDelegate.state != state ||

        oldDelegate.intensity != intensity;

  }

}