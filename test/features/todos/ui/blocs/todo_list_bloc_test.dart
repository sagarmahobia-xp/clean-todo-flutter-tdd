import 'package:bloc_test/bloc_test.dart';
import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/add_todo_usecase.dart'
    show AddTodoUseCase;
import 'package:clean_todo_tdd/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class GetTodoUseCaseMock extends Mock implements GetTodoUseCase {}

class AddTodoUseCaseMock extends Mock implements AddTodoUseCase {}

void main() {
  group("Group- UI - TodoListBloc - Load Todos,", () {
    late TodoListBloc bloc;
    late GetTodoUseCaseMock getTodoUseCaseMock;
    late AddTodoUseCaseMock addTodoUseCase;

    setUp(() {
      getTodoUseCaseMock = GetTodoUseCaseMock();
      addTodoUseCase = AddTodoUseCaseMock();
      bloc = TodoListBloc(getTodoUseCaseMock, addTodoUseCase);
    });

    blocTest(
      'Test: Load todo success,',
      build: () {
        when(() => getTodoUseCaseMock()).thenAnswer(
          (_) async =>
              Right([TodoEntity(id: 1, title: "title", content: "content")]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTodosEvent()),
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
        when(() => getTodoUseCaseMock()).thenAnswer(
          (_) async => Left(Failure(message: "Failed to load todos")),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTodosEvent()),
      expect: () => [
        TodoListLoading(),
        TodoListLoadError(message: "Failed to load todos"),
      ],
    );

    blocTest(
      'Test: Add todo success,',
      build: () {
        var todo = TodoEntity(
          title: "Test Add Todo Bloc",
          content: "Test Add Todo Bloc",
        );

        when(() => addTodoUseCase(todo)).thenAnswer((_) async => Right(1));
        when(() => getTodoUseCaseMock()).thenAnswer((_) async => Right([todo]));
        return bloc;
      },
      act: (bloc) => bloc.add(
        AddTodoEvent(
          title: "Test Add Todo Bloc",
          content: "Test Add Todo Bloc",
        ),
      ),
      expect: () => [
        TodoListLoading(),
        TodoListLoaded(
          todos: [
            TodoEntity(
              title: "Test Add Todo Bloc",
              content: "Test Add Todo Bloc",
            ),
          ],
        ),
      ],
    );

    blocTest(
      'Test: Add todo falied,',
      build: () {
        var todo = TodoEntity(
          title: "Test Add Todo Bloc",
          content: "Test Add Todo Bloc",
        );

        when(
          () => addTodoUseCase(todo),
        ).thenAnswer((_) async => Left(Failure(message: "Failed to add todo")));

        when(() => getTodoUseCaseMock()).thenAnswer((_) async => Right([todo]));
        return bloc;
      },
      act: (bloc) => bloc.add(
        AddTodoEvent(
          title: "Test Add Todo Bloc",
          content: "Test Add Todo Bloc",
        ),
      ),
      expect: () => [
        TodoListLoading(),
        TodoListLoadError(message: 'Failed to add todo'),
      ],
    );
  });
}
