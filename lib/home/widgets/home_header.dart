import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_spacing.dart';
import '../../core/app_typography.dart';


class HomeHeader extends StatelessWidget {

  final String? firstName;

  final String greeting;

  final String? weather;


  const HomeHeader({

    super.key,

    required this.firstName,

    required this.greeting,

    required this.weather,

  });


  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,


      children: [

        GestureDetector(

          onTap: () {

          },

          child: Container(

            padding:
                const EdgeInsets.symmetric(

              horizontal:
                  16,

              vertical:
                  10,

            ),


            decoration:
                BoxDecoration(

              borderRadius:
                  BorderRadius.circular(30),


              gradient:
                  LinearGradient(

                colors: [

                  AppColors.pro.withValues(
                    alpha: .25,
                  ),

                  AppColors.primary.withValues(
                    alpha: .12,
                  ),

                ],

              ),


              border:
                  Border.all(

                color:
                    AppColors.primary.withValues(
                      alpha: .35,
                    ),

              ),

            ),


            child: Row(

              mainAxisSize:
                  MainAxisSize.min,


              children: [

                const Icon(

                  Icons.auto_awesome,

                  size:
                      18,

                  color:
                      AppColors.primary,

                ),


                const SizedBox(
                  width:
                      8,
                ),


                Text(

                  "MAX Basic",

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


        const SizedBox(
          height:
              AppSpacing.xxl,
        ),


        Text(

          greeting,

          style:
              AppTypography.headlineMedium.copyWith(

            color:
                AppColors.darkTextSecondary,

          ),

        ),


        const SizedBox(
          height:
              AppSpacing.xs,
        ),


        Text(

          firstName != null
              ? "${firstName!} 👋"
              : "Welcome 👋",

          style:
              AppTypography.displaySmall.copyWith(

            color:
                AppColors.darkTextPrimary,

          ),

        ),


        const SizedBox(
          height:
              AppSpacing.sm,
        ),


        if (weather != null)

          Row(

            children: [

              const Icon(

                Icons.location_on_outlined,

                size:
                    18,

                color:
                    AppColors.darkTextSecondary,

              ),


              const SizedBox(
                width:
                    6,
              ),


              Text(

                weather!,

                style:
                    AppTypography.bodyMedium.copyWith(

                  color:
                      AppColors.darkTextSecondary,

                ),

              ),

            ],

          ),

      ],

    );

  }

}