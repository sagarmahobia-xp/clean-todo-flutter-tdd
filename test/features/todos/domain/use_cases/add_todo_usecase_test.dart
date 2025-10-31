import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepo extends Mock implements TodoRepo {}

void main() {
  late AddTodoUseCase addTodoUseCase;
  late MockTodoRepo mockTodoRepo;

  setUp(() {
    mockTodoRepo = MockTodoRepo();
    addTodoUseCase = AddTodoUseCase(repo: mockTodoRepo);
  });

  group('Group- Domain - AddTodoUseCase', () {
    final todo = TodoEntity(id: 1, title: 'New Todo', content: 'New Todo');

    test('should add todo using the repository', () async {
      // arrange
      when(() => mockTodoRepo.addTodo(todo)).thenAnswer((_) async => right(1));

      // act
      final result = await addTodoUseCase(todo);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected Right, got Left'),
        (r) => expect(r, 1),
      );
      verify(() => mockTodoRepo.addTodo(todo)).called(1);
    });

    test('should return failure when repository throws exception', () async {
      // arrange
      when(() => mockTodoRepo.addTodo(todo)).thenAnswer((_) async => left(TodoFailure('Failed to add todo')));

      // act
      final result = await addTodoUseCase(todo);

      // assert
      expect(result.isLeft(), true);
      verify(() => mockTodoRepo.addTodo(todo)).called(1);
    });
  });
}
