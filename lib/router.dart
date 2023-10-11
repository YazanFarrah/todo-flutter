import 'package:flutter/material.dart';
import 'package:todo_flutter/features/auth/screens/auth_screen.dart';
import 'package:todo_flutter/features/home/screens/completed_tasks.dart';
import 'package:todo_flutter/features/home/screens/home_screen.dart';
import 'package:todo_flutter/features/home/screens/main_screen.dart';

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
    case CompletedTasks.routName:
      return MaterialPageRoute(
        builder: (builder) => const CompletedTasks(),
      );
    case MainScreen.routName:
      return MaterialPageRoute(
        builder: (builder) => const MainScreen(),
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
