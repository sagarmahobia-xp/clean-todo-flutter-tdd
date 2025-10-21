import 'package:clean_todo_tdd/features/todos/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Group- UI - Home,", () {
    testWidgets('Test - App bar', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      var titleTxt = find.text("Todo List");

      expect(titleTxt, findsOneWidget);
    });

    testWidgets('Test - Empty List state', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      var noTodoText = find.text("No Todos Yet");

      expect(noTodoText, findsOneWidget);
    });
  });
}
