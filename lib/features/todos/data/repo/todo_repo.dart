import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: TodoRepo)
class DriftTodoRepo extends TodoRepo {
  final TodoLocalDataSource localDataSource;

  DriftTodoRepo({required this.localDataSource});

  @override
  Future<Either<Failure, int?>> addTodo(TodoEntity todo) async {
    final result = await localDataSource.addTodo(todo);
    return result.fold(
      (databaseFailure) => left(
        AddTodoFailure(
          databaseFailure.message,
          exception: databaseFailure.exception,
          stackTrace: databaseFailure.stackTrace,
        ),
      ),
      right,
    );
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos() async {
    final result = await localDataSource.getTodos();
    return result.fold(
      (databaseFailure) => left(
        GetTodosFailure(
          databaseFailure.message,
          exception: databaseFailure.exception,
          stackTrace: databaseFailure.stackTrace,
        ),
      ),
      right,
    );
  }

  @override
  Future<Either<Failure, void>> markComplete(int id) async {
    final result = await localDataSource.markComplete(id);
    return result.fold(
      (databaseFailure) => left(
        UpdateTodoFailure(
          databaseFailure.message,
          exception: databaseFailure.exception,
          stackTrace: databaseFailure.stackTrace,
        ),
      ),
      right,
    );
  }

  @override
  Future<Either<Failure, void>> markIncomplete(int id) async {
    final result = await localDataSource.markIncomplete(id);
    return result.fold(
      (databaseFailure) => left(
        UpdateTodoFailure(
          databaseFailure.message,
          exception: databaseFailure.exception,
          stackTrace: databaseFailure.stackTrace,
        ),
      ),
      right,
    );
  }

  @override
  Future<Either<Failure, void>> deleteTodo(int id) async {
    final result = await localDataSource.deleteTodo(id);
    return result.fold(
      (databaseFailure) => left(
        DeleteTodoFailure(
          databaseFailure.message,
          exception: databaseFailure.exception,
          stackTrace: databaseFailure.stackTrace,
        ),
      ),
      right,
    );
  }
}
