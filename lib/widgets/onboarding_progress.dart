import 'package:flutter/material.dart';

import '../theme/app_animation.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class OnboardingProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) {
          final active = index < currentStep;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == totalSteps - 1 ? 0 : AppSpacing.sm,
              ),
              child: AnimatedContainer(
                duration: AppAnimation.normal,
                curve: AppAnimation.defaultCurve,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.pillRadius,
                  color: active
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}