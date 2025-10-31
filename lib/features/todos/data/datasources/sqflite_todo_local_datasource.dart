import 'package:clean_todo_tdd/features/todos/data/database/sqflite_db.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteTodoLocalDataSource implements TodoLocalDataSource {
  final Database database;

  SqfliteTodoLocalDataSource({required this.database});

  @override
  Future<Either<DatabaseFailure, int?>> addTodo(TodoEntity todo) async {
    try {
      final result = await database.insert(
        TodoSqfliteDatabase.tableTodos,
        {
          TodoSqfliteDatabase.columnTitle: todo.title,
          TodoSqfliteDatabase.columnContent: todo.content,
          TodoSqfliteDatabase.columnCompleted: todo.completed ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return right(result);
    } catch (e, stackTrace) {
      return left(
        DatabaseFailure(
          'Failed to add todo: ${e.toString()}',
          exception: e is Exception ? e : null,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<DatabaseFailure, List<TodoEntity>>> getTodos() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        TodoSqfliteDatabase.tableTodos,
      );

      final todos = maps.map((map) {
        return TodoEntity(
          id: map[TodoSqfliteDatabase.columnId] as int,
          title: map[TodoSqfliteDatabase.columnTitle] as String,
          content: map[TodoSqfliteDatabase.columnContent] as String?,
          completed: map[TodoSqfliteDatabase.columnCompleted] == 1,
        );
      }).toList();
      
      return right(todos);
    } catch (e, stackTrace) {
      return left(
        DatabaseFailure(
          'Failed to get todos: ${e.toString()}',
          exception: e is Exception ? e : null,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<DatabaseFailure, void>> markComplete(int id) async {
    try {
      await database.update(
        TodoSqfliteDatabase.tableTodos,
        {
          TodoSqfliteDatabase.columnCompleted: 1, // Set to true (completed)
        },
        where: '${TodoSqfliteDatabase.columnId} = ?',
        whereArgs: [id],
      );
      return right(null);
    } catch (e, stackTrace) {
      return left(
        DatabaseFailure(
          'Failed to mark todo as complete: ${e.toString()}',
          exception: e is Exception ? e : null,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<DatabaseFailure, void>> markIncomplete(int id) async {
    try {
      await database.update(
        TodoSqfliteDatabase.tableTodos,
        {
          TodoSqfliteDatabase.columnCompleted: 0, // Set to false (not completed)
        },
        where: '${TodoSqfliteDatabase.columnId} = ?',
        whereArgs: [id],
      );
      return right(null);
    } catch (e, stackTrace) {
      return left(
        DatabaseFailure(
          'Failed to mark todo as incomplete: ${e.toString()}',
          exception: e is Exception ? e : null,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<DatabaseFailure, void>> deleteTodo(int id) async {
    try {
      await database.delete(
        TodoSqfliteDatabase.tableTodos,
        where: '${TodoSqfliteDatabase.columnId} = ?',
        whereArgs: [id],
      );
      return right(null);
    } catch (e, stackTrace) {
      return left(
        DatabaseFailure(
          'Failed to delete todo: ${e.toString()}',
          exception: e is Exception ? e : null,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<DatabaseFailure, void>> updateTodo(TodoEntity todo) async {
    try {
      await database.update(
        TodoSqfliteDatabase.tableTodos,
        {
          TodoSqfliteDatabase.columnTitle: todo.title,
          TodoSqfliteDatabase.columnContent: todo.content,
          TodoSqfliteDatabase.columnCompleted: todo.completed ? 1 : 0,
        },
        where: '${TodoSqfliteDatabase.columnId} = ?',
        whereArgs: [todo.id],
      );
      return right(null);
    } catch (e, stackTrace) {
      return left(
        DatabaseFailure(
          'Failed to update todo: ${e.toString()}',
          exception: e is Exception ? e : null,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
