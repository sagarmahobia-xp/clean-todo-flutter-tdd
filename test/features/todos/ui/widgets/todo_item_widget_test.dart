import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/ui/widgets/todo_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TodoEntity todo;

  setUp(() {
    todo = const TodoEntity(
      id: 1,
      title: 'Test Todo',
      content: 'Test Content',
      completed: false,
    );
  });

  group('TodoItemWidget Tests', () {
    Widget buildWidget({
      required TodoEntity testTodo,
      Function(bool)? onChanged,
      VoidCallback? onDelete,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: TodoItemWidget(
            todo: testTodo,
            onChanged: onChanged ?? (_) {},
            onDelete: onDelete,
          ),
        ),
      );
    }

    testWidgets('should display todo title and content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(testTodo: todo));

      await tester.pump();

      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets(
      'should display checkbox in unchecked state when todo is not completed',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(testTodo: todo));

        await tester.pump();

        expect(find.byType(Checkbox), findsOneWidget);
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, false);
      },
    );

    testWidgets(
      'should display checkbox in checked state when todo is completed',
      (WidgetTester tester) async {
        final completedTodo = const TodoEntity(
          id: 1,
          title: 'Completed Todo',
          content: 'Test Content',
          completed: true,
        );

        await tester.pumpWidget(buildWidget(testTodo: completedTodo));

        await tester.pump();

        expect(find.byType(Checkbox), findsOneWidget);
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, true);
      },
    );

    testWidgets('should display strikethrough text when todo is completed', (
      WidgetTester tester,
    ) async {
      final completedTodo = const TodoEntity(
        id: 1,
        title: 'Completed Todo',
        content: 'Test Content',
        completed: true,
      );

      await tester.pumpWidget(buildWidget(testTodo: completedTodo));

      await tester.pump();

      final titleFinder = find.text('Completed Todo');
      expect(titleFinder, findsOneWidget);

      final titleText = tester.widget<Text>(titleFinder);
      final titleStyle = titleText.style as TextStyle;
      expect(titleStyle.decoration, TextDecoration.lineThrough);
    });

    testWidgets(
      'should not display strikethrough text when todo is not completed',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(testTodo: todo));

        await tester.pump();

        final titleFinder = find.text('Test Todo');
        expect(titleFinder, findsOneWidget);

        final titleText = tester.widget<Text>(titleFinder);
        final titleStyle = titleText.style as TextStyle;
        expect(titleStyle.decoration, isNot(TextDecoration.lineThrough));
      },
    );

    testWidgets(
      'should call the onChanged callback with true when checkbox is tapped and was unchecked',
      (WidgetTester tester) async {
        bool? callbackValue;

        await tester.pumpWidget(
          buildWidget(
            testTodo: todo,
            onChanged: (bool value) {
              callbackValue = value;
            },
          ),
        );

        await tester.pump();

        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        expect(callbackValue, true);
      },
    );

    testWidgets(
      'should call the onChanged callback with false when checkbox is tapped and was checked',
      (WidgetTester tester) async {
        bool? callbackValue;

        final completedTodo = const TodoEntity(
          id: 1,
          title: 'Completed Todo',
          content: 'Test Content',
          completed: true,
        );

        await tester.pumpWidget(
          buildWidget(
            testTodo: completedTodo,
            onChanged: (bool value) {
              callbackValue = value;
            },
          ),
        );

        await tester.pump();

        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        expect(callbackValue, false);
      },
    );

    testWidgets(
      'should display different colors for completed vs incomplete todos',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(testTodo: todo));
        await tester.pump();

        final titleFinder = find.text('Test Todo');
        expect(titleFinder, findsOneWidget);

        final titleText = tester.widget<Text>(titleFinder);
        final titleStyle = titleText.style as TextStyle;
        expect(titleStyle.color, isNot(Colors.grey));

        final completedTodo = const TodoEntity(
          id: 1,
          title: 'Completed Todo',
          content: 'Test Content',
          completed: true,
        );

        await tester.pumpWidget(buildWidget(testTodo: completedTodo));
        await tester.pump();

        final completedTitleFinder = find.text('Completed Todo');
        expect(completedTitleFinder, findsOneWidget);

        final completedTitleText = tester.widget<Text>(completedTitleFinder);
        final completedTitleStyle = completedTitleText.style as TextStyle;
        expect(completedTitleStyle.color, Colors.grey[700]);
      },
    );
    
    testWidgets(
      'should display delete icon and call onDelete when tapped',
      (WidgetTester tester) async {
        bool deleteCalled = false;

        await tester.pumpWidget(
          buildWidget(
            testTodo: todo,
            onDelete: () {
              deleteCalled = true;
            },
          ),
        );

        await tester.pump();

        // Verify the delete icon is present
        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
        
        // Tap the delete icon
        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pump();

        expect(deleteCalled, true);
      },
    );
  });
}
