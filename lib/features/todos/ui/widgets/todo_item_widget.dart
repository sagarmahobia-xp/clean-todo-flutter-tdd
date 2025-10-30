import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoEntity todo;
  final Function(bool) onChanged;
  final VoidCallback? onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (bool? value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed ? Colors.grey : null,
          ),
        ),
        subtitle: todo.content != null && todo.content!.isNotEmpty
            ? Text(
                todo.content!,
                style: TextStyle(
                  decoration: todo.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color: todo.completed ? Colors.grey : null,
                ),
              )
            : null,
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
