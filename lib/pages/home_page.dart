import 'package:flutter/material.dart';
import 'add_task_page.dart';
import 'stats_page.dart';
import 'package:todo_app_flutter/models/todo_item.dart'; // TodoItem model is here

class HomePage extends StatefulWidget {
  const HomePage({super.key, required bool isDarkMode, required void Function() onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> tasks = [];

  void addTask(TodoItem item) {
    setState(() {
      tasks.add(item);
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatsPage(tasks: tasks),
                ),
              );
            },
          ),
        ],
      ),

      body: tasks.isEmpty
          ? const Center(
        child: Text(
          "Hozircha task qo‘shilmagan",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final item = tasks[index];

          return Dismissible(
            key: Key(item.title + index.toString()),
            background: Container(
              color: Colors.red.shade400,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) => removeTask(index),

            child: GestureDetector(
              onTap: () => toggleTask(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(
                    vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: item.isDone
                      ? Colors.green.shade50
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.isDone
                        ? Colors.green.shade300
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.isDone
                            ? Colors.green
                            : Colors.transparent,
                        border: Border.all(
                          color: item.isDone
                              ? Colors.green
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: item.isDone
                          ? const Icon(Icons.check,
                          color: Colors.white, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          decoration: item.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        child: Text(item.title),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskPage(),
            ),
          );

          if (result != null && result is TodoItem) {
            addTask(result);
          }
        },
      ),
    );
  }
}
