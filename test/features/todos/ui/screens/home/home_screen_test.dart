import 'package:bloc_test/bloc_test.dart';
import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:clean_todo_tdd/features/todos/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class TodoListBlocMock extends Mock implements TodoListBloc {
  @override
  Future<void> close() async {}
}

void main() {
  group("Group- UI - Home", () {
    late final TodoListBloc bloc;

    setUpAll(() {
      configureDependencies();
      getIt.allowReassignment = true;
      bloc = TodoListBlocMock();
      getIt.registerFactory<TodoListBloc>(() => bloc);
    });

    testWidgets('Test - App bar', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[]),
        initialState: const TodoListLoaded(todos: []),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      var titleTxt = find.text("Todo List");

      expect(titleTxt, findsOneWidget);
    });

    testWidgets('Test - Empty List state', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[]),
        initialState: const TodoListLoaded(todos: []),
      );

      await tester.pumpAndSettle();
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      var noTodoText = find.text("No Todos Yet");

      expect(noTodoText, findsOneWidget);
    });
  });
}
