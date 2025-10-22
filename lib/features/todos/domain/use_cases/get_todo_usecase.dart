import 'package:clean_todo_tdd/core/use_case.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@singleton
class GetTodoUseCase extends UseCaseWithoutParam<List<TodoEntity>> {
  final TodoRepo todoRepo;

  GetTodoUseCase({required this.todoRepo});

  @override
  Future<Either<Failure, List<TodoEntity>>> call() async {
    try {
      var todos = await todoRepo.getTodos();
      return right(todos);
    } catch (e) {
      return left(
        Failure(
          message: "Failed to load todo",
          error: e is Error ? e : null,
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
