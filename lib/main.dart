import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/features/auth/screens/user_state.dart';
import 'package:todo_flutter/providers/drawer_controller.dart';
import 'package:todo_flutter/providers/todo.dart';
import 'package:todo_flutter/providers/user.dart';
import 'package:todo_flutter/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context) => MenuAppController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: const UserState(),
      ),
    );
  }
}
