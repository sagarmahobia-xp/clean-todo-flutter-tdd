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
    return await todoRepo.getTodos();
  }
}
