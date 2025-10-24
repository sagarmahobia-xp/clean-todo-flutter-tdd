import 'package:clean_todo_tdd/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/repos/todo_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: TodoRepo)
class DriftTodoRepo extends TodoRepo {
  final TodoLocalDataSource localDataSource;

  DriftTodoRepo({required this.localDataSource});

  @override
  Future<int?> addTodo(TodoEntity todo) async {
    return await localDataSource.addTodo(todo);
  }

  @override
  Future<List<TodoEntity>> getTodos() async {
    return await localDataSource.getTodos();
  }
}
