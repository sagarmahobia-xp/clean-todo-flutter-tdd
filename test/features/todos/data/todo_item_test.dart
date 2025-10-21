import 'package:clean_todo_tdd/database/drift_db.dart';
import 'package:clean_todo_tdd/di/di_config.dart'
    show configureDependencies, getIt;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test the CRUD operations to the database", () {
    setUpAll(() {
      configureDependencies();
    });

    test('Test: Insert a todo item to db and retrieve the same', () async {
      var db = getIt<TodoDatabase>();

      var title = "Test Title";
      await db
          .into(db.todoItems)
          .insert(TodoItemsCompanion.insert(title: title));

      var item = await db.select(db.todoItems).getSingle();

      expect(item.title, title);
    });
  });
}
