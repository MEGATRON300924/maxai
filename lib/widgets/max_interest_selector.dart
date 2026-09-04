import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'max_choice_grid.dart';

class MaxInterestSelector extends StatefulWidget {
  final List<String> interests;

  final ValueChanged<List<String>> onChanged;

  const MaxInterestSelector({
    super.key,
    required this.interests,
    required this.onChanged,
  });

  @override
  State<MaxInterestSelector> createState() =>
      _MaxInterestSelectorState();
}

class _MaxInterestSelectorState
    extends State<MaxInterestSelector> {

  late List<String> _selected;

  final List<String> _options = const [

    "Technology",
    "Artificial Intelligence",
    "Programming",
    "Business",
    "Gaming",
    "Music",
    "Movies",
    "Photography",
    "Design",
    "Science",
    "Travel",
    "Fitness",
    "Sports",
    "Books",
    "Content Creation",
    "Finance",

  ];

  @override
  void initState() {
    super.initState();

    _selected = List.from(
      widget.interests,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(
        top: AppSpacing.md,
      ),

      child: MaxChoiceGrid(

        options: _options,

        selectedOptions: _selected,

        multiSelect: true,

        onChanged: (values) {

          setState(() {

            _selected = values;

          });

          widget.onChanged(values);

        },

      ),

    );

  }

}