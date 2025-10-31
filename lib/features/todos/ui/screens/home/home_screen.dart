import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:clean_todo_tdd/features/todos/ui/widgets/add_todo_form_widget.dart';
import 'package:clean_todo_tdd/features/todos/ui/widgets/todo_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bloc = getIt<TodoListBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(LoadTodosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: BlocProvider.value(
                  value: bloc,
                  child: AddTodoFormWidget(),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<TodoListBloc, TodoListState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is TodoListLoaded) {
            if (state.todos.isNotEmpty) {
              return ListView(
                children: state.todos.map((todo) {
                  return TodoItemWidget(
                    todo: todo,
                    onChanged: (e) {
                      onCheckOrUncheckOfTodoDispatchEventToBloc(e, todo);
                    },
                    onDelete: () {
                      bloc.add(DeleteTodoEvent(todoId: todo.id));
                    },
                  );
                }).toList(),
              );
            } else {
              return Container(child: Center(child: Text('No Todos Yet')));
            }
          }
          
          if (state is TodoListLoadError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(LoadTodosEvent());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void onCheckOrUncheckOfTodoDispatchEventToBloc(
    bool value,
    TodoEntity e,
  ) {
    if (value) {
      bloc.add(
        MarkTodoCompleteEvent(todoId: e.id),
      );
    } else {
      bloc.add(
        MarkTodoIncompleteEvent(todoId: e.id),
      );
    }
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
