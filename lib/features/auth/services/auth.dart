// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_flutter/features/auth/screens/auth_screen.dart';
import 'package:todo_flutter/features/home/screens/home_screen.dart';
import 'package:todo_flutter/features/home/screens/main_screen.dart';

class AuthServices {
  Future<void> signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/auth/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        print('Registration successful');
      } else {
        // Registration failed
        print('Registration failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Error occurred during the HTTP request
      print('Error during signup: $e');
    }
  }

  final storage = const FlutterSecureStorage();

  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Sign-in successful
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'] as String;

        // Save the token to Flutter Secure Storage
        await storage.write(key: 'auth_token', value: token);
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.routName, (route) => false);
        print('Sign-in successful');
      } else {
        // Sign-in failed
        print('Sign-in failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Error occurred during the HTTP request
      print('Error during sign-in: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Remove the token from Flutter Secure Storage
      await storage.delete(key: 'auth_token').then((value) =>
          Navigator.pushReplacementNamed(context, AuthScreen.routName));

      print('Logged out successfully');
    } catch (e) {
      // Handle any errors that may occur during logout
      print('Error during logout: $e');
    }
  }
}
