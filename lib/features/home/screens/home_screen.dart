import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/features/home/services/home.dart';
import 'package:todo_flutter/features/home/widgets/add_to_dialog.dart';
import 'package:todo_flutter/features/home/widgets/edit_dialog.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/providers/todo.dart';

class HomeScreen extends StatelessWidget {
  static const routName = '/home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Row(
          children: [
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddTodoDialog();
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {},
              child: const Text(
                'New Reminder',
                style: TextStyle(color: Colors.deepPurple),
              ),
            )
          ],
        ),
        appBar: AppBar(
          title: const Text(
            'All',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All'), // First Tab
              Tab(text: 'Completed'), // Second Tab
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab Content
            FutureBuilder(
              future: HomeServices().getTodos(context),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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

                          return Slidable(
                            actionPane: const SlidableDrawerActionPane(),
                            secondaryActions: [
                              IconSlideAction(
                                caption: 'Edit',
                                color: Colors.green,
                                icon: Icons.edit,
                                onTap: () async {
                                  // Show the edit dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditTodoDialog(
                                        todo: todo,
                                        onEdit: (editedTodo) {
                                          todoProvider.editTodo(
                                              index: index,
                                              newTodo: editedTodo);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () async {
                                  todoProvider.deleteTodo(index, todo.id!);
                                },
                              ),
                            ],
                            child: ListTile(
                              leading: Checkbox(
                                shape: const CircleBorder(),
                                onChanged: (_) {
                                  todoProvider.toggleTodoCompletion(
                                      index, context);
                                },
                                value: todo.completed ?? false,
                              ),
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  color: Color(
                                    int.parse('0xff${todo.titleColor}'),
                                  ),
                                ),
                              ),
                              trailing: Text(todo.formattedDate),
                              subtitle: Text(todo.content),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
            // Second Tab Content
            Center(
              child: Text(
                'Second Tab',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
