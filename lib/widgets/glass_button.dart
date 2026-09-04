import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_duration.dart';
import '../core/app_gradient.dart';
import '../core/app_radius.dart';
import '../core/app_shadow.dart';
import '../core/app_typography.dart';

class GlassButton extends StatefulWidget {
  final String text;

  final VoidCallback? onPressed;

  final Widget? leading;

  final Widget? trailing;

  final double height;

  final EdgeInsetsGeometry? padding;

  final bool loading;

  final bool enabled;

  final Gradient? gradient;

  final Color? borderColor;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.leading,
    this.trailing,
    this.height = 56,
    this.padding,
    this.loading = false,
    this.enabled = true,
    this.gradient,
    this.borderColor,
  });

  @override
  State<GlassButton> createState() =>
      _GlassButtonState();
}

class _GlassButtonState
    extends State<GlassButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled =
        !widget.enabled ||
            widget.loading ||
            widget.onPressed == null;

    return GestureDetector(
      onTapDown: disabled
          ? null
          : (_) {
              setState(() {
                pressed = true;
              });
            },
      onTapCancel: disabled
          ? null
          : () {
              setState(() {
                pressed = false;
              });
            },
      onTapUp: disabled
          ? null
          : (_) {
              setState(() {
                pressed = false;
              });

              widget.onPressed?.call();
            },
      child: AnimatedScale(
        duration:
            AppDuration.fast,
        scale:
            pressed ? .97 : 1,
        child: AnimatedOpacity(
          duration:
              AppDuration.fast,
          opacity:
              disabled ? .55 : 1,
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(
              AppRadius.xl,
            ),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                height:
                    widget.height,
                padding:
                    widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                decoration:
                    BoxDecoration(
                  gradient:
                      widget.gradient ??
                          AppGradient.glass,
                  borderRadius:
                      BorderRadius.circular(
                    AppRadius.xl,
                  ),
                  border:
                      Border.all(
                    color:
                        widget.borderColor ??
                            Colors.white
                                .withValues(
                              alpha: .12,
                            ),
                  ),
                  boxShadow:
                      AppShadow.glass,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    if (widget.loading)
                      SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    else ...[
                      if (widget.leading != null)
                        widget.leading!,
                      if (widget.leading != null)
                        const SizedBox(
                          width: 12,
                        ),
                      Expanded(
                        child: Text(
                          widget.text,
                          textAlign:
                              TextAlign.center,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: AppTypography
                              .labelLarge
                              .copyWith(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                      if (widget.trailing != null)
                        const SizedBox(
                          width: 12,
                        ),
                      if (widget.trailing != null)
                        widget.trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}