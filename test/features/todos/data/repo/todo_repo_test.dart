import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/features/todos/data/repo/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Group - Data - TodoRepo - Insert, Get", () {
    late final DriftTodoRepo repo;

    setUpAll(() {
      configureDependencies();
      repo = DriftTodoRepo(database: getIt());
    });

    test(
      'Test - Data - TodoRepo: insert one and ensure 1 item is present in the database',
      () async {
        await repo.addTodo(
          TodoEntity(id: 0, title: "Test Title", content: "Test Content"),
        );

        var todos = await repo.getTodos();
        expect(todos.length, 1);
      },
    );

    test(
      'Test - Data - TodoRepo: insert one and ensure the same item is present in the db',
      () async {
        var todoEntity = TodoEntity(
          id: 1,
          title: "Test Title",
          content: "Test Content",
        );
        await repo.addTodo(todoEntity);

        var storedTodoEntity = (await repo.getTodos()).first;

        expect(todoEntity, storedTodoEntity);
      },
    );
  });
}
