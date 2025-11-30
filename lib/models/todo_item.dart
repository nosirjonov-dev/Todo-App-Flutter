class TodoItem {
  String title;
  String category;
  bool isDone;
  DateTime? deadline;
  String priority;
  bool isFavorite;
  DateTime date;

  TodoItem(
      this.title,
      this.category,
      this.isDone, {
        this.deadline,
        this.priority = "Low",
        this.isFavorite = false,
        required this.date,
      });
}
