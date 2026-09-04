import 'package:flutter/material.dart';

import '../models/conversation_message.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';


class MaxChatBubble extends StatelessWidget {

  final ConversationMessage message;


  const MaxChatBubble({
    super.key,
    required this.message,
  });


  @override
  Widget build(BuildContext context) {

    final isMax = message.fromMax;


    return Align(

      alignment: isMax
          ? Alignment.centerLeft
          : Alignment.centerRight,


      child: AnimatedContainer(

        duration: const Duration(
          milliseconds: 300,
        ),


        margin: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
        ),


        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),


        constraints: const BoxConstraints(
          maxWidth: 320,
        ),


        decoration: BoxDecoration(

          color: isMax
              ? AppColors.primary.withValues(
                  alpha: .12,
                )
              : Colors.white.withValues(
                  alpha: .08,
                ),


          borderRadius: BorderRadius.circular(
            26,
          ),


          border: Border.all(

            color: isMax
                ? AppColors.primary.withValues(
                    alpha: .25,
                  )
                : AppColors.border,

          ),

        ),



        child: Text(

          message.text,


          style: AppTypography.bodyLarge,

        ),

      ),

    );
  }
}