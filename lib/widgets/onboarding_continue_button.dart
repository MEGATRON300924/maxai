import 'package:flutter/material.dart';

import '../theme/app_animation.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class OnboardingContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final String text;

  const OnboardingContinueButton({
    super.key,
    required this.onPressed,
    this.loading = false,
    this.text = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;

    return AnimatedOpacity(
      duration: AppAnimation.fast,
      opacity: enabled ? 1 : .55,
      child: AnimatedScale(
        duration: AppAnimation.fast,
        scale: enabled ? 1 : .98,
        child: SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: enabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.pillRadius,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            ),
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
