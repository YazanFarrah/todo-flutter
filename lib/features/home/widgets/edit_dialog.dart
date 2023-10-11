import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todo_flutter/models/todo.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onEdit;

  EditTodoDialog({required this.todo, required this.onEdit});

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  String title = '';
  String content = '';
  Color selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    title = widget.todo.title;
    content = widget.todo.content;
    // Set the selectedColor to the value from the todo.
    // You might need to parse it if it's stored as a hex value.
    selectedColor = Color(int.parse('0xff${widget.todo.titleColor}'));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Title'),
              controller: TextEditingController(text: title),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  content = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Content'),
              controller: TextEditingController(text: content),
            ),
            const SizedBox(height: 10),
            ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Validate the input
              if (title.isEmpty || content.isEmpty) {
                // Handle validation error
                // You can show a snackbar or an error message here
              } else {
                final editedTodo = Todo(
                    id: widget.todo.id,
                    title: title,
                    content: content,
                    titleColor: colorToHex(selectedColor),
                    createdAt: widget.todo.createdAt,
                    completed: widget.todo.completed
                    // Other properties as needed
                    );
                widget.onEdit(
                    editedTodo); // Pass the edited todo back to the parent widget
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
