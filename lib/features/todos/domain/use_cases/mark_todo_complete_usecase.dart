import 'package:clean_todo_tdd/core/use_case.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@singleton
class MarkTodoCompleteUseCase extends UseCaseWithParam<void, TodoEntity> {
  final TodoRepo todoRepo;

  MarkTodoCompleteUseCase({required this.todoRepo});

  @override
  Future<Either<Failure, void>> call(TodoEntity params) async {
    try {
      await todoRepo.markComplete(params.id);
      return right(null);
    } catch (e) {
      return left(
        Failure(
          message: 'Failed to mark todo as complete',
          error: e is Error ? e : null,
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}