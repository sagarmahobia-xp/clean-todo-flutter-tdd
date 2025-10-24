import 'package:bloc_test/bloc_test.dart';
import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:clean_todo_tdd/features/todos/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

class TodoListBlocMock extends Mock implements TodoListBloc {
  @override
  Future<void> close() async {}
}

void main() {
  group('Group- UI - Home', () {
    late final TodoListBloc bloc;

    setUpAll(() async {
      await configureDependencies(environment: Environment.test);
      getIt.allowReassignment = true;
      bloc = TodoListBlocMock();
      getIt.registerFactory<TodoListBloc>(() => bloc);
    });

    testWidgets('Test - App bar', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      var titleTxt = find.text('Todo List');

      expect(titleTxt, findsOneWidget);
    });

    testWidgets('Test - Empty List state', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoading(),
          TodoListLoaded(todos: []),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      var noTodoText = find.text('No Todos Yet');

      expect(noTodoText, findsOneWidget);
    });

    testWidgets('Test - Todo List Loading State', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListInitial(),
          TodoListLoading(),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pump();

      //await tester.pumpAndSettle();
      /*
       pump and settle will not work since it will never settle because circular
       progress animation will prevent it
      */

      var widget = find.byType(CircularProgressIndicator);

      expect(widget, findsOneWidget);
    });

    testWidgets('Test - Single Todo State', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoading(),
          TodoListLoaded(
            todos: [
              TodoEntity(id: 1, title: 'Test Todo', content: 'First Todo'),
            ],
          ),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      var firstTodo = find.text('Test Todo');
      var firstTodoContent = find.text('First Todo');

      expect(firstTodo, findsOneWidget);
      expect(firstTodoContent, findsOneWidget);
    });

    testWidgets('Test - add button present in homescreen', (tester) async {
      //FloatingActionButton
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      var fab = find.byType(FloatingActionButton);

      expect(fab, findsOneWidget);
    });
  });
}
