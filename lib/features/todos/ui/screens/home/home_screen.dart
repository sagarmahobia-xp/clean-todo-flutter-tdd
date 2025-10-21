import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
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
      appBar: AppBar(title: Text("Todo List")),
      body: BlocBuilder<TodoListBloc, TodoListState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is TodoListLoaded && state.todos.isNotEmpty) {
            return ListView(
              children: state.todos.map((e) {
                return Column(
                  children: [Text(e.title), Text(e.content ?? "N/A")],
                );
              }).toList(),
            );
          }

          return Container(child: Center(child: Text("No Todos Yet")));
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
