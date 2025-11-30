import 'package:flutter/material.dart';

class DailyFilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const DailyFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _chip("Today"),
        _chip("Tomorrow"),
        _chip("All"),
      ],
    );
  }

  Widget _chip(String label) {
    final bool isSelected = selected == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(label),
    );
  }
}
