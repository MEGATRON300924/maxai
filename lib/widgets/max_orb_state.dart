import 'package:flutter/material.dart';

enum MaxOrbState { idle, listening, thinking, speaking, success, warning, error, offline, wakeDetected, sos, updating, sleep, syncing }

class MaxOrbTheme {
  final Color primary;
  final Color secondary;
  const MaxOrbTheme({required this.primary, required this.secondary});

  static MaxOrbTheme getTheme(MaxOrbState state) {
    switch (state) {
      case MaxOrbState.idle: return const MaxOrbTheme(primary: Color(0xFF3B82F6), secondary: Color(0xFF60A5FA));
      case MaxOrbState.listening: return const MaxOrbTheme(primary: Color(0xFF06B6D4), secondary: Color(0xFF67E8F9));
      case MaxOrbState.thinking: return const MaxOrbTheme(primary: Color(0xFF8B5CF6), secondary: Color(0xFFA78BFA));
      case MaxOrbState.speaking: return const MaxOrbTheme(primary: Color(0xFF10B981), secondary: Color(0xFF6EE7B7));
      case MaxOrbState.success: return const MaxOrbTheme(primary: Color(0xFF22C55E), secondary: Color(0xFF86EFAC));
      case MaxOrbState.warning: return const MaxOrbTheme(primary: Color(0xFFF59E0B), secondary: Color(0xFFFCD34D));
      case MaxOrbState.error: return const MaxOrbTheme(primary: Color(0xFFEF4444), secondary: Color(0xFFF87171));
      case MaxOrbState.offline: return const MaxOrbTheme(primary: Color(0xFF6B7280), secondary: Color(0xFF9CA3AF));
      case MaxOrbState.wakeDetected: return const MaxOrbTheme(primary: Color(0xFF00E5FF), secondary: Color(0xFF3B82F6));
      case MaxOrbState.sos: return const MaxOrbTheme(primary: Color(0xFFDC2626), secondary: Color(0xFFF97316));
      case MaxOrbState.updating: return const MaxOrbTheme(primary: Color(0xFF2563EB), secondary: Color(0xFF38BDF8));
      case MaxOrbState.sleep: return const MaxOrbTheme(primary: Color(0xFF4338CA), secondary: Color(0xFF6366F1));
      case MaxOrbState.syncing: return const MaxOrbTheme(primary: Color(0xFF14B8A6), secondary: Color(0xFF5EEAD4));
    }
  }

  static MaxOrbTheme fromState(MaxOrbState state) => getTheme(state);
}

class MaxOrbPainter extends CustomPainter {
  final MaxOrbState state;
  final double animation;
  MaxOrbPainter({required this.state, required this.animation});
  @override
  void paint(Canvas canvas, Size size) {
    final theme = MaxOrbTheme.getTheme(state);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final glowPaint = Paint()..shader = RadialGradient(colors: [theme.primary.withValues(alpha: .7), theme.secondary.withValues(alpha: .35), Colors.transparent]).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glowPaint);
    final orbPaint = Paint()..shader = LinearGradient(colors: [theme.secondary, theme.primary], begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(Rect.fromCircle(center: center, radius: radius * .75));
    canvas.drawCircle(center, radius * .65, orbPaint);
    final ringPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = theme.secondary.withValues(alpha: .8);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * .8), animation * 6.28, 4.5, false, ringPaint);
  }
  @override
  bool shouldRepaint(covariant MaxOrbPainter oldDelegate) => oldDelegate.state != state || oldDelegate.animation != animation;
}
