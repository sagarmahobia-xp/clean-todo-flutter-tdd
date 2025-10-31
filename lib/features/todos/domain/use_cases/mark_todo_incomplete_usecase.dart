import 'package:clean_todo_tdd/core/use_case.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@singleton
class MarkTodoIncompleteUseCase extends UseCaseWithParam<void, TodoEntity> {
  final TodoRepo todoRepo;

  MarkTodoIncompleteUseCase({required this.todoRepo});

  @override
  Future<Either<Failure, void>> call(TodoEntity params) async {
    return await todoRepo.markIncomplete(params.id);
  }
}