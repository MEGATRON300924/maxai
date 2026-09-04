import 'dart:math';

import 'package:flutter/material.dart';

import '../models/max_orb_state.dart';

class MaxOrbParticle {
  final double angle;
  final double distance;
  final double size;
  final double speed;

  const MaxOrbParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.speed,
  });
}

class MaxOrbParticlesPainter extends CustomPainter {
  final MaxOrbState state;
  final double animationValue;
  final double intensity;

  MaxOrbParticlesPainter({
    required this.state,
    required this.animationValue,
    required this.intensity,
  });

  final List<MaxOrbParticle> particles = const [
    MaxOrbParticle(angle: .2, distance: .75, size: 3, speed: 1),
    MaxOrbParticle(angle: 1.5, distance: .85, size: 4, speed: .7),
    MaxOrbParticle(angle: 3.2, distance: .9, size: 2, speed: 1.4),
    MaxOrbParticle(angle: 5.1, distance: .8, size: 3, speed: .9),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (!_shouldShowParticles()) return;

    final center = Offset(size.width / 2, size.height / 2);
    final orbRadius = size.width / 2;
    final theme = MaxOrbTheme.fromState(state);
    final paint = Paint()..color = theme.secondary.withValues(alpha: .8);

    for (final particle in particles) {
      final rotation = particle.angle + animationValue * particle.speed;
      final distance = orbRadius * particle.distance;
      final x = center.dx + cos(rotation) * distance;
      final y = center.dy + sin(rotation) * distance;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * intensity,
        paint,
      );
    }
  }

  bool _shouldShowParticles() {
    return state == MaxOrbState.thinking ||
        state == MaxOrbState.wakeDetected ||
        state == MaxOrbState.syncing ||
        state == MaxOrbState.sos;
  }

  @override
  bool shouldRepaint(covariant MaxOrbParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.state != state;
  }
}
