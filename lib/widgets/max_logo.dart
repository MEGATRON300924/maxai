import 'package:flutter/material.dart';

import '../theme/app_animation.dart';

class MaxLogo extends StatefulWidget {
  final double size;

  const MaxLogo({
    super.key,
    this.size = 90,
  });

  @override
  State<MaxLogo> createState() => _MaxLogoState();
}

class _MaxLogoState extends State<MaxLogo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AppAnimation.slow,
    )..repeat(
      reverse: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {

        return Transform.scale(
          scale: 1 + (_controller.value * 0.04),

          child: child,
        );
      },

      child: Image.asset(
        'assets/images/app_icon.png',
        width: widget.size,
        height: widget.size,
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}