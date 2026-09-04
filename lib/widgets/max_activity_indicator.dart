import 'package:flutter/material.dart';

import '../models/max_activity.dart';
import '../services/max_activity_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class MaxActivityIndicator extends StatefulWidget {
  final MaxActivity activity;

  const MaxActivityIndicator({
    super.key,
    required this.activity,
  });

  @override
  State<MaxActivityIndicator> createState() =>
      _MaxActivityIndicatorState();
}

class _MaxActivityIndicatorState
    extends State<MaxActivityIndicator>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    )..repeat();
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }

  IconData _icon() {

    switch (widget.activity) {

      case MaxActivity.listening:
        return Icons.mic_rounded;

      case MaxActivity.searching:
        return Icons.travel_explore_rounded;

      case MaxActivity.coding:
        return Icons.code_rounded;

      case MaxActivity.generatingImage:
        return Icons.palette_rounded;

      case MaxActivity.editingImage:
        return Icons.brush_rounded;

      case MaxActivity.analyzingImage:
        return Icons.image_search_rounded;

      case MaxActivity.analyzingDocument:
        return Icons.description_rounded;

      case MaxActivity.music:
        return Icons.graphic_eq_rounded;

      case MaxActivity.remembering:
        return Icons.psychology_alt_rounded;

      case MaxActivity.savingMemory:
        return Icons.bookmark_added_rounded;

      case MaxActivity.translating:
        return Icons.translate_rounded;

      case MaxActivity.writing:
        return Icons.edit_note_rounded;

      case MaxActivity.uploading:
        return Icons.upload_rounded;

      case MaxActivity.downloading:
        return Icons.download_rounded;

      case MaxActivity.speaking:
        return Icons.volume_up_rounded;

      case MaxActivity.summarizing:
        return Icons.short_text_rounded;

      case MaxActivity.reasoning:
        return Icons.auto_awesome_rounded;

      case MaxActivity.thinking:
        return Icons.blur_on_rounded;

      case MaxActivity.idle:
        return Icons.circle;

    }

  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: _controller,

      builder: (_, __) {

        final scale =
            1 + (_controller.value * .08);

        return Transform.scale(

          scale: scale,

          child: Container(

            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),

            decoration: BoxDecoration(

              color: Colors.white.withValues(
                alpha: .06,
              ),

              borderRadius:
                  BorderRadius.circular(20),

              border: Border.all(
                color: AppColors.border,
              ),

            ),

            child: Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                Icon(
                  _icon(),
                  color: AppColors.primary,
                  size: 20,
                ),

                const SizedBox(
                  width: AppSpacing.md,
                ),

                Text(

                  MaxActivityService.message(
                    widget.activity,
                  ),

                  style:
                      AppTypography.bodyMedium,

                ),

              ],

            ),

          ),

        );

      },

    );

  }

}