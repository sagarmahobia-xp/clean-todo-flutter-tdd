import 'package:bloc/bloc.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/delete_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/mark_todo_complete_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/mark_todo_incomplete_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

part 'todo_list_event.dart';

part 'todo_list_state.dart';

@injectable
class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final GetTodoUseCase getTodoUseCase;
  final AddTodoUseCase addTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;
  final MarkTodoCompleteUseCase markTodoCompleteUseCase;
  final MarkTodoIncompleteUseCase markTodoIncompleteUseCase;

  TodoListBloc(
    this.getTodoUseCase,
    this.addTodoUseCase,
    this.deleteTodoUseCase,
    this.markTodoCompleteUseCase,
    this.markTodoIncompleteUseCase,
  ) : super(TodoListInitial()) {
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

      await addResult.fold(
        (left) {
          emit(TodoListLoadError(message: left.message));
        },
        (right) async {
          var result = await getTodoUseCase();

          result.fold(
            (left) {
              emit(TodoListLoadError(message: left.message));
            },
            (right) {
              emit(TodoListLoaded(todos: right));
            },
          );
        },
      );
    });

    on<MarkTodoCompleteEvent>((event, emit) async {
      emit(TodoListLoading());

      var todo = TodoEntity(id: event.todoId, title: '', content: '', completed: true);
      var result = await markTodoCompleteUseCase(todo);

      await result.fold(
        (left) async {
          emit(TodoListLoadError(message: left.message));
        },
        (right) async {
          var todosResult = await getTodoUseCase();
          await todosResult.fold(
            (left) async {
              emit(TodoListLoadError(message: left.message));
            },
            (right) async {
              emit(TodoListLoaded(todos: right));
            },
          );
        },
      );
    });

    on<MarkTodoIncompleteEvent>((event, emit) async {
      emit(TodoListLoading());

      var todo = TodoEntity(id: event.todoId, title: '', content: '', completed: false);
      var result = await markTodoIncompleteUseCase(todo);

      await result.fold(
        (left) async {
          emit(TodoListLoadError(message: left.message));
        },
        (right) async {
          var todosResult = await getTodoUseCase();
          await todosResult.fold(
            (left) async {
              emit(TodoListLoadError(message: left.message));
            },
            (right) async {
              emit(TodoListLoaded(todos: right));
            },
          );
        },
      );
    });

    on<DeleteTodoEvent>((event, emit) async {
      emit(TodoListLoading());

      var result = await deleteTodoUseCase(event.todoId);

      await result.fold(
        (left) async {
          emit(TodoListLoadError(message: left.message));
        },
        (right) async {
          var todosResult = await getTodoUseCase();
          await todosResult.fold(
            (left) async {
              emit(TodoListLoadError(message: left.message));
            },
            (right) async {
              emit(TodoListLoaded(todos: right));
            },
          );
        },
      );
    });
  }
}
