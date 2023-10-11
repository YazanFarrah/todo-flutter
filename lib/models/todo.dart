import 'package:intl/intl.dart';

class Todo {
  String? id;
  String title;
  final String titleColor;
  String content;
  bool? completed;
  String? createdAt;
  final String formattedDate;

  Todo({
    this.id,
    required this.title,
    required this.titleColor,
    required this.content,
    this.createdAt,
    this.completed,
  }) : formattedDate = _formatDate(createdAt);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      createdAt: json['createdAt'],
      title: json['title'],
      titleColor: json['titleColor'] ?? '',
      content: json['content'],
      completed: json['completed'] ?? false,
    );
  }

  static String _formatDate(String? dateStr) {
    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(dateStr);
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        return dateFormat.format(dateTime);
      } catch (e) {
        // Handle parsing/formatting errors here, e.g., return an error message
        return "Invalid Date";
      }
    } else {
      return "Not specified"; // Placeholder value when the date is not available
    }
  }
}
