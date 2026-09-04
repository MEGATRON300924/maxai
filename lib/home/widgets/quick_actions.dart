import 'package:flutter/material.dart';

import '../../widgets/glass_card.dart';
import '../../core/app_colors.dart';
import '../../core/app_spacing.dart';
import '../../core/app_typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final actions = [

      _QuickAction(
        title: "Voice",
        icon: _MaxVoiceIcon(),
      ),

      _QuickAction(
        title: "Chat",
        icon: _MaxChatIcon(),
      ),

      _QuickAction(
        title: "Create",
        icon: _MaxCreateIcon(),
      ),

      _QuickAction(
        title: "Music",
        icon: _MaxMusicIcon(),
      ),

      _QuickAction(
        title: "Search",
        icon: _MaxSearchIcon(),
      ),

      _QuickAction(
        title: "Scan",
        icon: _MaxScanIcon(),
      ),

    ];


    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          "Quick Actions",
          style:
              AppTypography.titleLarge.copyWith(
            color:
                AppColors.darkTextPrimary,
          ),
        ),


        const SizedBox(
          height:
              AppSpacing.lg,
        ),


        GridView.builder(

          shrinkWrap:
              true,

          physics:
              const NeverScrollableScrollPhysics(),

          itemCount:
              actions.length,


          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount: 3,

            mainAxisSpacing:
                AppSpacing.md,

            crossAxisSpacing:
                AppSpacing.md,

            childAspectRatio:
                1,

          ),


          itemBuilder:
              (context,index){

            return _ActionCard(
              action:
                  actions[index],
            );

          },

        ),

      ],

    );

  }

}



class _ActionCard extends StatefulWidget {

  final _QuickAction action;


  const _ActionCard({
    required this.action,
  });


  @override
  State<_ActionCard> createState() =>
      _ActionCardState();

}


class _ActionCardState
    extends State<_ActionCard> {


  double scale = 1;


  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTapDown: (_) {

        setState(() {

          scale = .94;

        });

      },


      onTapCancel: () {

        setState(() {

          scale = 1;

        });

      },


      onTapUp: (_) {

        setState(() {

          scale = 1;

        });

      },


      child: AnimatedScale(

        scale:
            scale,

        duration:
            const Duration(
              milliseconds: 120,
            ),


        child: GlassCard(

          padding:
              const EdgeInsets.all(
                12,
              ),


          borderRadius:
              BorderRadius.circular(
                26,
              ),


          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,


            children: [

              widget.action.icon,


              const SizedBox(
                height:
                    AppSpacing.sm,
              ),


              Text(

                widget.action.title,

                style:
                    AppTypography.labelMedium.copyWith(

                  color:
                      AppColors.darkTextPrimary,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}



class _QuickAction {

  final String title;

  final Widget icon;


  const _QuickAction({

    required this.title,

    required this.icon,

  });

}



class _MaxVoiceIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return CustomPaint(

      size:
          const Size(42,42),

      painter:
          _VoicePainter(),

    );

  }

}



class _MaxChatIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Icon(
      Icons.chat_bubble_rounded,
      size: 38,
      color: AppColors.accent,
    );

  }

}



class _MaxCreateIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Icon(
      Icons.auto_awesome,
      size: 40,
      color: AppColors.primary,
    );

  }

}



class _MaxMusicIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Icon(
      Icons.graphic_eq,
      size: 42,
      color: AppColors.accent,
    );

  }

}



class _MaxSearchIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Icon(
      Icons.travel_explore,
      size: 40,
      color: AppColors.primary,
    );

  }

}



class _MaxScanIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Icon(
      Icons.document_scanner_outlined,
      size: 40,
      color: AppColors.accent,
    );

  }

}



class _VoicePainter extends CustomPainter {


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
              3
          ..color =
              AppColors.accent;


    final path =
        Path();


    path.moveTo(
      4,
      size.height / 2,
    );


    path.cubicTo(
      12,
      5,
      18,
      size.height - 5,
      26,
      size.height / 2,
    );


    path.cubicTo(
      32,
      15,
      36,
      15,
      38,
      size.height / 2,
    );


    canvas.drawPath(
      path,
      paint,
    );

  }


  @override
  bool shouldRepaint(
      CustomPainter oldDelegate) {

    return false;

  }

}