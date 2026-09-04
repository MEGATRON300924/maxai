import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/glass_card.dart';
import '../../core/app_colors.dart';
import '../../core/app_spacing.dart';
import '../../core/app_typography.dart';


class ContinueConversation extends StatelessWidget {

  const ContinueConversation({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final home =
        context.watch<HomeProvider>();


    if (!home.hasContinueConversation) {
      return const SizedBox.shrink();
    }


    return GlassCard(

      borderRadius:
          BorderRadius.circular(26),

      padding:
          const EdgeInsets.all(
            AppSpacing.cardPadding,
          ),


      onTap: () {

      },


      child: Row(

        children: [

          Container(

            width: 48,

            height: 48,

            decoration:
                BoxDecoration(

              shape:
                  BoxShape.circle,

              gradient:
                  AppColors.primaryGradient,

            ),


            child: const Icon(

              Icons.chat_bubble_outline,

              color:
                  Colors.white,

            ),

          ),


          const SizedBox(
            width:
                AppSpacing.md,
          ),


          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [

                Text(

                  "Continue Conversation",

                  style:
                      AppTypography.titleMedium.copyWith(

                    color:
                        AppColors.darkTextPrimary,

                  ),

                ),


                const SizedBox(

                  height:
                      AppSpacing.xs,

                ),


                Text(

                  home.continueConversationTitle ??
                      "Resume your previous conversation",

                  maxLines:
                      2,

                  overflow:
                      TextOverflow.ellipsis,


                  style:
                      AppTypography.bodyMedium.copyWith(

                    color:
                        AppColors.darkTextSecondary,

                  ),

                ),

              ],

            ),

          ),


          const Icon(

            Icons.arrow_forward_ios,

            size:
                16,

            color:
                AppColors.darkTextHint,

          ),

        ],

      ),

    );

  }

}