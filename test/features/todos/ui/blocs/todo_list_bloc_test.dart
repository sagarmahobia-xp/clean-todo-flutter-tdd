import 'package:bloc_test/bloc_test.dart';
import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/add_todo_usecase.dart'
    show AddTodoUseCase;
import 'package:clean_todo_tdd/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/mark_todo_complete_usecase.dart';
import 'package:clean_todo_tdd/features/todos/domain/use_cases/mark_todo_incomplete_usecase.dart';
import 'package:clean_todo_tdd/features/todos/ui/blocs/todo_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class GetTodoUseCaseMock extends Mock implements GetTodoUseCase {}

class AddTodoUseCaseMock extends Mock implements AddTodoUseCase {}

class MarkTodoCompleteUseCaseMock extends Mock implements MarkTodoCompleteUseCase {}

class MarkTodoIncompleteUseCaseMock extends Mock implements MarkTodoIncompleteUseCase {}

class TodoEntityFake extends Fake implements TodoEntity {}

void main() {
  registerFallbackValue(TodoEntityFake());
  
  group('Group- UI - TodoListBloc - Load Todos,', () {
    late TodoListBloc bloc;
    late GetTodoUseCaseMock getTodoUseCaseMock;
    late AddTodoUseCaseMock addTodoUseCase;
    late MarkTodoCompleteUseCaseMock markTodoCompleteUseCaseMock;
    late MarkTodoIncompleteUseCaseMock markTodoIncompleteUseCaseMock;

    setUp(() {
      getTodoUseCaseMock = GetTodoUseCaseMock();
      addTodoUseCase = AddTodoUseCaseMock();
      markTodoCompleteUseCaseMock = MarkTodoCompleteUseCaseMock();
      markTodoIncompleteUseCaseMock = MarkTodoIncompleteUseCaseMock();
      bloc = TodoListBloc(
        getTodoUseCaseMock,
        addTodoUseCase,
        markTodoCompleteUseCaseMock,
        markTodoIncompleteUseCaseMock,
      );
    });

    blocTest(
      'Test: Load todo success,',
      build: () {
        when(() => getTodoUseCaseMock()).thenAnswer(
          (_) async =>
              Right([TodoEntity(id: 1, title: 'title', content: 'content')]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTodosEvent()),
      expect: () => [
        TodoListLoading(),
        TodoListLoaded(
          todos: [TodoEntity(id: 1, title: 'title', content: 'content')],
        ),
      ],
    );

    blocTest(
      'Test: Load todo failed,',
      build: () {
        when(() => getTodoUseCaseMock()).thenAnswer(
          (_) async => Left(Failure(message: 'Failed to load todos')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTodosEvent()),
      expect: () => [
        TodoListLoading(),
        TodoListLoadError(message: 'Failed to load todos'),
      ],
    );

    blocTest(
      'Test: Add todo success,',
      build: () {
        var todo = TodoEntity(
          title: 'Test Add Todo Bloc',
          content: 'Test Add Todo Bloc',
        );

        when(() => addTodoUseCase(todo)).thenAnswer((_) async => Right(1));
        when(() => getTodoUseCaseMock()).thenAnswer((_) async => Right([todo]));
        return bloc;
      },
      act: (bloc) => bloc.add(
        AddTodoEvent(
          title: 'Test Add Todo Bloc',
          content: 'Test Add Todo Bloc',
        ),
      ),
      expect: () => [
        TodoListLoading(),
        TodoListLoaded(
          todos: [
            TodoEntity(
              title: 'Test Add Todo Bloc',
              content: 'Test Add Todo Bloc',
            ),
          ],
        ),
      ],
    );

    blocTest(
      'Test: Add todo falied,',
      build: () {
        var todo = TodoEntity(
          title: 'Test Add Todo Bloc',
          content: 'Test Add Todo Bloc',
        );

        when(
          () => addTodoUseCase(todo),
        ).thenAnswer((_) async => Left(Failure(message: 'Failed to add todo')));

        when(() => getTodoUseCaseMock()).thenAnswer((_) async => Right([todo]));
        return bloc;
      },
      act: (bloc) => bloc.add(
        AddTodoEvent(
          title: 'Test Add Todo Bloc',
          content: 'Test Add Todo Bloc',
        ),
      ),
      expect: () => [
        TodoListLoading(),
        TodoListLoadError(message: 'Failed to add todo'),
      ],
    );

    group('Group- UI - TodoListBloc - Mark Todo Complete,', () {
      blocTest(
        'Test: Mark todo complete success,',
        build: () {
          when(() => markTodoCompleteUseCaseMock(any())).thenAnswer((_) async => Right(null));
          when(() => getTodoUseCaseMock()).thenAnswer(
            (_) async => Right([
              TodoEntity(
                id: 1,
                title: 'Test Todo',
                content: 'Test Content',
                completed: true,
              ),
            ]),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(MarkTodoCompleteEvent(todoId: 1)),
        expect: () => [
          TodoListLoading(),
          TodoListLoaded(
            todos: [
              TodoEntity(
                id: 1,
                title: 'Test Todo',
                content: 'Test Content',
                completed: true,
              ),
            ],
          ),
        ],
      );

      blocTest(
        'Test: Mark todo complete failed,',
        build: () {
          when(() => markTodoCompleteUseCaseMock(any())).thenAnswer(
            (_) async => Left(Failure(message: 'Failed to mark todo as complete')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(MarkTodoCompleteEvent(todoId: 1)),
        expect: () => [
          TodoListLoading(),
          TodoListLoadError(message: 'Failed to mark todo as complete'),
        ],
      );

      blocTest(
        'Test: Mark todo incomplete success,',
        build: () {
          when(() => markTodoIncompleteUseCaseMock(any())).thenAnswer((_) async => Right(null));
          when(() => getTodoUseCaseMock()).thenAnswer(
            (_) async => Right([
              TodoEntity(
                id: 1,
                title: 'Test Todo',
                content: 'Test Content',
                completed: false,
              ),
            ]),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(MarkTodoIncompleteEvent(todoId: 1)),
        expect: () => [
          TodoListLoading(),
          TodoListLoaded(
            todos: [
              TodoEntity(
                id: 1,
                title: 'Test Todo',
                content: 'Test Content',
                completed: false,
              ),
            ],
          ),
        ],
      );

      blocTest(
        'Test: Mark todo incomplete failed,',
        build: () {
          when(() => markTodoIncompleteUseCaseMock(any())).thenAnswer(
            (_) async => Left(Failure(message: 'Failed to mark todo as incomplete')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(MarkTodoIncompleteEvent(todoId: 1)),
        expect: () => [
          TodoListLoading(),
          TodoListLoadError(message: 'Failed to mark todo as incomplete'),
        ],
      );
    });
  });
}