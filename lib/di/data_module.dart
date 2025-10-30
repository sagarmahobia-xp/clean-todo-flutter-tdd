import 'package:clean_todo_tdd/features/todos/data/database/sqflite_db.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/sqflite_todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

@module
abstract class DataModule {
  // Production database provider
  @Environment(Environment.prod)
  @singleton
  @preResolve
  Future<Database> getProductionSqfliteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = path.join(dbFolder.path, 'todo_database.db');
    return await TodoSqfliteDatabase.createDatabase(dbPath);
  }

  // Production data source provider
  @Environment(Environment.prod)
  @singleton
  TodoLocalDataSource getProductionDataSource(Database database) {
    return SqfliteTodoLocalDataSource(database: database);
  }
}