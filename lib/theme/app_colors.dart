import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF0F172A);
  static const Color accent = Color(0xFF06B6D4);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color card = Color(0xFFFFFFFF);

  static const Color darkBackground = Color(0xFF09090B);
  static const Color darkSurface = Color(0xFF18181B);
  static const Color darkSurfaceVariant = Color(0xFF27272A);
  static const Color darkCard = Color(0xFF1E1E24);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFD4D4D8);
  static const Color darkTextHint = Color(0xFFA1A1AA);
  static const Color darkTextDisabled = Color(0xFF71717A);

  static const Color iconPrimary = Color(0xFF0F172A);
  static const Color iconSecondary = Color(0xFF64748B);
  static const Color iconDisabled = Color(0xFFCBD5E1);

  static const Color darkIconPrimary = Colors.white;
  static const Color darkIconSecondary = Color(0xFFD4D4D8);
  static const Color darkIconDisabled = Color(0xFF71717A);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE5E7EB);

  static const Color darkBorder = Color(0xFF3F3F46);
  static const Color darkDivider = Color(0xFF3F3F46);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color online = Color(0xFF22C55E);
  static const Color offline = Color(0xFF94A3B8);
  static const Color syncing = Color(0xFF06B6D4);

  static const Color basic = Color(0xFF94A3B8);
  static const Color pro = Color(0xFF2563EB);
  static const Color ultra = Color(0xFFFFC107);
  static const Color beta = Color(0xFF8B5CF6);

  static const Color thinking = Color(0xFF3B82F6);
  static const Color processing = Color(0xFF6366F1);
  static const Color speaking = Color(0xFF06B6D4);
  static const Color searching = Color(0xFF14B8A6);

  static const Color glow = Color(0x552563EB);
  static const Color glowStrong = Color(0x992563EB);
  static const Color reflection = Color(0x66FFFFFF);
  static const Color overlay = Color(0x33FFFFFF);
  static const Color frost = Color(0x14FFFFFF);
  static const Color shadow = Color(0x14000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF2563EB),
      Color(0xFF3B82F6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      Color(0xFF06B6D4),
      Color(0xFF2563EB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ultraGradient = LinearGradient(
    colors: [
      Color(0xFFFFD54F),
      Color(0xFFFFB300),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient betaGradient = LinearGradient(
    colors: [
      Color(0xFF8B5CF6),
      Color(0xFF6366F1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF09090B),
      Color(0xFF18181B),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

extension ColorExtension on Color {
  Color opacity(double value) => withValues(alpha: value);
}