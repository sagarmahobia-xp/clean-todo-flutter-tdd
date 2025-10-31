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
    late TodoListBloc bloc;

    setUpAll(() async {
      await configureDependencies(environment: Environment.test);
      getIt.allowReassignment = true;
    });

    setUp(() {
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

      var titleTxt = find.text('Clean Todos');

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
      var noTodoText = find.text('No todos yet!');

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
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoaded(todos: []),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      var fab = find.byType(FloatingActionButton);

      expect(fab, findsOneWidget);
    });

    testWidgets('Test - Marking todo as complete dispatches correct event', (
      tester,
    ) async {
      final testTodos = [
        TodoEntity(
          id: 1,
          title: 'Incomplete Todo',
          content: 'Content',
          completed: false,
        ),
      ];

      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoading(),
          TodoListLoaded(todos: testTodos),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      final titleFinder = find.text('Incomplete Todo');
      final titleWidget = tester.widget<Text>(titleFinder);
      final titleStyle = titleWidget.style as TextStyle;
      expect(titleStyle.decoration, isNot(TextDecoration.lineThrough));

      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      verify(() => bloc.add(const MarkTodoCompleteEvent(todoId: 1))).called(1);
    });

    testWidgets('Test - Marking todo as incomplete dispatches correct event', (
      tester,
    ) async {
      final testTodos = [
        TodoEntity(
          id: 1,
          title: 'Complete Todo',
          content: 'Content',
          completed: true,
        ),
      ];

      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoading(),
          TodoListLoaded(todos: testTodos),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      verify(
        () => bloc.add(const MarkTodoIncompleteEvent(todoId: 1)),
      ).called(1);
    });

    testWidgets('Test - Deleting todo dispatches correct event', (
      tester,
    ) async {
      final testTodos = [
        TodoEntity(
          id: 1,
          title: 'Delete Todo',
          content: 'Content to delete',
          completed: false,
        ),
      ];

      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoading(),
          TodoListLoaded(todos: testTodos),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Find and tap the delete icon
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Tap the delete confirmation button in the dialog
      await tester.tap(find.text('Delete'));
      await tester.pump();

      verify(() => bloc.add(const DeleteTodoEvent(todoId: 1))).called(1);
    });

    testWidgets('Test - Error state displays correctly', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoading(),
          TodoListLoadError(message: 'Network error occurred'),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Network error occurred'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('Test - Tapping retry button dispatches LoadTodosEvent', (
      tester,
    ) async {
      whenListen(
        bloc,
        Stream.fromIterable(<TodoListState>[
          TodoListLoading(),
          TodoListLoadError(message: 'Failed to load todos'),
        ]),
        initialState: TodoListInitial(),
      );

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Verify retry button is present
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      // LoadTodosEvent is called once in initState and once when retry is tapped
      verify(() => bloc.add(LoadTodosEvent())).called(2);
    });
  });
}
