import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';

abstract class TodoRepo {
  Future<int?> addTodo(TodoEntity todo);

  Future<List<TodoEntity>> getTodos();

  Future<void> markComplete(int id);

  Future<void> markIncomplete(int id);

}
