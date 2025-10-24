
import 'package:clean_todo_tdd/features/todos/data/database/drift_db.dart';
import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

// @Singleton(as: TodoLocalDataSource)
//Not used, Replaced with SqfLite DB
class DriftTodoLocalDataSource implements TodoLocalDataSource {
  final TodoDatabase database;

  DriftTodoLocalDataSource({required this.database});

  @override
  Future<int?> addTodo(TodoEntity todo) async {
    var item = TodoItemsCompanion.insert(
      title: todo.title,
      content: Value(todo.content),
    );

    return await database.into(database.todoItems).insert(item);
  }

  @override
  Future<List<TodoEntity>> getTodos() async {
    var todoItems = await database.select(database.todoItems).get();

    return todoItems.map((item) {
      return TodoEntity(id: item.id, title: item.title, content: item.content);
    }).toList();
  }
}
