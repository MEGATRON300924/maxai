import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/glass_card.dart';
import '../../core/app_colors.dart';
import '../../core/app_spacing.dart';
import '../../core/app_typography.dart';


class SuggestedPrompts extends StatelessWidget {

  const SuggestedPrompts({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final home =
        context.watch<HomeProvider>();


    final prompts =
        home.suggestedPrompts;


    if (prompts.isEmpty) {

      return Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,


        children: [

          Text(

            "Suggested Prompts",

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


          const _PromptCard(

            text:
                "Summarize today's news",

          ),


          const SizedBox(

            height:
                AppSpacing.md,

          ),


          const _PromptCard(

            text:
                "Continue my homework",

          ),


          const SizedBox(

            height:
                AppSpacing.md,

          ),


          const _PromptCard(

            text:
                "Play my study playlist",

          ),


          const SizedBox(

            height:
                AppSpacing.md,

          ),


          const _PromptCard(

            text:
                "Control my bedroom lights",

          ),

        ],

      );

    }



    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,


      children: [

        Text(

          "Suggested Prompts",

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


        ...prompts.map(

          (prompt) => Padding(

            padding:
                const EdgeInsets.only(

              bottom:
                  AppSpacing.md,

            ),


            child:
                _PromptCard(

              text:
                  prompt.text,

            ),

          ),

        ),

      ],

    );

  }

}



class _PromptCard extends StatefulWidget {

  final String text;


  const _PromptCard({

    required this.text,

  });



  @override
  State<_PromptCard> createState() =>
      _PromptCardState();

}



class _PromptCardState
    extends State<_PromptCard> {


  double scale = 1;



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTapDown: (_) {

        setState(() {

          scale =
              .97;

        });

      },


      onTapUp: (_) {

        setState(() {

          scale =
              1;

        });

      },


      onTapCancel: () {

        setState(() {

          scale =
              1;

        });

      },


      child:
          AnimatedScale(

        scale:
            scale,


        duration:
            const Duration(

          milliseconds:
              150,

        ),


        child:
            GlassCard(

          borderRadius:
              BorderRadius.circular(22),


          padding:
              const EdgeInsets.symmetric(

            horizontal:
                18,

            vertical:
                16,

          ),


          onTap: () {


          },


          child:
              Row(

            children: [

              Container(

                width:
                    38,

                height:
                    38,


                decoration:
                    BoxDecoration(

                  shape:
                      BoxShape.circle,


                  color:
                      AppColors.primary
                          .withValues(

                    alpha:
                        .15,

                  ),

                ),


                child:
                    const Icon(

                  Icons.auto_awesome,

                  size:
                      20,

                  color:
                      AppColors.primary,

                ),

              ),


              const SizedBox(

                width:
                    AppSpacing.md,

              ),


              Expanded(

                child:
                    Text(

                  widget.text,

                  style:
                      AppTypography.bodyMedium.copyWith(

                    color:
                        AppColors.darkTextPrimary,

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}