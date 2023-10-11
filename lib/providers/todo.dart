// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_flutter/features/home/services/home.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void setTodos(List<Todo> todos) {
    _todos = todos;
    notifyListeners();
  }

  final storage = const FlutterSecureStorage();

  Future<void> toggleTodoCompletion(int index, BuildContext context) async {
    final todo = _todos[index];
    final newStatus = !(todo.completed ?? false);

    // Instantly update the UI
    _todos[index].completed = newStatus;
    notifyListeners();

    try {
      await HomeServices().updateStatus(newStatus, todo.id!);
      // The operation was successful; no need to do anything
    } catch (e) {
      // Handle error - revert the UI state to the previous value
      _todos[index].completed = !newStatus;
      notifyListeners();

      // Show an error message (e.g., snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update the todo status: $e'),
        ),
      );
    }
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void editTodo({
    required String todoId, // Pass the unique todo id
    required Todo newTodo,
  }) async {
    String? authToken = await storage.read(key: 'auth_token');
    final url = Uri.parse(
        'http://10.0.2.2:5000/home/todo/$todoId'); // Use the unique todoId in the URL
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'title': newTodo.title,
          'titleColor': newTodo.titleColor,
          'content': newTodo.content,
        }),
      );

      if (response.statusCode == 200) {
        // Successful update, update the UI
        final index = _todos.indexWhere((todo) => todo.id == todoId);
        if (index != -1) {
          _todos[index] = newTodo; // Update the local list with the edited todo
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update the todo');
      }
    } catch (e) {
      throw Exception('Error during todo update: $e');
    }
  }

  void deleteTodo(int index, String todoId) async {
    _todos.removeAt(index);
    HomeServices().deleteTodo(todoId);
    notifyListeners();
  }
}
