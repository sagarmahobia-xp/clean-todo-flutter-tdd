import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/mark_todo_complete_usecase.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepo extends Mock implements TodoRepo {}

void main() {
  late MarkTodoCompleteUseCase markTodoCompleteUseCase;
  late MockTodoRepo mockTodoRepo;

  setUp(() {
    mockTodoRepo = MockTodoRepo();
    markTodoCompleteUseCase = MarkTodoCompleteUseCase(todoRepo: mockTodoRepo);
  });

  group('Group- Domain - MarkTodoCompleteUseCase', () {
    final todo = TodoEntity(id: 1, title: 'Test Todo', content: 'Test content', completed: false);

    test('should mark todo as complete using the repository', () async {
      // arrange
      when(() => mockTodoRepo.markComplete(todo.id)).thenAnswer((_) async => right(null));

      // act
      final result = await markTodoCompleteUseCase(todo);

      // assert
      expect(result.isRight(), true);
      verify(() => mockTodoRepo.markComplete(todo.id)).called(1);
    });

    test('should return failure when repository throws exception', () async {
      // arrange
      when(() => mockTodoRepo.markComplete(todo.id)).thenAnswer((_) async => left(TodoFailure('Failed to mark todo as complete')));

      // act
      final result = await markTodoCompleteUseCase(todo);

      // assert
      expect(result.isLeft(), true);
      verify(() => mockTodoRepo.markComplete(todo.id)).called(1);
    });
  });
}