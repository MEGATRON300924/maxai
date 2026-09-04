import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../core/app_typography.dart';



class SectionHeader extends StatelessWidget {

  final String title;

  final String? actionText;

  final VoidCallback? onAction;



  const SectionHeader({

    super.key,

    required this.title,

    this.actionText,

    this.onAction,

  });



  @override
  Widget build(BuildContext context) {


    return Padding(

      padding:
          const EdgeInsets.only(

        bottom:
            AppSpacing.md,

      ),


      child:
          Row(

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,


        children: [

          Text(

            title,


            style:
                AppTypography.titleLarge.copyWith(

              color:
                  Colors.white,

            ),

          ),



          if (actionText != null)

            GestureDetector(

              onTap:
                  onAction,


              child:
                  Text(

                actionText!,


                style:
                    AppTypography.labelMedium.copyWith(

                  color:
                      Colors.white70,

                ),

              ),

            ),

        ],

      ),

    );

  }

}