import 'package:flutter/material.dart';

import '../../widgets/glass_card.dart';
import '../../core/app_colors.dart';
import '../../core/app_spacing.dart';
import '../../core/app_typography.dart';


class WhatsNewCard extends StatelessWidget {

  const WhatsNewCard({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return GlassCard(

      borderRadius:
          BorderRadius.circular(26),


      padding:
          const EdgeInsets.all(
            AppSpacing.cardPadding,
          ),


      onTap: () {

      },


      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,


        children: [

          Row(

            children: [

              Container(

                width:
                    48,

                height:
                    48,


                decoration:
                    BoxDecoration(

                  shape:
                      BoxShape.circle,


                  gradient:
                      AppColors.primaryGradient,

                ),


                child: const Icon(

                  Icons.auto_awesome,

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

                      "What's New",

                      style:
                          AppTypography.titleMedium.copyWith(

                        color:
                            AppColors.darkTextPrimary,

                      ),

                    ),


                    Text(

                      "Latest MAX ecosystem updates",

                      style:
                          AppTypography.bodySmall.copyWith(

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


          const SizedBox(
            height:
                AppSpacing.lg,
          ),


          _UpdateItem(
            title:
                "New AI capabilities",

            subtitle:
                "Explore new ways MAX can help you",

          ),


          const SizedBox(
            height:
                AppSpacing.md,
          ),


          _UpdateItem(
            title:
                "MAX ecosystem improvements",

            subtitle:
                "Better performance and smarter experiences",

          ),

        ],

      ),

    );

  }

}



class _UpdateItem extends StatelessWidget {

  final String title;

  final String subtitle;


  const _UpdateItem({

    required this.title,

    required this.subtitle,

  });


  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.all(
            AppSpacing.md,
          ),


      decoration:
          BoxDecoration(

        color:
            AppColors.darkSurfaceVariant
                .withValues(
              alpha: .45,
            ),


        borderRadius:
            BorderRadius.circular(18),

      ),


      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,


        children: [

          Text(

            title,

            style:
                AppTypography.titleSmall.copyWith(

              color:
                  AppColors.darkTextPrimary,

            ),

          ),


          const SizedBox(
            height:
                AppSpacing.xs,
          ),


          Text(

            subtitle,

            style:
                AppTypography.bodySmall.copyWith(

              color:
                  AppColors.darkTextSecondary,

            ),

          ),

        ],

      ),

    );

  }

}