import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_animation.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class OnboardingCard extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const OnboardingCard({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  State<OnboardingCard> createState() => _OnboardingCardState();
}

class _OnboardingCardState extends State<OnboardingCard> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _focused ? 1.02 : 1,
      duration: AppAnimation.fast,
      curve: AppAnimation.defaultCurve,
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        curve: AppAnimation.defaultCurve,
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusXXL,
          color: Colors.white.withValues(alpha: .08),
          border: Border.all(
            color: _focused
                ? AppColors.primary
                : AppColors.border,
          ),
          boxShadow: _focused
              ? AppShadows.glowStrong
              : AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: AppRadius.radiusXXL,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.xl,
              ),
              child: TextField(
                controller: widget.controller,
                textAlign: TextAlign.center,
                cursorColor: AppColors.primary,
                style: AppTypography.headlineMedium,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
                onTap: () {
                  setState(() {
                    _focused = true;
                  });
                },
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();

                  setState(() {
                    _focused = false;
                  });
                },
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}