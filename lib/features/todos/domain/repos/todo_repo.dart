import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class TodoRepo {
  Future<Either<Failure, int?>> addTodo(TodoEntity todo);

  Future<Either<Failure, List<TodoEntity>>> getTodos();

  Future<Either<Failure, void>> markComplete(int id);

  Future<Either<Failure, void>> markIncomplete(int id);

  Future<Either<Failure, void>> deleteTodo(int id);

}
