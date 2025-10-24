import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/repo/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  group('Group - Data - TodoRepo - Insert, Get', () {
    late DriftTodoRepo repo;
    late MockTodoLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockTodoLocalDataSource();
      repo = DriftTodoRepo(localDataSource: mockDataSource);
    });

    test(
      'Test - Data - TodoRepo: should call addTodo on data source',
      () async {
        // Arrange
        final todoEntity = TodoEntity(
          id: 0,
          title: 'Test Title',
          content: 'Test Content',
        );
        when(
          () => mockDataSource.addTodo(todoEntity),
        ).thenAnswer((_) async => 1);

        // Act
        final result = await repo.addTodo(todoEntity);

        // Assert
        expect(result, 1);
        verify(() => mockDataSource.addTodo(todoEntity)).called(1);
      },
    );

    test(
      'Test - Data - TodoRepo: should call getTodos on data source',
      () async {
        // Arrange
        final todoList = [
          TodoEntity(id: 1, title: 'Test Title 1', content: 'Test Content 1'),
          TodoEntity(id: 2, title: 'Test Title 2', content: 'Test Content 2'),
        ];
        when(() => mockDataSource.getTodos()).thenAnswer((_) async => todoList);

        // Act
        final result = await repo.getTodos();

        // Assert
        expect(result, todoList);
        expect(result.length, 2);
        verify(() => mockDataSource.getTodos()).called(1);
      },
    );

    test(
      'Test - Data - TodoRepo: should return empty list when no todos',
      () async {
        // Arrange
        when(() => mockDataSource.getTodos()).thenAnswer((_) async => []);

        // Act
        final result = await repo.getTodos();

        // Assert
        expect(result, []);
        expect(result.isEmpty, true);
        verify(() => mockDataSource.getTodos()).called(1);
      },
    );
  });
}
