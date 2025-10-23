import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoFormWidget extends StatefulWidget {
  const AddTodoFormWidget({super.key});

  @override
  State<AddTodoFormWidget> createState() => _AddTodoFormWidgetState();
}

class _AddTodoFormWidgetState extends State<AddTodoFormWidget> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<TodoListBloc>();

    return BlocListener<TodoListBloc, TodoListState>(
      listener: (context, state) {
        if (state is TodoListLoaded) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Todo',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            TextFormField(
              key: const Key('titleField'),
              controller: titleController,
              decoration: InputDecoration(hintText: 'Enter Title'),
            ),
            TextFormField(
              key: const Key('contentField'),
              controller: contentController,
              decoration: InputDecoration(hintText: 'Enter Content'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: const Key('addButton'),
              onPressed: () {
                bloc.add(
                  AddTodoEvent(
                    title: titleController.text,
                    content: contentController.text,
                  ),
                );
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
