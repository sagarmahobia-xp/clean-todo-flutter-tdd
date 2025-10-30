import 'package:clean_todo_tdd/core/use_case.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@singleton
class DeleteTodoUseCase extends UseCaseWithParam<void, int> {
  final TodoRepo repo;

  DeleteTodoUseCase({required this.repo});

  @override
  Future<Either<Failure, void>> call(int params) async {
    try {
      await repo.deleteTodo(params);
      return const Right(null);
    } catch (e) {
      return Left(
        Failure(
          exception: e is Exception ? e : null,
          error: e is Error ? e : null,
          message: 'Failed to delete todo',
        ),
      );
    }
  }
}
