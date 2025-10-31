import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/repo/todo_repo.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
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
        ).thenAnswer((_) async => right(1));

        // Act
        final result = await repo.addTodo(todoEntity);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Expected right, got left'),
          (r) => expect(r, 1),
        );
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
        when(() => mockDataSource.getTodos()).thenAnswer((_) async => right(todoList));

        // Act
        final result = await repo.getTodos();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Expected right, got left'),
          (r) => {
            expect(r, todoList),
            expect(r.length, 2),
          },
        );
        verify(() => mockDataSource.getTodos()).called(1);
      },
    );

    test(
      'Test - Data - TodoRepo: should return empty list when no todos',
      () async {
        // Arrange
        when(() => mockDataSource.getTodos()).thenAnswer((_) async => right([]));

        // Act
        final result = await repo.getTodos();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Expected right, got left'),
          (r) => {
            expect(r, []),
            expect(r.isEmpty, true),
          },
        );
        verify(() => mockDataSource.getTodos()).called(1);
      },
    );

    group('Group - Repository - markComplete', () {
      test('should call the data source with the correct id', () async {
        // arrange
        const id = 1;
        when(
          () => mockDataSource.markComplete(id),
        ).thenAnswer((_) async => right(null));

        // act
        final result = await repo.markComplete(id);

        // assert
        expect(result.isRight(), true);
        verify(() => mockDataSource.markComplete(id)).called(1);
      });
    });

    group('Group - Repository - markIncomplete', () {
      test('should call the data source with the correct id', () async {
        // arrange
        const id = 1;
        when(
          () => mockDataSource.markIncomplete(id),
        ).thenAnswer((_) async => right(null));

        // act
        final result = await repo.markIncomplete(id);

        // assert
        expect(result.isRight(), true);
        verify(() => mockDataSource.markIncomplete(id)).called(1);
      });
    });

    group('Group - Repository - deleteTodo', () {
      test('should call the data source with the correct id', () async {
        // arrange
        const id = 1;
        when(
          () => mockDataSource.deleteTodo(id),
        ).thenAnswer((_) async => right(null));

        // act
        final result = await repo.deleteTodo(id);

        // assert
        expect(result.isRight(), true);
        verify(() => mockDataSource.deleteTodo(id)).called(1);
      });
    });
  });

  group('Group - Data - TodoRepo - Failure Cases', () {
    late DriftTodoRepo repo;
    late MockTodoLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockTodoLocalDataSource();
      repo = DriftTodoRepo(localDataSource: mockDataSource);
    });

    group('addTodo failure cases', () {
      test(
        'should return AddTodoFailure when datasource returns DatabaseFailure',
        () async {
          // Arrange
          final todoEntity = TodoEntity(
            id: 0,
            title: 'Test Title',
            content: 'Test Content',
          );
          final databaseFailure = DatabaseFailure(
            'Database error occurred',
            exception: Exception('Database connection failed'),
          );
          when(
            () => mockDataSource.addTodo(todoEntity),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.addTodo(todoEntity);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<AddTodoFailure>());
              expect(failure.message, contains('Database error occurred'));
            },
            (_) => fail('Expected failure, got success'),
          );
          verify(() => mockDataSource.addTodo(todoEntity)).called(1);
        },
      );

      test(
        'should propagate exception and stackTrace from DatabaseFailure to AddTodoFailure',
        () async {
          // Arrange
          final todoEntity = TodoEntity(
            id: 0,
            title: 'Test Title',
            content: 'Test Content',
          );
          final exception = Exception('Test exception');
          final stackTrace = StackTrace.current;
          final databaseFailure = DatabaseFailure(
            'Database error',
            exception: exception,
            stackTrace: stackTrace,
          );
          when(
            () => mockDataSource.addTodo(todoEntity),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.addTodo(todoEntity);

          // Assert
          result.fold(
            (failure) {
              expect(failure, isA<AddTodoFailure>());
              final addTodoFailure = failure as AddTodoFailure;
              expect(addTodoFailure.exception, equals(exception));
              expect(addTodoFailure.stackTrace, equals(stackTrace));
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );
    });

    group('getTodos failure cases', () {
      test(
        'should return GetTodosFailure when datasource returns DatabaseFailure',
        () async {
          // Arrange
          final databaseFailure = DatabaseFailure('Failed to query database');
          when(() => mockDataSource.getTodos()).thenAnswer(
            (_) async => left(databaseFailure),
          );

          // Act
          final result = await repo.getTodos();

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<GetTodosFailure>());
              expect(failure.message, contains('Failed to query database'));
            },
            (_) => fail('Expected failure, got success'),
          );
          verify(() => mockDataSource.getTodos()).called(1);
        },
      );

      test(
        'should propagate exception and stackTrace from DatabaseFailure to GetTodosFailure',
        () async {
          // Arrange
          final exception = Exception('Database read error');
          final stackTrace = StackTrace.current;
          final databaseFailure = DatabaseFailure(
            'Failed to read',
            exception: exception,
            stackTrace: stackTrace,
          );
          when(() => mockDataSource.getTodos()).thenAnswer(
            (_) async => left(databaseFailure),
          );

          // Act
          final result = await repo.getTodos();

          // Assert
          result.fold(
            (failure) {
              expect(failure, isA<GetTodosFailure>());
              final getTodosFailure = failure as GetTodosFailure;
              expect(getTodosFailure.exception, equals(exception));
              expect(getTodosFailure.stackTrace, equals(stackTrace));
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );
    });

    group('markComplete failure cases', () {
      test(
        'should return UpdateTodoFailure when datasource returns DatabaseFailure',
        () async {
          // Arrange
          const id = 1;
          final databaseFailure = DatabaseFailure(
            'Failed to update todo completion status',
          );
          when(
            () => mockDataSource.markComplete(id),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.markComplete(id);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<UpdateTodoFailure>());
              expect(
                failure.message,
                contains('Failed to update todo completion status'),
              );
            },
            (_) => fail('Expected failure, got success'),
          );
          verify(() => mockDataSource.markComplete(id)).called(1);
        },
      );

      test(
        'should propagate exception and stackTrace from DatabaseFailure to UpdateTodoFailure',
        () async {
          // Arrange
          const id = 1;
          final exception = Exception('Update failed');
          final stackTrace = StackTrace.current;
          final databaseFailure = DatabaseFailure(
            'Failed to mark complete',
            exception: exception,
            stackTrace: stackTrace,
          );
          when(
            () => mockDataSource.markComplete(id),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.markComplete(id);

          // Assert
          result.fold(
            (failure) {
              expect(failure, isA<UpdateTodoFailure>());
              final updateFailure = failure as UpdateTodoFailure;
              expect(updateFailure.exception, equals(exception));
              expect(updateFailure.stackTrace, equals(stackTrace));
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );
    });

    group('markIncomplete failure cases', () {
      test(
        'should return UpdateTodoFailure when datasource returns DatabaseFailure',
        () async {
          // Arrange
          const id = 1;
          final databaseFailure = DatabaseFailure(
            'Failed to mark todo as incomplete',
          );
          when(
            () => mockDataSource.markIncomplete(id),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.markIncomplete(id);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<UpdateTodoFailure>());
              expect(failure.message, contains('Failed to mark todo as incomplete'));
            },
            (_) => fail('Expected failure, got success'),
          );
          verify(() => mockDataSource.markIncomplete(id)).called(1);
        },
      );

      test(
        'should propagate exception and stackTrace from DatabaseFailure to UpdateTodoFailure',
        () async {
          // Arrange
          const id = 1;
          final exception = Exception('Mark incomplete failed');
          final stackTrace = StackTrace.current;
          final databaseFailure = DatabaseFailure(
            'Database update error',
            exception: exception,
            stackTrace: stackTrace,
          );
          when(
            () => mockDataSource.markIncomplete(id),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.markIncomplete(id);

          // Assert
          result.fold(
            (failure) {
              expect(failure, isA<UpdateTodoFailure>());
              final updateFailure = failure as UpdateTodoFailure;
              expect(updateFailure.exception, equals(exception));
              expect(updateFailure.stackTrace, equals(stackTrace));
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );
    });

    group('deleteTodo failure cases', () {
      test(
        'should return DeleteTodoFailure when datasource returns DatabaseFailure',
        () async {
          // Arrange
          const id = 1;
          final databaseFailure = DatabaseFailure('Failed to delete todo from database');
          when(
            () => mockDataSource.deleteTodo(id),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.deleteTodo(id);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<DeleteTodoFailure>());
              expect(failure.message, contains('Failed to delete todo from database'));
            },
            (_) => fail('Expected failure, got success'),
          );
          verify(() => mockDataSource.deleteTodo(id)).called(1);
        },
      );

      test(
        'should propagate exception and stackTrace from DatabaseFailure to DeleteTodoFailure',
        () async {
          // Arrange
          const id = 1;
          final exception = Exception('Delete operation failed');
          final stackTrace = StackTrace.current;
          final databaseFailure = DatabaseFailure(
            'Failed to delete',
            exception: exception,
            stackTrace: stackTrace,
          );
          when(
            () => mockDataSource.deleteTodo(id),
          ).thenAnswer((_) async => left(databaseFailure));

          // Act
          final result = await repo.deleteTodo(id);

          // Assert
          result.fold(
            (failure) {
              expect(failure, isA<DeleteTodoFailure>());
              final deleteFailure = failure as DeleteTodoFailure;
              expect(deleteFailure.exception, equals(exception));
              expect(deleteFailure.stackTrace, equals(stackTrace));
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );
    });
  });
}
