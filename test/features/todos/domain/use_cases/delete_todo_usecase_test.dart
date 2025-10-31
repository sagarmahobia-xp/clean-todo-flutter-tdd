import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/delete_todo_usecase.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepo extends Mock implements TodoRepo {}

void main() {
  late DeleteTodoUseCase deleteTodoUseCase;
  late MockTodoRepo mockTodoRepo;

  setUp(() {
    mockTodoRepo = MockTodoRepo();
    deleteTodoUseCase = DeleteTodoUseCase(repo: mockTodoRepo);
  });

  group('Group- Domain - DeleteTodoUseCase', () {
    const todoId = 1;

    test('should delete todo using the repository', () async {
      // arrange
      when(() => mockTodoRepo.deleteTodo(todoId)).thenAnswer((_) async => right(null));

      // act
      final result = await deleteTodoUseCase(todoId);

      // assert
      expect(result.isRight(), true);
      verify(() => mockTodoRepo.deleteTodo(todoId)).called(1);
    });

    test('should return failure when repository throws exception', () async {
      // arrange
      when(
        () => mockTodoRepo.deleteTodo(todoId),
      ).thenAnswer((_) async => left(TodoFailure('Failed to delete todo')));

      // act
      final result = await deleteTodoUseCase(todoId);

      // assert
      expect(result.isLeft(), true);
      verify(() => mockTodoRepo.deleteTodo(todoId)).called(1);
    });
  });
}
