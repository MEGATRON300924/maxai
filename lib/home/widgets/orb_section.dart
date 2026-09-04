import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_spacing.dart';
import '../../core/app_typography.dart';


class OrbSection extends StatefulWidget {

  const OrbSection({
    super.key,
  });


  @override
  State<OrbSection> createState() =>
      _OrbSectionState();

}



class _OrbSectionState
    extends State<OrbSection>
    with SingleTickerProviderStateMixin {


  late AnimationController _controller;


  @override
  void initState() {

    super.initState();


    _controller =
        AnimationController(

      vsync:
          this,

      duration:
          const Duration(
            seconds: 6,
          ),

    )
          ..repeat(
            reverse: true,
          );

  }



  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        AnimatedBuilder(

          animation:
              _controller,


          builder:
              (context, child) {


            final value =
                _controller.value;


            return Transform.translate(

              offset:
                  Offset(
                    0,
                    value * 8,
                  ),


              child: SizedBox(

                width:
                    AppSpacing.orbXL,


                height:
                    AppSpacing.orbXL,


                child:
                    Stack(

                  alignment:
                      Alignment.center,


                  children: [

                    Container(

                      width:
                          220,

                      height:
                          220,


                      decoration:
                          BoxDecoration(

                        shape:
                            BoxShape.circle,


                        boxShadow: [

                          BoxShadow(

                            color:
                                AppColors.primary
                                    .withValues(
                                  alpha:
                                      .35,
                                ),

                            blurRadius:
                                60,

                            spreadRadius:
                                20,

                          ),

                        ],

                      ),

                    ),



                    Container(

                      width:
                          190,

                      height:
                          190,


                      decoration:
                          BoxDecoration(

                        shape:
                            BoxShape.circle,


                        gradient:
                            const RadialGradient(

                          colors: [

                            Color(
                              0xFFFFFFFF,
                            ),

                            Color(
                              0xFF60A5FA,
                            ),

                            Color(
                              0xFF2563EB,
                            ),

                            Color(
                              0xFF0F172A,
                            ),

                          ],

                          stops: [

                            .05,

                            .25,

                            .65,

                            1,

                          ],

                        ),


                        boxShadow: [

                          BoxShadow(

                            color:
                                AppColors.accent
                                    .withValues(
                                  alpha:
                                      .4,
                                ),

                            blurRadius:
                                40,

                          ),

                        ],

                      ),

                    ),



                    BackdropFilter(

                      filter:
                          ImageFilter.blur(
                            sigmaX:
                                12,

                            sigmaY:
                                12,
                          ),


                      child:
                          Container(

                        width:
                            150,

                        height:
                            150,


                        decoration:
                            BoxDecoration(

                          shape:
                              BoxShape.circle,


                          color:
                              Colors.white
                                  .withValues(
                                alpha:
                                    .08,
                              ),

                          border:
                              Border.all(

                            color:
                                Colors.white
                                    .withValues(
                                  alpha:
                                      .25,
                                ),

                          ),

                        ),

                      ),

                    ),



                    Positioned(

                      top:
                          45 + (value * 15),


                      left:
                          55,


                      child:
                          Container(

                        width:
                            35,

                        height:
                            35,


                        decoration:
                            BoxDecoration(

                          shape:
                              BoxShape.circle,


                          color:
                              Colors.white
                                  .withValues(
                                alpha:
                                    .45,
                              ),

                        ),

                      ),

                    ),


                    CustomPaint(

                      size:
                          const Size(
                            220,
                            220,
                          ),

                      painter:
                          _OrbRingPainter(
                            value,
                          ),

                    ),

                  ],

                ),

              ),

            );

          },

        ),


        const SizedBox(
          height:
              AppSpacing.xxl,
        ),


        Text(

          "How can I help today?",

          style:
              AppTypography.headlineSmall.copyWith(

            color:
                AppColors.darkTextPrimary,

          ),

        ),

      ],

    );

  }

}



class _OrbRingPainter
    extends CustomPainter {


  final double animation;


  _OrbRingPainter(
    this.animation,
  );



  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {


    final paint =
        Paint()

          ..style =
              PaintingStyle.stroke

          ..strokeWidth =
              2

          ..color =
              AppColors.accent
                  .withValues(
                    alpha:
                        .45,
                  );



    final rect =
        Rect.fromCenter(

      center:
          size.center(
            Offset.zero,
          ),

      width:
          size.width -
              20,

      height:
          size.height -
              20,

    );



    canvas.drawArc(

      rect,

      animation * 6.28,

      4.2,

      false,

      paint,

    );

  }



  @override
  bool shouldRepaint(
    CustomPainter oldDelegate,
  ) {

    return true;

  }

}