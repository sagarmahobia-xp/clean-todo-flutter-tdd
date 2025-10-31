import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepo extends Mock implements TodoRepo {}

void main() {
  late GetTodoUseCase getTodoUseCase;
  late MockTodoRepo mockTodoRepo;

  setUp(() {
    mockTodoRepo = MockTodoRepo();
    getTodoUseCase = GetTodoUseCase(todoRepo: mockTodoRepo);
  });

  group('Group- Domain - GetTodoUseCase', () {
    final tTodos = [
      TodoEntity(id: 1, title: 'Test title', content: 'Test content'),
      TodoEntity(id: 2, title: 'Second title', content: 'Second content'),
    ];

    test('should get todos from the repository', () async {
      // arrange
      when(() => mockTodoRepo.getTodos()).thenAnswer((_) async => right(tTodos));
      
      // act
      final result = await getTodoUseCase();
      
      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected Right, got Left'),
        (r) => expect(r, tTodos),
      );
      verify(() => mockTodoRepo.getTodos()).called(1);
    });

    test('should return failure when repository throws exception', () async {
      // arrange
      when(() => mockTodoRepo.getTodos()).thenAnswer((_) async => left(TodoFailure('Error')));
      
      // act
      final result = await getTodoUseCase();
      
      // assert
      expect(result.isLeft(), true);
      verify(() => mockTodoRepo.getTodos()).called(1);
    });
  });
}