import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'max_option_chip.dart';

class MaxChoiceGrid extends StatelessWidget {
  final List<String> options;

  final List<String> selectedOptions;

  final bool multiSelect;

  final ValueChanged<List<String>> onChanged;

  const MaxChoiceGrid({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
    this.multiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((option) {
        final selected = selectedOptions.contains(option);

        return MaxOptionChip(
          title: option,
          selected: selected,
          onTap: () {
            final values = List<String>.from(
              selectedOptions,
            );

            if (multiSelect) {
              if (selected) {
                values.remove(option);
              } else {
                values.add(option);
              }
            } else {
              values
                ..clear()
                ..add(option);
            }

            onChanged(values);
          },
        );
      }).toList(),
    );
  }
}