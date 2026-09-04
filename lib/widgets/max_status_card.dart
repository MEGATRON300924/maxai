import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class MaxStatusCard extends StatelessWidget {

  final String title;

  final String subtitle;

  final IconData icon;

  const MaxStatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),

      decoration: BoxDecoration(

        color: Colors.white.withValues(
          alpha: .05,
        ),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: AppColors.border,
        ),

      ),

      child: Row(

        children: [

          Container(

            width: 48,
            height: 48,

            decoration: BoxDecoration(

              shape: BoxShape.circle,

              color: AppColors.primary.withValues(
                alpha: .12,
              ),

            ),

            child: Icon(
              icon,
              color: AppColors.primary,
            ),

          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: AppTypography.titleMedium,
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                ),

              ],

            ),

          ),

        ],

      ),

    );

  }

}