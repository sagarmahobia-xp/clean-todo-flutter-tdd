import 'dart:io';

import 'package:clean_todo_tdd/features/todos/data/database/drift_db.dart';
import 'package:clean_todo_tdd/features/todos/data/database/sqflite_db.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/sqflite_todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

@module
abstract class DataModule {
  // Drift database providers (currently unused, kept for reference)
  @Environment(Environment.prod)
  @singleton
  @preResolve
  Future<TodoDatabase> getProductionDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'todo_db.sqlite'));
    return TodoDatabase(NativeDatabase.createInBackground(file));
  }

  // Sqflite database providers
  @Environment(Environment.prod)
  @singleton
  @preResolve
  Future<Database> getProductionSqfliteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = path.join(dbFolder.path, 'todo_database.db');
    return await TodoSqfliteDatabase.createDatabase(dbPath);
  }

  // Sqflite data source providers (currently in use)
  @Environment(Environment.prod)
  @singleton
  TodoLocalDataSource getProductionDataSource(Database database) {
    return SqfliteTodoLocalDataSource(database: database);
  }

  /* Test Dependencies */
  @Environment(Environment.test)
  @singleton
  TodoDatabase getTestDatabase() {
    return TestTodoDatabase(NativeDatabase.memory());
  }

  @Environment(Environment.test)
  @singleton
  @preResolve
  Future<Database> getTestSqfliteDatabase() async {
    return await TodoSqfliteDatabase.createInMemoryDatabase();
  }

  @Environment(Environment.test)
  @singleton
  TodoLocalDataSource getTestDataSource(Database database) {
    return SqfliteTodoLocalDataSource(database: database);
  }
}
