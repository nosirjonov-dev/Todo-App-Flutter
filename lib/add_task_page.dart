import 'package:flutter/material.dart';
import 'home_page.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController controller = TextEditingController();
  String selectedCategory = "Work";
  String selectedPriority = "Low";
  DateTime? selectedDeadline;
  bool isFavorite = false;

  Future<void> pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        title: const Text("Add Task"),
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
                hintText: "Enter task...",
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
              onChanged: (v) {
                setState(() {
                  selectedCategory = v!;
                });
              },
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
              onChanged: (v) {
                setState(() {
                  selectedPriority = v!;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Deadline: "),
                Text(selectedDeadline == null
                    ? "No date"
                    : "${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}"),
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
                      false,
                      deadline: selectedDeadline,
                      priority: selectedPriority,
                      isFavorite: isFavorite,
                    ),
                  );
                },
                child: const Text("Add Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
