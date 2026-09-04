import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_animation.dart';
import '../theme/app_colors.dart';

class MaxLoader extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const MaxLoader({
    super.key,
    this.size = 42,
    this.strokeWidth = 3,
    this.color,
  });

  @override
  State<MaxLoader> createState() => _MaxLoaderState();
}

class _MaxLoaderState extends State<MaxLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AppAnimation.loading,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loaderColor = widget.color ?? AppColors.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _MaxLoaderPainter(
              progress: _controller.value,
              color: loaderColor,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _MaxLoaderPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  const _MaxLoaderPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweep = 1.5 + (math.sin(progress * math.pi * 2) * .7);

    final start = progress * math.pi * 2;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth,
      ),
      start,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MaxLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}