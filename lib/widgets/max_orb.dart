import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'max_svg_icon.dart';

class MaxOrb extends StatefulWidget {
  final double size;
  final bool listening;

  const MaxOrb({super.key, this.size = 180, this.listening = false});

  @override
  State<MaxOrb> createState() => _MaxOrbState();
}

class _MaxOrbState extends State<MaxOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * (widget.listening ? 0.08 : 0.05));
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF06B6D4), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: AppColors.glowStrong, blurRadius: 50, spreadRadius: widget.listening ? 20 : 15)],
            ),
            child: Center(child: MaxSvgIcon(asset: 'voice', size: widget.size * 0.35)),
          ),
        );
      },
    );
  }
}
