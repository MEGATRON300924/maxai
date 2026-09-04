import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradient {
  AppGradient._();

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF09090B),
      Color(0xFF111827),
    ],
  );

  static const glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x22FFFFFF),
      Color(0x08FFFFFF),
    ],
  );

  static const blue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF60A5FA),
      AppColors.primary,
    ],
  );

  static const purple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA78BFA),
      Color(0xFF8B5CF6),
    ],
  );

  static const ultra = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF176),
      Color(0xFFFFC107),
    ],
  );
}