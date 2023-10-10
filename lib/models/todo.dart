import 'package:intl/intl.dart';

class Todo {
  final String title;
  final String titleColor;
  final String content;
  bool? completed;
  final String createdAt;
  final String formattedDate;

  Todo({
    required this.title,
    required this.titleColor,
    required this.content,
    required this.createdAt,
    this.completed,
  }) : formattedDate = _formatDate(createdAt);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      createdAt: json['createdAt'],
      title: json['title'],
      titleColor: json['titleColor'] ?? '',
      content: json['content'],
      completed: json['completed'] ?? false,
    );
  }

  static String _formatDate(String dateStr) {
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      return dateFormat.format(dateTime);
    } catch (e) {
      // Handle parsing/formatting errors here, e.g., return an error message
      return "Invalid Date";
    }
  }
}
