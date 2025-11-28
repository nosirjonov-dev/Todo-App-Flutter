import 'package:flutter/material.dart';
import 'add_task_page.dart';

class TodoItem {
  String title;
  String category;
  bool isDone;
  DateTime? deadline;
  String priority;
  bool isFavorite;

  TodoItem(this.title, this.category, this.isDone,
      {this.deadline, this.priority = "Low", this.isFavorite = false});
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomePage({super.key, required this.isDarkMode, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> tasks = [];
  String selectedFilter = "All";
  String searchQuery = "";
  String sortOption = "None";

  TodoItem? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  Color categoryColor(String c) {
    if (c == "Work") return Colors.blue;
    if (c == "Study") return Colors.green;
    if (c == "Home") return Colors.orange;
    return Colors.grey;
  }

  Color priorityColor(String p) {
    if (p == "High") return Colors.red;
    if (p == "Medium") return Colors.amber;
    return Colors.grey;
  }

  List<TodoItem> getFilteredTasks() {
    List<TodoItem> filtered = selectedFilter == "All"
        ? tasks
        : tasks.where((t) => t.category == selectedFilter).toList();

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
              (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (sortOption == "Priority") {
      filtered.sort((a, b) {
        const order = {"High": 3, "Medium": 2, "Low": 1};
        return (order[b.priority] ?? 0).compareTo(order[a.priority] ?? 0);
      });
    } else if (sortOption == "Deadline") {
      filtered.sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8))),
                    ),
                    onChanged: (v) {
                      setState(() {
                        searchQuery = v;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: (v) {
                    setState(() {
                      sortOption = v;
                    });
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: "None", child: Text("None")),
                    const PopupMenuItem(
                        value: "Priority", child: Text("Priority")),
                    const PopupMenuItem(
                        value: "Deadline", child: Text("Deadline")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            filterChip("All"),
            filterChip("Work"),
            filterChip("Study"),
            filterChip("Home"),
          ],
        ),
      ),

      // Drag & Drop / ReorderableListView
      body: ReorderableListView.builder(
        itemCount: filteredTasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = tasks.removeAt(tasks.indexOf(filteredTasks[oldIndex]));
            tasks.insert(tasks.indexOf(filteredTasks[newIndex]), item);
          });
        },
        itemBuilder: (context, index) {
          final t = filteredTasks[index];

          return Card(
            key: ValueKey(t),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: categoryColor(t.category),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: priorityColor(t.priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              title: Text(
                t.title,
                style: TextStyle(
                  decoration: t.isDone ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.category),
                  if (t.deadline != null)
                    Text(
                        "Deadline: ${t.deadline!.day}/${t.deadline!.month}/${t.deadline!.year}"),
                  Text("Priority: ${t.priority}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      t.isFavorite ? Icons.star : Icons.star_border,
                      color: t.isFavorite ? Colors.yellow : null,
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
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _recentlyDeleted = t;
                      _recentlyDeletedIndex = tasks.indexOf(t);
                      setState(() {
                        tasks.remove(t);
                      });
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Task deleted"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              if (_recentlyDeleted != null &&
                                  _recentlyDeletedIndex != null) {
                                setState(() {
                                  tasks.insert(
                                      _recentlyDeletedIndex!, _recentlyDeleted!);
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskPage()),
          );

          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget filterChip(String label) {
    final bool selected = selectedFilter == label;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (v) {
        setState(() {
          selectedFilter = label;
        });
      },
    );
  }
}
