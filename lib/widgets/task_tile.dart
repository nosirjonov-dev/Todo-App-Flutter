import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TaskTile extends StatelessWidget {
  final TodoItem item;
  final VoidCallback onToggleFavorite;
  final ValueChanged<bool> onToggleDone;
  final VoidCallback onDelete;
  final Color Function(String) categoryColor;
  final Color Function(String) priorityColor;

  const TaskTile({
    super.key,
    required this.item,
    required this.onToggleFavorite,
    required this.onToggleDone,
    required this.onDelete,
    required this.categoryColor,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: categoryColor(item.category),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: priorityColor(item.priority),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isDone ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.category),
            if (item.deadline != null)
              Text(
                "Deadline: ${item.deadline!.day}/${item.deadline!.month}/${item.deadline!.year}",
              ),
            Text("Priority: ${item.priority}"),
            Text(
              "Date: ${item.date.day}/${item.date.month}/${item.date.year}",
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                item.isFavorite ? Icons.star : Icons.star_border,
                color: item.isFavorite ? Colors.yellow : null,
              ),
              onPressed: onToggleFavorite,
            ),
            Checkbox(
              value: item.isDone,
              onChanged: (v) => onToggleDone(v ?? false),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
