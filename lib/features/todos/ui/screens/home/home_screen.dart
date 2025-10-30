import 'package:clean_todo_tdd/di/di_config.dart';
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
                children: state.todos.map((e) {
                  return TodoItemWidget(
                    todo: e,
                    onChanged: (bool value) {
                      if (value) {
                        context.read<TodoListBloc>().add(
                              MarkTodoCompleteEvent(todoId: e.id),
                            );
                      } else {
                        context.read<TodoListBloc>().add(
                              MarkTodoIncompleteEvent(todoId: e.id),
                            );
                      }
                    },
                  );
                }).toList(),
              );
            } else {
              return Container(child: Center(child: Text('No Todos Yet')));
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
