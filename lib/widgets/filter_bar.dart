import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _chip("All"),
        _chip("Work"),
        _chip("Study"),
        _chip("Sport"),
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
