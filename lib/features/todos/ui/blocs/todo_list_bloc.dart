import 'package:bloc/bloc.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

part 'todo_list_event.dart';

part 'todo_list_state.dart';

@injectable
class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final GetTodoUseCase getTodoUseCase;
  final AddTodoUseCase addTodoUseCase;

  TodoListBloc(this.getTodoUseCase, this.addTodoUseCase)
    : super(TodoListInitial()) {
    on<LoadTodosEvent>((event, emit) async {
      emit(TodoListLoading());

      var result = await getTodoUseCase();

      result.fold(
        (left) {
          emit(TodoListLoadError(message: left.message));
        },
        (right) {
          emit(TodoListLoaded(todos: right));
        },
      );
    });

    on<AddTodoEvent>((event, emit) async {
      emit(TodoListLoading());

      var todo = TodoEntity(title: event.title, content: event.content);
      var addResult = await addTodoUseCase(todo);
      var result = await getTodoUseCase();

      result.fold(
        (left) {
          emit(TodoListLoadError(message: left.message));
        },
        (right) {
          emit(TodoListLoaded(todos: right));
        },
      );
    });
  }
}
