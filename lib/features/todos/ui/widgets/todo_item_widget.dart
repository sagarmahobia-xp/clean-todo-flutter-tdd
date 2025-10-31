import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Checkbox
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: todo.completed ? Colors.green[600]! : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: todo.completed ? Colors.green[600] : Colors.transparent,
                ),
                child: Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      shape: CircleBorder(),
                    ),
                  ),
                  child: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      if (value != null) {
                        onChanged(value);
                      }
                    },
                    activeColor: Colors.transparent,
                    checkColor: Colors.white,
                    side: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: todo.completed ? TextDecoration.lineThrough : null,
                        decorationThickness: 2,
                        decorationColor: todo.completed ? Colors.grey : null,
                        color: todo.completed ? Colors.grey[700] : Colors.grey[900],
                      ),
                    ),
                    if (todo.content != null && todo.content!.isNotEmpty) ...[
                      SizedBox(height: 6),
                      Text(
                        todo.content!,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: todo.completed ? TextDecoration.lineThrough : null,
                          decorationThickness: 2,
                          decorationColor: todo.completed ? Colors.grey : null,
                          color: todo.completed ? Colors.grey[600] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 12),
              // Delete button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[600]),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  onPressed: onDelete,
                  tooltip: 'Delete todo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
