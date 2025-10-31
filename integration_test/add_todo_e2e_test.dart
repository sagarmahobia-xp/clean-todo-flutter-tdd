import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "E2E, Add multiple todos, mark complete, and delete functionalities",
    (tester) async {
      await configureDependencies(environment: Environment.test);
      await tester.pumpWidget(const MyApp());
      
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      final List<Map<String, String>> todos = [
        {
          'title': 'Implement Clean Architecture',
          'content':
              'Design and implement a complete clean architecture pattern with proper separation of concerns, including data layer, domain layer, and presentation layer with BLoC pattern for state management.',
        },
        {
          'title': 'Write Comprehensive Unit Tests',
          'content':
              'Create thorough unit tests for all use cases, repositories, and BLoC classes ensuring complete code coverage and edge case handling with proper mocking strategies.',
        },
        {
          'title': 'Setup Continuous Integration Pipeline',
          'content':
              'Configure GitHub Actions or similar CI/CD tool to automatically run tests, perform code analysis, and generate coverage reports on every pull request and commit.',
        },
        {
          'title': 'Refactor Legacy Code',
          'content':
              'Review and refactor the existing codebase to follow SOLID principles, remove code smells, improve readability, and ensure maintainability for future development.',
        },
        {
          'title': 'Document API Endpoints',
          'content':
              'Create comprehensive documentation for all REST API endpoints including request/response schemas, authentication requirements, error codes, and example usage scenarios.',
        },
      ];

      for (int i = 0; i < todos.length; i++) {
        final todo = todos[i];
        
        final fab = find.byType(FloatingActionButton);
        expect(fab, findsOneWidget);
        await tester.tap(fab);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));

        final titleField = find.byKey(const Key('titleField'));
        final contentField = find.byKey(const Key('contentField'));
        final addButton = find.byKey(const Key('addButton'));

        expect(titleField, findsOneWidget);
        expect(contentField, findsOneWidget);
        expect(addButton, findsOneWidget);

        await tester.enterText(titleField, todo['title']!);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.enterText(contentField, todo['content']!);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(addButton);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.textContaining(todo['title']!), findsOneWidget);
      }
      
      final firstCheckbox = find.byType(Checkbox).first;
      expect(firstCheckbox, findsOneWidget);
      
      Checkbox checkbox = tester.widget<Checkbox>(firstCheckbox);
      expect(checkbox.value, false);

      await tester.tap(firstCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      checkbox = tester.widget<Checkbox>(firstCheckbox);
      expect(checkbox.value, true);

      final secondCheckbox = find.byType(Checkbox).at(1);
      await tester.tap(secondCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      checkbox = tester.widget<Checkbox>(secondCheckbox);
      expect(checkbox.value, true);

      await tester.tap(firstCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      checkbox = tester.widget<Checkbox>(firstCheckbox);
      expect(checkbox.value, false);
      
      final thirdCheckbox = find.byType(Checkbox).at(2);
      await tester.tap(thirdCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      final fourthCheckbox = find.byType(Checkbox).at(3);
      await tester.tap(fourthCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      await tester.tap(secondCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));
      
      checkbox = tester.widget<Checkbox>(secondCheckbox);
      expect(checkbox.value, false);
      
      var deleteButtons = find.byIcon(Icons.delete_outline);
      expect(deleteButtons, findsAtLeastNWidgets(5));
      
      final lastDeleteButton = deleteButtons.last;
      await tester.tap(lastDeleteButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      var confirmDeleteButton = find.text('Delete');
      expect(confirmDeleteButton, findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(confirmDeleteButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byIcon(Icons.delete_outline), findsNWidgets(4));
      expect(find.text('Document API Endpoints'), findsNothing);

      final thirdDeleteButton = find.byIcon(Icons.delete_outline).at(2);
      await tester.tap(thirdDeleteButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byIcon(Icons.delete_outline), findsNWidgets(3));
      expect(find.text('Setup Continuous Integration Pipeline'), findsNothing);
      
      final newTodos = [
        {
          'title': 'Implement Authentication System',
          'content':
              'Build secure authentication with JWT tokens, refresh tokens, password hashing with bcrypt, and role-based access control for different user types.',
        },
        {
          'title': 'Optimize Database Queries',
          'content':
              'Analyze and optimize slow database queries, add proper indexes, implement query caching, and use database connection pooling for better performance.',
        },
      ];

      for (int i = 0; i < newTodos.length; i++) {
        final todo = newTodos[i];
        
        final fab = find.byType(FloatingActionButton);
        expect(fab, findsOneWidget);
        await tester.tap(fab);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));

        final titleField = find.byKey(const Key('titleField'));
        final contentField = find.byKey(const Key('contentField'));
        final addButton = find.byKey(const Key('addButton'));

        await tester.enterText(titleField, todo['title']!);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.enterText(contentField, todo['content']!);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(addButton);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(find.byIcon(Icons.delete_outline), findsNWidgets(5));
      
      final lastCheckbox = find.byType(Checkbox).last;
      await tester.tap(lastCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      await tester.tap(firstCheckbox);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));
      
      checkbox = tester.widget<Checkbox>(firstCheckbox);
      expect(checkbox.value, true);

      deleteButtons = find.byIcon(Icons.delete_outline);
      final firstDeleteButton = deleteButtons.first;
      await tester.tap(firstDeleteButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      confirmDeleteButton = find.text('Delete');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(confirmDeleteButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byIcon(Icons.delete_outline), findsNWidgets(4));

      final checkboxToUncheck = find.byType(Checkbox).at(1);
      await tester.tap(checkboxToUncheck);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));

      deleteButtons = find.byIcon(Icons.delete_outline);
      final anotherDeleteButton = deleteButtons.at(1);
      await tester.tap(anotherDeleteButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));

      confirmDeleteButton = find.text('Delete');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(confirmDeleteButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byIcon(Icons.delete_outline), findsNWidgets(3));

      expect(find.byType(Checkbox), findsAtLeastNWidgets(3));
    },
  );
}
