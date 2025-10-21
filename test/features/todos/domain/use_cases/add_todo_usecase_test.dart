import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepo extends Mock implements TodoRepo {}

void main() {
  group('Todo: Test add todo use case functionalities', () {
    setUp(() {
      configureDependencies();
      getIt.allowReassignment = true;
      getIt.registerSingleton<TodoRepo>(MockTodoRepo());
    });

    test("Test Add todo function", () async {
      var todoRepo = getIt<TodoRepo>();
      var todo = TodoEntity(title: "Some todo", content: "some content");

      when(() => todoRepo.addTodo(todo)).thenAnswer((_) async => 1);

      var id = await todoRepo.addTodo(todo);

      expect(id, 1);
      verify(() => todoRepo.addTodo(todo));
    });
  });
}
