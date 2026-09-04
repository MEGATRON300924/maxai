import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_typography.dart';


enum MaxPlan {

  basic,

  pro,

  ultra,

}



class SubscriptionBadge extends StatelessWidget {


  final MaxPlan? plan;

  final bool hasError;

  final VoidCallback? onTap;



  const SubscriptionBadge({

    super.key,

    this.plan,

    this.hasError = false,

    this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    if (hasError) {

      return _Badge(

        text:
            "Failed to load",

        color:
            AppColors.error,

        icon:
            Icons.error_outline,

        onTap:
            onTap,

      );

    }



    if (plan == null) {

      return _Badge(

        text:
            "MAX",

        color:
            AppColors.darkTextHint,

        icon:
            Icons.auto_awesome,

        onTap:
            onTap,

      );

    }



    switch(plan!) {


      case MaxPlan.basic:

        return _Badge(

          text:
              "MAX Basic",

          color:
              AppColors.primary,

          icon:
              Icons.auto_awesome,

          onTap:
              onTap,

        );


      case MaxPlan.pro:

        return _Badge(

          text:
              "MAX Pro",

          color:
              AppColors.pro,

          icon:
              Icons.workspace_premium,

          onTap:
              onTap,

        );


      case MaxPlan.ultra:

        return _Badge(

          text:
              "MAX Ultra",

          color:
              AppColors.ultra,

          icon:
              Icons.diamond_outlined,

          onTap:
              onTap,

        );

    }

  }

}



class _Badge extends StatelessWidget {


  final String text;

  final Color color;

  final IconData icon;

  final VoidCallback? onTap;



  const _Badge({

    required this.text,

    required this.color,

    required this.icon,

    this.onTap,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(

      onTap:
          onTap,


      child:
          Container(

        padding:
            const EdgeInsets.symmetric(

          horizontal:
              14,

          vertical:
              10,

        ),


        decoration:
            BoxDecoration(

          borderRadius:
              BorderRadius.circular(30),


          color:
              color.withValues(

                alpha:
                    .18,

              ),


          border:
              Border.all(

            color:
                color.withValues(

                  alpha:
                      .45,

                ),

          ),

        ),


        child:
            Row(

          mainAxisSize:
              MainAxisSize.min,


          children: [


            Icon(

              icon,

              size:
                  18,

              color:
                  color,

            ),


            const SizedBox(

              width:
                  8,

            ),



            Text(

              text,

              style:
                  AppTypography.labelMedium.copyWith(

                color:
                    Colors.white,

              ),

            ),


          ],

        ),

      ),

    );

  }

}