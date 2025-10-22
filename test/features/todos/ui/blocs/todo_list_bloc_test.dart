import 'package:bloc_test/bloc_test.dart';
import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class GetTodoUseCaseMock extends Mock implements GetTodoUseCase {}

void main() {
  group("Group- UI - TodoListBloc - Load Todos,", () {
    blocTest(
      'Test: Load todo success,',
      build: () {
        var getTodoUseCaseMock = GetTodoUseCaseMock();

        when(() => getTodoUseCaseMock()).thenAnswer(
              (_) async =>
              Right([TodoEntity(id: 1, title: "title", content: "content")]),
        );
        return TodoListBloc(getTodoUseCaseMock);
      },
      act: ((bloc) => bloc.add(LoadTodosEvent())),
      expect: () => [
        TodoListLoading(),
        TodoListLoaded(
          todos: [TodoEntity(id: 1, title: "title", content: "content")],
        ),
      ],
    );

    blocTest(
      'Test: Load todo failed,',
      build: () {
        var getTodoUseCaseMock = GetTodoUseCaseMock();

        when(() => getTodoUseCaseMock()).thenAnswer(
              (_) async => Left(Failure(message: "Failed to load todos")),
        );
        return TodoListBloc(getTodoUseCaseMock);
      },
      act: ((bloc) => bloc.add(LoadTodosEvent())),
      expect: () => [
        TodoListLoading(),
        TodoListLoadError(message: "Failed to load todos"),
      ],
    );
  });
}
