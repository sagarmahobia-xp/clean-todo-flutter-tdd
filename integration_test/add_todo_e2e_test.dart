import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("E2E, Add todo and ensure the same is present in view", (
    tester,
  ) async {
    configureDependencies();
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    var button = find.byType(FloatingActionButton);

    expect(button, findsOneWidget);

    await tester.tap(button);

    await tester.pumpAndSettle();

    var titleField = find.byKey(const Key('titleField'));
    var contentField = find.byKey(const Key('contentField'));
    var addButton = find.byKey(const Key('addButton'));

    expect(titleField, findsOneWidget);
    expect(contentField, findsOneWidget);
    expect(addButton, findsOneWidget);

    await tester.enterText(titleField, 'Todo Title');
    await tester.pumpAndSettle();
    expect(find.text('Todo Title'), findsOneWidget);

    await tester.enterText(contentField, 'Todo Content');
    await tester.pumpAndSettle();
    expect(find.text('Todo Content'), findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.text('Todo Title'), findsOneWidget);
    expect(find.text('Todo Content'), findsOneWidget);

    await tester.pumpAndSettle();


  });
}
