import 'package:flutter/material.dart';
import 'add_task_page.dart';
import 'stats_page.dart';
import 'package:todo_app_flutter/models/todo_item.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> tasks = [];
  TodoItem? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  Color categoryColor(String c) {
    if (c == "Work") return Colors.blue;
    if (c == "Study") return Colors.green;
    if (c == "Sport") return Colors.orange;
    return Colors.grey;
  }

  Color priorityColor(String p) {
    if (p == "High") return Colors.red;
    if (p == "Medium") return Colors.amber;
    return Colors.grey;
  }

  void addTask(TodoItem item) {
    setState(() {
      tasks.add(item);
    });
  }

  void editTask(int index, TodoItem updated) {
    setState(() {
      tasks[index] = updated;
    });
  }

  void removeTask(int index) {
    _recentlyDeleted = tasks[index];
    _recentlyDeletedIndex = index;

    setState(() {
      tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            if (_recentlyDeleted != null) {
              setState(() {
                tasks.insert(_recentlyDeletedIndex!, _recentlyDeleted!);
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            icon: Icon(
                widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
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
          "Hozircha task yo‘q",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final t = tasks[index];

          return Dismissible(
            key: Key(t.title + index.toString()),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => removeTask(index),

            child: GestureDetector(
              onTap: () async {
                /// Edit — AddTaskPage ga qaytib borib, mavjud taskni tahrirlash
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddTaskPage(existingTask: t), // Edit mode
                  ),
                );

                if (updated != null && updated is TodoItem) {
                  editTask(index, updated);
                }
              },

              child: Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: categoryColor(t.category),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: priorityColor(t.priority),
                        ),
                      ),
                    ],
                  ),

                  title: Text(
                    t.title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: t.isDone
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category: ${t.category}"),
                      if (t.deadline != null)
                        Text(
                            "Deadline: ${t.deadline!.day}/${t.deadline!.month}/${t.deadline!.year}"),
                      Text("Priority: ${t.priority}"),
                      Text(
                          "Date: ${t.date.day}/${t.date.month}/${t.date.year}"),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          t.isFavorite
                              ? Icons.star
                              : Icons.star_border,
                          color: t.isFavorite
                              ? Colors.yellow
                              : null,
                        ),
                        onPressed: () {
                          setState(() {
                            t.isFavorite = !t.isFavorite;
                          });
                        },
                      ),

                      Checkbox(
                        value: t.isDone,
                        onChanged: (v) {
                          setState(() {
                            t.isDone = v!;
                          });
                        },
                      ),
                    ],
                  ),
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
