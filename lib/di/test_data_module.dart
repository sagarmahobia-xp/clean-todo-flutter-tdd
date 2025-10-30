import 'package:clean_todo_tdd/features/todos/data/database/sqflite_db.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/sqflite_todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@module
abstract class TestDataModule {
  // Test database provider
  @Environment(Environment.test)
  @singleton
  @preResolve
  Future<Database> getTestSqfliteDatabase() async {
    return await TodoSqfliteDatabase.createInMemoryDatabase();
  }

  // Test data source provider
  @Environment(Environment.test)
  @singleton
  TodoLocalDataSource getTestDataSource(Database database) {
    return SqfliteTodoLocalDataSource(database: database);
  }
}