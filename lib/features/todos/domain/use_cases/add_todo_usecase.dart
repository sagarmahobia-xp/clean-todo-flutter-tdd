import 'package:clean_todo_tdd/core/use_case.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:fpdart/src/either.dart';
import 'package:injectable/injectable.dart';

@singleton
class AddTodoUseCase extends UseCaseWithParam<int, TodoEntity> {
  final TodoRepo repo;

  AddTodoUseCase({required this.repo});

  @override
  Future<Either<Failure, int>> call(TodoEntity param) async {
    try {
      var _value = await repo.addTodo(param) ?? 0;
      return Right(_value);
    } catch (e) {
      return Left(
        Failure(
          exception: e is Exception ? e : null,
          error: e is Error ? e : null,
          message: 'Failed to add todo',
        ),
      );
    }
  }
}
