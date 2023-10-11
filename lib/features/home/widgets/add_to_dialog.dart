import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/features/home/services/home.dart';
import 'package:todo_flutter/models/todo.dart';
import 'package:todo_flutter/providers/todo.dart';

class AddTodoDialog extends StatefulWidget {
  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  String title = '';
  String content = '';
  Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Add Todo'),
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
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  content = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Content'),
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
              // Validate the input
              if (title.isEmpty || content.isEmpty) {
                // Handle validation error
                // You can show a snackbar or an error message here
              } else {
                // Add the todo with the provided data
                HomeServices().addTodo(
                  context: context,
                  title: title,
                  content: content,
                  titleColor: colorToHex(selectedColor),
                );

                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String colorToHex(Color color) {
    return color.value.toRadixString(16).substring(2);
  }
}
