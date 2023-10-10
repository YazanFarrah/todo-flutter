import 'package:flutter/foundation.dart';
import 'package:todo_flutter/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void setTodos(List<Todo> todos) {
    _todos = todos;
    notifyListeners();
  }

  void toggleTodoCompletion(int index) {
    _todos[index].completed = !_todos[index].completed!;
    notifyListeners();
  }

  void deleteTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }
}
