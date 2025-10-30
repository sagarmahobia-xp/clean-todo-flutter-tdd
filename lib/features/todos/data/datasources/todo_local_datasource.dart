import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';

abstract class TodoLocalDataSource {
  Future<int?> addTodo(TodoEntity todo);
  
  Future<List<TodoEntity>> getTodos();
  
  Future<void> markComplete(int id);
  
  Future<void> markIncomplete(int id);
  
  Future<void> deleteTodo(int id);
  
  Future<void> updateTodo(TodoEntity todo);
}
