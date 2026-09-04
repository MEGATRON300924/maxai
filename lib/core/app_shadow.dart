import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadow {
  AppShadow._();

  static List<BoxShadow> get glass => [

        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),

      ];

  static List<BoxShadow> get orb => [

        BoxShadow(
          color: AppColors.primary.withValues(alpha: .25),
          blurRadius: 70,
          spreadRadius: 12,
        ),

      ];

  static List<BoxShadow> get glow => [

        BoxShadow(
          color: AppColors.primary.withValues(alpha: .18),
          blurRadius: 35,
        ),

      ];
}