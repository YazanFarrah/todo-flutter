import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<List<dynamic>> getTodos(BuildContext context) async {
    const storage = FlutterSecureStorage();
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
}
