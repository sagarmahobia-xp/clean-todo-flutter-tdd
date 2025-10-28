import 'package:clean_todo_tdd/features/todos/data/database/sqflite_db.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteTodoLocalDataSource implements TodoLocalDataSource {
  final Database database;

  SqfliteTodoLocalDataSource({required this.database});

  @override
  Future<int?> addTodo(TodoEntity todo) async {
    return await database.insert(
      TodoSqfliteDatabase.tableTodos,
      {
        TodoSqfliteDatabase.columnTitle: todo.title,
        TodoSqfliteDatabase.columnContent: todo.content,
        TodoSqfliteDatabase.columnCompleted: todo.completed ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<TodoEntity>> getTodos() async {
    final List<Map<String, dynamic>> maps = await database.query(
      TodoSqfliteDatabase.tableTodos,
    );

    return maps.map((map) {
      return TodoEntity(
        id: map[TodoSqfliteDatabase.columnId] as int,
        title: map[TodoSqfliteDatabase.columnTitle] as String,
        content: map[TodoSqfliteDatabase.columnContent] as String?,
        completed: map[TodoSqfliteDatabase.columnCompleted] == 1,
      );
    }).toList();
  }

  @override
  Future<void> markComplete(int id, bool completed) async {
    await database.update(
      TodoSqfliteDatabase.tableTodos,
      {
        TodoSqfliteDatabase.columnCompleted: completed ? 1 : 0,
      },
      where: '${TodoSqfliteDatabase.columnId} = ?',
      whereArgs: [id],
    );
  }
}
