import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'max_choice_grid.dart';

class MaxSingleChoiceSelector extends StatefulWidget {
  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;

  const MaxSingleChoiceSelector({
    super.key,
    required this.options,
    required this.onChanged,
    this.value,
  });

  @override
  State<MaxSingleChoiceSelector> createState() =>
      _MaxSingleChoiceSelectorState();
}

class _MaxSingleChoiceSelectorState
    extends State<MaxSingleChoiceSelector> {

  late List<String> _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.value == null
        ? []
        : [widget.value!];
  }

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(
        top: AppSpacing.md,
      ),

      child: MaxChoiceGrid(

        options: widget.options,

        selectedOptions: _selected,

        multiSelect: false,

        onChanged: (value) {

          setState(() {

            _selected = value;

          });

          if (value.isNotEmpty) {

            widget.onChanged(
              value.first,
            );

          }

        },

      ),

    );

  }

}