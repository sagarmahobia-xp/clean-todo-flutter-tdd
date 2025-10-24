import 'package:clean_todo_tdd/database/drift_db.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/drift_todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class TestTodoDatabase extends TodoDatabase {
  TestTodoDatabase(super.e);

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        // Don't prefill data for tests
      },
    );
  }
}

void main() {
  group("Group - Data - TodoLocalDataSource - Insert, Get", () {
    late TodoLocalDataSource dataSource;
    late TodoDatabase database;

    setUp(() {
      database = TestTodoDatabase(NativeDatabase.memory());
      dataSource = DriftTodoLocalDataSource(database: database);
    });

    tearDown(() async {
      await database.close();
    });

    test(
      'Test - Data - TodoLocalDataSource: insert one and ensure items are present in the database',
      () async {
        // Arrange & Act
        await dataSource.addTodo(
          TodoEntity(id: 0, title: "Test Title", content: "Test Content"),
        );

        var todos = await dataSource.getTodos();
        
        // Assert
        expect(todos.length, 1);
        expect(todos.first.title, "Test Title");
        expect(todos.first.content, "Test Content");
      },
    );

    test(
      'Test - Data - TodoLocalDataSource: insert one and ensure the same item is present in the db',
      () async {
        // Arrange
        var todoEntity = TodoEntity(
          id: 0,
          title: "Test Title 2",
          content: "Test Content 2",
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
      'Test - Data - TodoLocalDataSource: getTodos returns empty list initially',
      () async {
        // Act
        var todos = await dataSource.getTodos();
        
        // Assert
        expect(todos, isA<List<TodoEntity>>());
        expect(todos.isEmpty, true);
      },
    );

    test(
      'Test - Data - TodoLocalDataSource: insert multiple todos',
      () async {
        // Arrange & Act
        await dataSource.addTodo(
          TodoEntity(id: 0, title: "Todo 1", content: "Content 1"),
        );
        await dataSource.addTodo(
          TodoEntity(id: 0, title: "Todo 2", content: "Content 2"),
        );
        await dataSource.addTodo(
          TodoEntity(id: 0, title: "Todo 3", content: "Content 3"),
        );

        var todos = await dataSource.getTodos();
        
        // Assert
        expect(todos.length, 3);
        expect(todos[0].title, "Todo 1");
        expect(todos[1].title, "Todo 2");
        expect(todos[2].title, "Todo 3");
      },
    );
  });
}
