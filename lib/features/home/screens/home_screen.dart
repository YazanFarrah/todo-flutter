import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/features/home/services/home.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/providers/todo.dart';

class HomeScreen extends StatelessWidget {
  static const routName = '/home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: FutureBuilder(
        future: HomeServices().getTodos(context),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<dynamic> todos = snapshot.data!;

            // Use a post-frame callback to update the state after the build is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<TodoProvider>(context, listen: false).setTodos(
                todos.map((todoData) => Todo.fromJson(todoData)).toList(),
              );
            });

            return Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return ListView.builder(
                  itemCount: todoProvider.todos.length,
                  itemBuilder: (context, index) {
                    Todo todo = todoProvider.todos[index];

                    return ListTile(
                      leading: Checkbox(
                        shape: const CircleBorder(),
                        onChanged: (_) {
                          todoProvider.toggleTodoCompletion(index);
                        },
                        value: todo.completed ?? false,
                      ),
                      title: Text(todo.title),
                      trailing: Text(todo.formattedDate),
                      subtitle: Text(todo.content),
                      // subtitle: Text(todo.formattedDate),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.delete),
                      //   onPressed: () {
                      //     todoProvider.deleteTodo(index);
                      //   },
                      // ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
