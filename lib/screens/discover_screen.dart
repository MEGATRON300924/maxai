import 'package:flutter/material.dart';

import '../widgets/glass_card.dart';
import '../core/app_colors.dart';
import '../core/app_spacing.dart';
import '../core/app_typography.dart';


class DiscoverScreen extends StatelessWidget {

  const DiscoverScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.darkBackground,


      body:
          SafeArea(

        child:
            SingleChildScrollView(

          physics:
              const BouncingScrollPhysics(),


          padding:
              const EdgeInsets.all(
                AppSpacing.screenHorizontal,
              ),


          child:
              Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,


            children: [

              Text(

                "Discover",

                style:
                    AppTypography.displaySmall.copyWith(

                  color:
                      AppColors.darkTextPrimary,

                ),

              ),


              const SizedBox(
                height:
                    AppSpacing.xs,
              ),


              Text(

                "Explore the MAX ecosystem",

                style:
                    AppTypography.bodyMedium.copyWith(

                  color:
                      AppColors.darkTextSecondary,

                ),

              ),



              const SizedBox(
                height:
                    AppSpacing.xxxl,
              ),



              _DiscoverCard(

                title:
                    "MAX AI",

                description:
                    "Your personal intelligent assistant",

                icon:
                    Icons.auto_awesome,

                color:
                    AppColors.primary,

              ),



              const SizedBox(
                height:
                    AppSpacing.md,
              ),



              _DiscoverCard(

                title:
                    "MAX Home",

                description:
                    "Control and manage your smart devices",

                icon:
                    Icons.home_outlined,

                color:
                    AppColors.accent,

              ),



              const SizedBox(
                height:
                    AppSpacing.md,
              ),



              _DiscoverCard(

                title:
                    "MAX Music",

                description:
                    "Your AI-powered music experience",

                icon:
                    Icons.graphic_eq,

                color:
                    AppColors.success,

              ),



              const SizedBox(
                height:
                    AppSpacing.md,
              ),



              _DiscoverCard(

                title:
                    "MAX Connect",

                description:
                    "Connect MAX with your favourite services",

                icon:
                    Icons.link_rounded,

                color:
                    AppColors.pro,

              ),



              const SizedBox(
                height:
                    AppSpacing.md,
              ),



              _DiscoverCard(

                title:
                    "MAX Studio",

                description:
                    "Create, generate and build with AI",

                icon:
                    Icons.create_outlined,

                color:
                    AppColors.beta,

              ),



              const SizedBox(
                height:
                    AppSpacing.xxxl,
              ),



              Text(

                "Latest Updates",

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



              GlassCard(

                child:
                    Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,


                  children: [

                    Text(

                      "MAX AI 2.0",

                      style:
                          AppTypography.titleMedium.copyWith(

                        color:
                            AppColors.darkTextPrimary,

                      ),

                    ),


                    const SizedBox(
                      height:
                          AppSpacing.sm,
                    ),


                    Text(

                      "A new generation of personal AI experience.",

                      style:
                          AppTypography.bodyMedium.copyWith(

                        color:
                            AppColors.darkTextSecondary,

                      ),

                    ),

                  ],

                ),

              ),


            ],

          ),

        ),

      ),

    );

  }

}



class _DiscoverCard extends StatelessWidget {


  final String title;

  final String description;

  final IconData icon;

  final Color color;



  const _DiscoverCard({

    required this.title,

    required this.description,

    required this.icon,

    required this.color,

  });



  @override
  Widget build(BuildContext context) {

    return GlassCard(

      borderRadius:
          BorderRadius.circular(26),


      onTap: () {


      },


      child:
          Row(

        children: [

          Container(

            width:
                54,

            height:
                54,


            decoration:
                BoxDecoration(

              borderRadius:
                  BorderRadius.circular(18),


              color:
                  color.withValues(
                    alpha:
                        .2,
                  ),

            ),


            child:
                Icon(

              icon,

              color:
                  color,

              size:
                  30,

            ),

          ),



          const SizedBox(
            width:
                AppSpacing.md,
          ),



          Expanded(

            child:
                Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [

                Text(

                  title,

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

                  description,

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

    );

  }

}