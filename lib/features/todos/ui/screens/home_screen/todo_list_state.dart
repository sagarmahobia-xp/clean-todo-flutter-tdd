part of 'todo_list_bloc.dart';

sealed class TodoListState extends Equatable {
  const TodoListState();
}

final class TodoListInitial extends TodoListState {
  @override
  List<Object> get props => [];
}

class TodoListLoading extends TodoListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TodoListLoaded extends TodoListState {
  final List<TodoEntity> todos;

  const TodoListLoaded({required this.todos});

  @override
  // TODO: implement props
  List<Object?> get props => [todos];
}

class TodoListLoadError extends TodoListState {
  final String message;

  const TodoListLoadError({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
