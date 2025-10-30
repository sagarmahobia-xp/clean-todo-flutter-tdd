part of 'todo_list_bloc.dart';

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();
}

class LoadTodosEvent extends TodoListEvent {
  @override
  List<Object?> get props => [];
}

class AddTodoEvent extends TodoListEvent {
  final String title;
  final String? content;

  const AddTodoEvent({required this.title, this.content});

  @override
  List<Object?> get props => [title, content];
}

class MarkTodoCompleteEvent extends TodoListEvent {
  final int todoId;

  const MarkTodoCompleteEvent({required this.todoId});

  @override
  List<Object?> get props => [todoId];
}

class MarkTodoIncompleteEvent extends TodoListEvent {
  final int todoId;

  const MarkTodoIncompleteEvent({required this.todoId});

  @override
  List<Object?> get props => [todoId];
}
