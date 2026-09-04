import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'max_logo.dart';

class MaxEmptyChat extends StatelessWidget {
  const MaxEmptyChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MaxLogo(
              size: 90,
            ),
            const SizedBox(
              height: AppSpacing.xl,
            ),
            Text(
              "How can I help today?",
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            Text(
              "Ask anything. Search the web, generate images, write code, solve problems, play music, or just have a conversation.",
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}