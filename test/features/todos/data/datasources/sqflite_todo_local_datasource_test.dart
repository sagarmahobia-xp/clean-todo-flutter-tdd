import 'package:clean_todo_tdd/features/todos/data/datasources/sqflite_todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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

        var todos = await dataSource.getTodos();
        
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
        var storedTodoEntity = (await dataSource.getTodos()).first;

        // Assert
        expect(todoEntity.title, storedTodoEntity.title);
        expect(todoEntity.content, storedTodoEntity.content);
      },
    );

    test(
      'Test - Data - SqfliteTodoLocalDataSource: getTodos returns empty list initially',
      () async {
        // Act
        var todos = await dataSource.getTodos();
        
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

        var todos = await dataSource.getTodos();
        
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
        var todos = await dataSource.getTodos();
        var todoId = todos.first.id;

        // Verify initial state
        expect(todos.first.completed, false);

        // Act
        await dataSource.markComplete(todoId, true);
        var updatedTodos = await dataSource.getTodos();

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
        var todos = await dataSource.getTodos();
        var todoId = todos.first.id;

        // Verify initial state
        expect(todos.first.completed, true);

        // Act
        await dataSource.markComplete(todoId, false);
        var updatedTodos = await dataSource.getTodos();

        // Assert
        expect(updatedTodos.firstWhere((todo) => todo.id == todoId).completed, false);
      },
    );
  });
}
