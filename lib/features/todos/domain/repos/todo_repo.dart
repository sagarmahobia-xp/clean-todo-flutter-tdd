import 'package:clean_todo_tdd/database/drift_db.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';

abstract class TodoRepo {
  Future<int?> addTodo(TodoEntity todo);

  Future<List<TodoEntity>> getTodos();

}
