// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/providers/todo.dart';

class HomeServices {
  final storage = const FlutterSecureStorage();
  Future<List<dynamic>> getTodos(BuildContext context) async {
    String? authToken = await storage.read(key: 'auth_token');
    final url = Uri.parse('http://10.0.2.2:5000/home/todos');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $authToken', // Pass the token in the Authorization header
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final todos = responseBody['todos'] as List<dynamic>;
        return todos;
      } else {
        throw Exception('Failed to fetch todos');
      }
    } catch (e) {
      throw Exception('Error during todo fetch: $e');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    String? authToken = await storage.read(key: 'auth_token');
    final url = Uri.parse('http://10.0.2.2:5000/home/todo/$todoId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successful deletion, no content
      } else {
        throw Exception('Failed to delete the todo');
      }
    } catch (e) {
      throw Exception('Error during todo deletion: $e');
    }
  }

  Future<void> updateStatus(bool status, String todoId) async {
    String? authToken = await storage.read(key: 'auth_token');
    final url = Uri.parse(
        'http://10.0.2.2:5000/home/todo-status/$todoId'); // Adjust the URL and endpoint accordingly

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(
            {'status': status}), // Include the status in the request body
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        throw Exception('Failed to update the todo status');
      }
    } catch (e) {
      throw Exception('Error during todo status update: $e');
    }
  }

  Future<void> addTodo({
    required BuildContext context,
    required String title,
    required String titleColor,
    required String content,
  }) async {
    String? authToken = await storage.read(key: 'auth_token');
    final url = Uri.parse('http://10.0.2.2:5000/home/todo');
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'title': title,
          'titleColor': titleColor,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        // Successful creation
        final responseBody = jsonDecode(response.body);
        final createdTodo = responseBody['todo'] as Map<String, dynamic>;

        // Retrieve the 'id' from the response and set it in your createdTodo
        final id = createdTodo[
            '_id']; // Assuming '_id' is the id field in your response

        // You may want to parse the response and update your local state with the newly created todo
        todoProvider.addTodo(Todo.fromJson(createdTodo)..id = id);
      } else {
        throw Exception('Failed to add the todo');
      }
    } catch (e) {
      throw Exception('Error during todo addition: $e');
    }
  }

  Future<void> updateTodo({
    required String title,
    String? titleColor,
    required String content,
    required String todoId,
  }) async {
    String? authToken = await storage.read(key: 'auth_token');
    final url = Uri.parse(
        'http://10.0.2.2:5000/home/todo-status/$todoId'); // Adjust the URL and endpoint accordingly

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(
          {
            'title': title,
            'titleColor': titleColor ?? "000000",
            'content': content,
          },
        ),
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        throw Exception('Failed to update the todo status');
      }
    } catch (e) {
      throw Exception('Error during todo status update: $e');
    }
  }
}
