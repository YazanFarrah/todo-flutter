import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/features/home/services/home.dart';
import 'package:todo_flutter/features/home/widgets/add_to_dialog.dart';
import 'package:todo_flutter/features/home/widgets/edit_dialog.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/providers/todo.dart';

class SortingPreferences {
  final _storage = const FlutterSecureStorage();
  static const _sortingKey = 'sorting_preference';

  Future<void> setSortingPreference(String preference) async {
    await _storage.write(key: _sortingKey, value: preference);
  }

  Future<String?> getSortingPreference() async {
    return await _storage.read(key: _sortingKey);
  }
}

class CompletedTasks extends StatefulWidget {
  static const routName = '/completed-tasks';

  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  final SortingPreferences _sortingPreferences = SortingPreferences();
  bool _isDescending = true; // Default sorting order

  @override
  void initState() {
    super.initState();
    _loadSortingPreference();
  }

  void _loadSortingPreference() async {
    String? preference = await _sortingPreferences.getSortingPreference();
    if (preference != null) {
      setState(() {
        _isDescending = preference == 'descending';
      });
    }
  }

  void _toggleSorting() {
    setState(() {
      _isDescending = !_isDescending;
      String preference = _isDescending ? 'descending' : 'ascending';
      _sortingPreferences.setSortingPreference(preference);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Completed Tasks',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon:
                Icon(_isDescending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: _toggleSorting,
          ),
        ],
      ),
      body: FutureBuilder(
        future: HomeServices().getCompletedTodos(context),
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
                    List<Todo> sortedTodos = _isDescending
                        ? [...todoProvider.todos] // Sorting in descending order
                        : [
                            ...todoProvider.todos.reversed
                          ]; // Sorting in ascending order
                    Todo todo = sortedTodos[index];

                    return Column(
                      children: [
                        Slidable(
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
                                      todo:
                                          todo, // Pass the todo to the edit dialog
                                      onEdit: (editedTodo) {
                                        // Handle the edited todo here
                                        todoProvider.editTodo(
                                            todoId: editedTodo.id!,
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
                                fontWeight: FontWeight.w900,
                                color: Color(
                                  int.parse(
                                    '0xff${todo.titleColor}',
                                  ),
                                ),
                              ),
                            ),
                            trailing: Text(todo.formattedDate),
                            subtitle: Text(todo.content),
                          ),
                        ),
                        const Divider(
                          indent: 15,
                          endIndent: 15,
                        ),
                      ],
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
