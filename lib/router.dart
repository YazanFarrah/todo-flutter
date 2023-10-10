import 'package:flutter/material.dart';
import 'package:todo_flutter/features/auth/screens/auth_screen.dart';
import 'package:todo_flutter/features/home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routName:
      return MaterialPageRoute(
        builder: (builder) => const AuthScreen(),
      );
    case HomeScreen.routName:
      return MaterialPageRoute(
        builder: (builder) => const HomeScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (builder) => const Scaffold(
          body: Center(
            child: Text('Screen doesn\'t exist'),
          ),
        ),
      );
  }
}
