import 'package:flutter/material.dart';

import '../models/max_activity.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/max_activity_indicator.dart';
import 'max_chat_bubble.dart';

class MaxResponseContainer extends StatelessWidget {

  final bool isThinking;

  final MaxActivity activity;

  final String? response;

  const MaxResponseContainer({
    super.key,
    required this.isThinking,
    required this.activity,
    this.response,
  });

  @override
  Widget build(BuildContext context) {

    if (isThinking) {

      return Padding(

        padding: const EdgeInsets.only(
          top: AppSpacing.md,
        ),

        child: MaxActivityIndicator(
          activity: activity,
        ),

      );

    }

    if (response == null) {

      return const SizedBox.shrink();

    }

    return MaxChatBubble(

      message: ConversationMessage(

        text: response!,

        fromMax: true,

        createdAt: DateTime.now(),

      ),

    );

  }

}