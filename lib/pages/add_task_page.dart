import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class AddTaskPage extends StatefulWidget {
  final TodoItem? existingTask;

  const AddTaskPage({super.key, this.existingTask});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController controller = TextEditingController();

  String selectedCategory = "Work";
  String selectedPriority = "Low";
  DateTime? selectedDeadline;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    // Agar edit bo‘lsa — we are loading old data
    if (widget.existingTask != null) {
      final t = widget.existingTask!;
      controller.text = t.title;
      selectedCategory = t.category;
      selectedPriority = t.priority ?? "Low";
      selectedDeadline = t.deadline;
      isFavorite = t.isFavorite ?? false;
    }
  }

  Future<void> pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectedDeadline = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTask == null ? "Add Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Task title"),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter your task...",
              ),
            ),

            const SizedBox(height: 20),

            const Text("Select category"),
            DropdownButton<String>(
              value: selectedCategory,
              items: ["Work", "Study", "Sport"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v!),
            ),

            const SizedBox(height: 20),

            const Text("Select priority"),
            DropdownButton<String>(
              value: selectedPriority,
              items: ["Low", "Medium", "High"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (v) => setState(() => selectedPriority = v!),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text("Deadline: "),
                Text(
                  selectedDeadline == null
                      ? "No date"
                      : "${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}",
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: pickDeadline,
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text("Mark as Favorite"),
                Checkbox(
                  value: isFavorite,
                  onChanged: (v) {
                    setState(() {
                      isFavorite = v!;
                    });
                  },
                ),
              ],
            ),

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;

                  Navigator.pop(
                    context,
                    TodoItem(
                      controller.text.trim(),
                      selectedCategory,
                      widget.existingTask?.isDone ?? false,
                      deadline: selectedDeadline,
                      priority: selectedPriority,
                      isFavorite: isFavorite,
                      date: selectedDeadline ?? DateTime.now(),
                    ),
                  );
                },
                child: Text(
                    widget.existingTask == null ? "Add Task" : "Save Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
