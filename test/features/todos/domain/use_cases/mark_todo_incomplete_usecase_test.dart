import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/mark_todo_incomplete_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepo extends Mock implements TodoRepo {}

void main() {
  late MarkTodoIncompleteUseCase markTodoIncompleteUseCase;
  late MockTodoRepo mockTodoRepo;

  setUp(() {
    mockTodoRepo = MockTodoRepo();
    markTodoIncompleteUseCase = MarkTodoIncompleteUseCase(todoRepo: mockTodoRepo);
  });

  group('Group- Domain - MarkTodoIncompleteUseCase', () {
    final todo = TodoEntity(id: 1, title: 'Test Todo', content: 'Test content', completed: true);

    test('should mark todo as incomplete using the repository', () async {
      // arrange
      when(() => mockTodoRepo.markIncomplete(todo.id)).thenAnswer((_) async => null);

      // act
      final result = await markTodoIncompleteUseCase(todo);

      // assert
      expect(result, Right(null));
      verify(() => mockTodoRepo.markIncomplete(todo.id)).called(1);
    });

    test('should return failure when repository throws exception', () async {
      // arrange
      when(() => mockTodoRepo.markIncomplete(todo.id)).thenThrow(Exception("Failed to mark todo as incomplete"));

      // act
      final result = await markTodoIncompleteUseCase(todo);

      // assert
      expect(result.isLeft(), true);
      verify(() => mockTodoRepo.markIncomplete(todo.id)).called(1);
    });
  });
}