import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class TodoLocalDataSource {
  Future<Either<DatabaseFailure, int?>> addTodo(TodoEntity todo);
  
  Future<Either<DatabaseFailure, List<TodoEntity>>> getTodos();
  
  Future<Either<DatabaseFailure, void>> markComplete(int id);
  
  Future<Either<DatabaseFailure, void>> markIncomplete(int id);
  
  Future<Either<DatabaseFailure, void>> deleteTodo(int id);
  
  Future<Either<DatabaseFailure, void>> updateTodo(TodoEntity todo);
}
