import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/sqflite_todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Mock classes for testing failure scenarios
class MockDatabase extends Mock implements Database {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Group - Data - SqfliteTodoLocalDataSource - Insert, Get', () {
    late TodoLocalDataSource dataSource;
    late Database database;

    setUp(() async {
      // Create in-memory database for tests
      database = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE todos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              content TEXT,
              completed INTEGER DEFAULT 0
            )
          ''');
        },
      );
      dataSource = SqfliteTodoLocalDataSource(database: database);
    });

    tearDown(() async {
      await database.close();
    });

    test(
      'Test - Data - SqfliteTodoLocalDataSource: insert one and ensure items are present in the database',
      () async {
        // Arrange & Act
        await dataSource.addTodo(
          TodoEntity(id: 0, title: 'Test Title', content: 'Test Content'),
        );

        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        
        // Assert
        expect(todos.length, 1);
        expect(todos.first.title, 'Test Title');
        expect(todos.first.content, 'Test Content');
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: insert one and ensure the same item is present in the db',
      () async {
        // Arrange
        var todoEntity = TodoEntity(
          id: 0,
          title: 'Test Title 2',
          content: 'Test Content 2',
        );
        
        // Act
        await dataSource.addTodo(todoEntity);
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        var storedTodoEntity = todos.first;

        // Assert
        expect(todoEntity.title, storedTodoEntity.title);
        expect(todoEntity.content, storedTodoEntity.content);
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: getTodos returns empty list initially',
      () async {
        // Act
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        
        // Assert
        expect(todos, isA<List<TodoEntity>>());
        expect(todos.isEmpty, true);
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: insert multiple todos',
      () async {
        // Arrange & Act
        await dataSource.addTodo(
          TodoEntity(id: 0, title: 'Todo 1', content: 'Content 1'),
        );
        await dataSource.addTodo(
          TodoEntity(id: 0, title: 'Todo 2', content: 'Content 2'),
        );
        await dataSource.addTodo(
          TodoEntity(id: 0, title: 'Todo 3', content: 'Content 3'),
        );

        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        
        // Assert
        expect(todos.length, 3);
        expect(todos[0].title, 'Todo 1');
        expect(todos[1].title, 'Todo 2');
        expect(todos[2].title, 'Todo 3');
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: mark a todo as complete',
      () async {
        // Arrange
        await dataSource.addTodo(
          TodoEntity(id: 0, title: 'Test Todo', content: 'Test Content'),
        );
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        var todoId = todos.first.id;

        // Verify initial state
        expect(todos.first.completed, false);

        // Act
        await dataSource.markComplete(todoId);
        var updatedResult = await dataSource.getTodos();
        var updatedTodos = updatedResult.fold((l) => [], (r) => r);

        // Assert
        expect(updatedTodos.firstWhere((todo) => todo.id == todoId).completed, true);
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: mark a todo as incomplete',
      () async {
        // Arrange
        await dataSource.addTodo(
          TodoEntity(id: 0, title: 'Test Todo', content: 'Test Content', completed: true),
        );
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        var todoId = todos.first.id;

        // Verify initial state
        expect(todos.first.completed, true);

        // Act
        await dataSource.markIncomplete(todoId);
        var updatedResult = await dataSource.getTodos();
        var updatedTodos = updatedResult.fold((l) => [], (r) => r);

        // Assert
        expect(updatedTodos.firstWhere((todo) => todo.id == todoId).completed, false);
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: delete a todo',
      () async {
        // Arrange
        await dataSource.addTodo(
          TodoEntity(id: 0, title: 'Todo to Delete', content: 'Content to Delete'),
        );
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        var todoId = todos.first.id;
        
        // Verify initial state
        expect(todos.length, 1);
        expect(todos.first.title, 'Todo to Delete');

        // Act
        await dataSource.deleteTodo(todoId);
        var updatedResult = await dataSource.getTodos();
        var updatedTodos = updatedResult.fold((l) => [], (r) => r);

        // Assert
        expect(updatedTodos.length, 0);
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: update a todo',
      () async {
        // Arrange
        var initialTodo = TodoEntity(id: 0, title: 'Initial Title', content: 'Initial Content', completed: false);
        await dataSource.addTodo(initialTodo);
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        var todoId = todos.first.id;
        var updatedTodo = TodoEntity(
          id: todoId,
          title: 'Updated Title',
          content: 'Updated Content',
          completed: true,
        );

        // Verify initial state
        expect(todos.first.title, 'Initial Title');
        expect(todos.first.content, 'Initial Content');
        expect(todos.first.completed, false);

        // Act
        await dataSource.updateTodo(updatedTodo);
        var updatedResult = await dataSource.getTodos();
        var updatedTodos = updatedResult.fold((l) => [], (r) => r);

        // Assert
        var todo = updatedTodos.firstWhere((todo) => todo.id == todoId);
        expect(todo.title, 'Updated Title');
        expect(todo.content, 'Updated Content');
        expect(todo.completed, true);
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: update only title',
      () async {
        // Arrange
        var initialTodo = TodoEntity(id: 0, title: 'Initial Title', content: 'Initial Content', completed: true);
        await dataSource.addTodo(initialTodo);
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        var todoId = todos.first.id;
        var updatedTodo = TodoEntity(
          id: todoId,
          title: 'Updated Title',
          content: 'Initial Content', // Keep the same
          completed: true, // Keep the same
        );

        // Verify initial state
        expect(todos.first.title, 'Initial Title');
        expect(todos.first.content, 'Initial Content');
        expect(todos.first.completed, true);

        // Act
        await dataSource.updateTodo(updatedTodo);
        var updatedResult = await dataSource.getTodos();
        var updatedTodos = updatedResult.fold((l) => [], (r) => r);

        // Assert
        var todo = updatedTodos.firstWhere((todo) => todo.id == todoId);
        expect(todo.title, 'Updated Title');
        expect(todo.content, 'Initial Content'); // Should remain unchanged
        expect(todo.completed, true); // Should remain unchanged
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: update only completion status',
      () async {
        // Arrange
        var initialTodo = TodoEntity(id: 0, title: 'Initial Title', content: 'Initial Content', completed: false);
        await dataSource.addTodo(initialTodo);
        var result = await dataSource.getTodos();
        var todos = result.fold((l) => [], (r) => r);
        var todoId = todos.first.id;
        var updatedTodo = TodoEntity(
          id: todoId,
          title: 'Initial Title', // Keep the same
          content: 'Initial Content', // Keep the same
          completed: true,
        );

        // Verify initial state
        expect(todos.first.title, 'Initial Title');
        expect(todos.first.content, 'Initial Content');
        expect(todos.first.completed, false);

        // Act
        await dataSource.updateTodo(updatedTodo);
        var updatedResult = await dataSource.getTodos();
        var updatedTodos = updatedResult.fold((l) => [], (r) => r);

        // Assert
        var todo = updatedTodos.firstWhere((todo) => todo.id == todoId);
        expect(todo.title, 'Initial Title'); // Should remain unchanged
        expect(todo.content, 'Initial Content'); // Should remain unchanged
        expect(todo.completed, true);
      },
    );
  });

  group('Group - Data - SqfliteTodoLocalDataSource - Failure Cases', () {
    late TodoLocalDataSource dataSource;
    late MockDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockDatabase();
      dataSource = SqfliteTodoLocalDataSource(database: mockDatabase);
    });

    group('addTodo failure cases', () {
      test(
        'should return DatabaseFailure when database.insert throws exception',
        () async {
          // Arrange
          final todo = TodoEntity(
            id: 0,
            title: 'Test Title',
            content: 'Test Content',
          );
          final exception = Exception('Database insert failed');
          when(
            () => mockDatabase.insert(
              any(),
              any(),
              conflictAlgorithm: any(named: 'conflictAlgorithm'),
            ),
          ).thenThrow(exception);

          // Act
          final result = await dataSource.addTodo(todo);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<DatabaseFailure>());
              expect(failure.message, contains('Failed to add todo'));
              expect(failure.exception, equals(exception));
              expect(failure.stackTrace, isNotNull);
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );

      test(
        'should return DatabaseFailure with proper message when insert fails',
        () async {
          // Arrange
          final todo = TodoEntity(id: 0, title: 'Test', content: 'Content');
          when(
            () => mockDatabase.insert(
              any(),
              any(),
              conflictAlgorithm: any(named: 'conflictAlgorithm'),
            ),
          ).thenThrow(Exception('Constraint violation'));

          // Act
          final result = await dataSource.addTodo(todo);

          // Assert
          result.fold(
            (failure) {
              expect(failure.message, contains('Failed to add todo'));
              expect(failure.message, contains('Constraint violation'));
            },
            (_) => fail('Expected failure'),
          );
        },
      );
    });

    group('getTodos failure cases', () {
      test(
        'should return DatabaseFailure when database.query throws exception',
        () async {
          // Arrange
          final exception = Exception('Failed to query database');
          when(() => mockDatabase.query(any())).thenThrow(exception);

          // Act
          final result = await dataSource.getTodos();

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<DatabaseFailure>());
              expect(failure.message, contains('Failed to get todos'));
              expect(failure.exception, equals(exception));
              expect(failure.stackTrace, isNotNull);
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );

      test(
        'should return DatabaseFailure with proper error details',
        () async {
          // Arrange
          when(() => mockDatabase.query(any())).thenThrow(
            Exception('Database connection lost'),
          );

          // Act
          final result = await dataSource.getTodos();

          // Assert
          result.fold(
            (failure) {
              expect(failure.message, contains('Failed to get todos'));
              expect(failure.message, contains('Database connection lost'));
            },
            (_) => fail('Expected failure'),
          );
        },
      );
    });

    group('markComplete failure cases', () {
      test(
        'should return DatabaseFailure when database.update throws exception',
        () async {
          // Arrange
          const id = 1;
          final exception = Exception('Update operation failed');
          when(
            () => mockDatabase.update(
              any(),
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(exception);

          // Act
          final result = await dataSource.markComplete(id);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<DatabaseFailure>());
              expect(failure.message, contains('Failed to mark todo as complete'));
              expect(failure.exception, equals(exception));
              expect(failure.stackTrace, isNotNull);
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );

      test(
        'should propagate error details in DatabaseFailure',
        () async {
          // Arrange
          const id = 1;
          when(
            () => mockDatabase.update(
              any(),
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(Exception('Todo not found'));

          // Act
          final result = await dataSource.markComplete(id);

          // Assert
          result.fold(
            (failure) {
              expect(failure.message, contains('Failed to mark todo as complete'));
              expect(failure.message, contains('Todo not found'));
            },
            (_) => fail('Expected failure'),
          );
        },
      );
    });

    group('markIncomplete failure cases', () {
      test(
        'should return DatabaseFailure when database.update throws exception',
        () async {
          // Arrange
          const id = 1;
          final exception = Exception('Database write error');
          when(
            () => mockDatabase.update(
              any(),
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(exception);

          // Act
          final result = await dataSource.markIncomplete(id);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<DatabaseFailure>());
              expect(failure.message, contains('Failed to mark todo as incomplete'));
              expect(failure.exception, equals(exception));
              expect(failure.stackTrace, isNotNull);
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );

      test(
        'should include error details in failure message',
        () async {
          // Arrange
          const id = 1;
          when(
            () => mockDatabase.update(
              any(),
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(Exception('Disk full'));

          // Act
          final result = await dataSource.markIncomplete(id);

          // Assert
          result.fold(
            (failure) {
              expect(failure.message, contains('Failed to mark todo as incomplete'));
              expect(failure.message, contains('Disk full'));
            },
            (_) => fail('Expected failure'),
          );
        },
      );
    });

    group('deleteTodo failure cases', () {
      test(
        'should return DatabaseFailure when database.delete throws exception',
        () async {
          // Arrange
          const id = 1;
          final exception = Exception('Delete operation failed');
          when(
            () => mockDatabase.delete(
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(exception);

          // Act
          final result = await dataSource.deleteTodo(id);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<DatabaseFailure>());
              expect(failure.message, contains('Failed to delete todo'));
              expect(failure.exception, equals(exception));
              expect(failure.stackTrace, isNotNull);
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );

      test(
        'should return DatabaseFailure with error context',
        () async {
          // Arrange
          const id = 1;
          when(
            () => mockDatabase.delete(
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(Exception('Foreign key constraint failed'));

          // Act
          final result = await dataSource.deleteTodo(id);

          // Assert
          result.fold(
            (failure) {
              expect(failure.message, contains('Failed to delete todo'));
              expect(failure.message, contains('Foreign key constraint failed'));
            },
            (_) => fail('Expected failure'),
          );
        },
      );
    });

    group('updateTodo failure cases', () {
      test(
        'should return DatabaseFailure when database.update throws exception',
        () async {
          // Arrange
          final todo = TodoEntity(
            id: 1,
            title: 'Updated Title',
            content: 'Updated Content',
            completed: true,
          );
          final exception = Exception('Update failed');
          when(
            () => mockDatabase.update(
              any(),
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(exception);

          // Act
          final result = await dataSource.updateTodo(todo);

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<DatabaseFailure>());
              expect(failure.message, contains('Failed to update todo'));
              expect(failure.exception, equals(exception));
              expect(failure.stackTrace, isNotNull);
            },
            (_) => fail('Expected failure, got success'),
          );
        },
      );

      test(
        'should propagate detailed error message in DatabaseFailure',
        () async {
          // Arrange
          final todo = TodoEntity(
            id: 1,
            title: 'Test',
            content: 'Test',
            completed: false,
          );
          when(
            () => mockDatabase.update(
              any(),
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            ),
          ).thenThrow(Exception('Invalid data type'));

          // Act
          final result = await dataSource.updateTodo(todo);

          // Assert
          result.fold(
            (failure) {
              expect(failure.message, contains('Failed to update todo'));
              expect(failure.message, contains('Invalid data type'));
            },
            (_) => fail('Expected failure'),
          );
        },
      );
    });
  });
}
