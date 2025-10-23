import 'package:bloc_test/bloc_test.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:clean_todo_tdd/features/todos/ui/widgets/add_todo_form_widget.dart'
    show AddTodoFormWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoBloc extends Mock implements TodoListBloc {}

void main() {
  group('Add Todo Form Widget Tests', () {
    late TodoListBloc bloc;

    setUpAll(() {
      registerFallbackValue(LoadTodosEvent());
    });

    setUp(() {
      bloc = MockTodoBloc();
    });

    testWidgets(
      'Given user enters title and content and taps add, when form is submitted, then new todo is added to the list',
      (tester) async {
        whenListen(
          bloc,
          Stream<TodoListState>.fromIterable([]),
          initialState: const TodoListLoaded(todos: []),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider<TodoListBloc>.value(
                value: bloc,
                child: const AddTodoFormWidget(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify widgets are present
        expect(find.byKey(const Key('titleField')), findsOneWidget);
        expect(find.byKey(const Key('contentField')), findsOneWidget);
        expect(find.byKey(const Key('addButton')), findsOneWidget);

        final titleField = find.byKey(const Key('titleField'));
        final contentField = find.byKey(const Key('contentField'));
        final addButton = find.byKey(const Key('addButton'));

        await tester.enterText(titleField, 'Todo Title');
        await tester.pumpAndSettle();

        await tester.enterText(contentField, 'Todo Content');
        await tester.pumpAndSettle();

        await tester.tap(addButton);
        await tester.pumpAndSettle();

        verify(() => bloc.add(const AddTodoEvent(
              title: 'Todo Title',
              content: 'Todo Content',
            ))).called(1);
      },
    );
  });
}
