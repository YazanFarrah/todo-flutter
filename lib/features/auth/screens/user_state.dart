import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_flutter/features/auth/screens/auth_screen.dart';
import 'package:todo_flutter/features/home/screens/home_screen.dart';
import 'package:todo_flutter/features/home/screens/main_screen.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data != "") {
            // User is logged in
            return const MainScreen();
          } else {
            // User is not logged in
            return const AuthScreen();
          }
        } else {
          // Display a loading indicator or another widget while checking the token.
          return const CircularProgressIndicator(); // You can replace this with a loading indicator.
        }
      },
    );
  }

  Future<String> _getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token') ??
        ""; // Return an empty string if the token is null.
  }
}
