import 'package:clean_todo_tdd/core/use_case.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@singleton
class AddTodoUseCase extends UseCaseWithParam<int, TodoEntity> {
  final TodoRepo repo;

  AddTodoUseCase({required this.repo});

  @override
  Future<Either<Failure, int>> call(TodoEntity param) async {
    final result = await repo.addTodo(param);
    return result.fold(
      left,
      (id) => right(id ?? 0),
    );
  }
}
