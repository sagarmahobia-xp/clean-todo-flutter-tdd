# Clean Todo App - Architecture Documentation

## Overview

This is a Flutter Todo application built using **Clean Architecture** principles. The app
demonstrates separation of concerns, dependency inversion, and comprehensive testing.

---

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  UI (Screens & Widgets)                                    │ │
│  │  • HomeScreen                                              │ │
│  │  • TodoItemWidget                                          │ │
│  │  • AddTodoFormWidget                                       │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  BLoC (Business Logic Components)                          │ │
│  │  • TodoListBloc                                            │ │
│  │  • Events: Add, Delete, Load, MarkComplete, MarkIncomplete│ │
│  │  • States: Initial, Loading, Loaded, Error                 │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                             │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Entities                                                   │ │
│  │  • TodoEntity (id, title, content, completed)              │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Use Cases (Business Rules)                                │ │
│  │  • GetTodoUseCase                                          │ │
│  │  • AddTodoUseCase                                          │ │
│  │  • DeleteTodoUseCase                                       │ │
│  │  • MarkTodoCompleteUseCase                                 │ │
│  │  • MarkTodoIncompleteUseCase                               │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Repository Interfaces (Abstract)                          │ │
│  │  • ITodoRepo                                               │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                              │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Repository Implementation                                  │ │
│  │  • TodoRepo (implements ITodoRepo)                         │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Data Sources                                              │ │
│  │  • TodoLocalDataSource (SqfLite)                           │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Models                                                     │ │
│  │  • TodoModel (extends TodoEntity)                          │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Database                                                   │ │
│  │  • AppDatabase (SqfLite)                                    │ │
│  │  • Todos Table                                             │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Project Directory Structure

```
clean_todo_tdd/
│
├── lib/
│   ├── main.dart                          # Application entry point
│   │
│   ├── core/                              # Core utilities
│   │   └── use_case.dart                  # Base use case classes
│   │
│   ├── di/                                # Dependency Injection
│   │   ├── di_config.dart                 # DI configuration
│   │   ├── di_config.config.dart          # Generated DI code
│   │   ├── app_module.dart                # App-level dependencies
│   │   ├── data_module.dart               # Data layer dependencies
│   │   └── test_data_module.dart          # Test environment dependencies
│   │
│   ├── erros/                             # Error handling
│   │   └── failure.dart                   # Failure classes
│   │
│   └── features/                          # Feature modules
│       └── todos/                         # Todo feature
│           │
│           ├── data/                      # DATA LAYER
│           │   ├── database/
│           │   │   └── app_database.dart  # SqfLite database setup
│           │   ├── datasources/
│           │   │   └── todo_local_data_source.dart
│           │   ├── models/
│           │   │   └── todo_model.dart    # Data model
│           │   └── repo/
│           │       └── todo_repo.dart     # Repository implementation
│           │
│           ├── domain/                    # DOMAIN LAYER
│           │   ├── entities/
│           │   │   └── todo_entity.dart   # Business entity
│           │   ├── repos/
│           │   │   └── todo_repo.dart     # Repository interface
│           │   └── use_cases/
│           │       ├── add_todo_usecase.dart
│           │       ├── delete_todo_usecase.dart
│           │       ├── get_todo_usecase.dart
│           │       ├── mark_todo_complete_usecase.dart
│           │       └── mark_todo_incomplete_usecase.dart
│           │
│           └── ui/                        # PRESENTATION LAYER
│               ├── blocs/
│               │   ├── todo_list_bloc.dart
│               │   ├── todo_list_event.dart
│               │   └── todo_list_state.dart
│               ├── screens/
│               │   └── home/
│               │       └── home_screen.dart
│               └── widgets/
│                   ├── add_todo_form_widget.dart
│                   └── todo_item_widget.dart
│
├── test/                                  # Unit & Widget Tests
│   ├── erros/
│   │   └── failure_test.dart
│   └── features/
│       └── todos/
│           ├── data/
│           ├── domain/
│           │   └── use_cases/
│           │       ├── add_todo_usecase_test.dart
│           │       ├── delete_todo_usecase_test.dart
│           │       ├── get_todo_usecase_test.dart
│           │       ├── mark_todo_complete_usecase_test.dart
│           │       └── mark_todo_incomplete_usecase_test.dart
│           └── ui/
│               ├── screens/
│               │   └── home/
│               │       └── home_screen_test.dart
│               └── widgets/
│                   ├── add_todo_form_widget_test.dart
│                   └── todo_item_widget_test.dart
│
└── integration_test/                      # E2E Integration Tests
    └── add_todo_e2e_test.dart
│
├── run_test.sh                            # Script to run unit & widget tests
├── run_integration_test.sh                # Script to run integration tests
├── run_coverage.sh                        # Script to generate coverage reports
├── pubspec.yaml                           # Dependencies configuration
└── README.md                              # Project overview
 
```

---

## Data Flow Diagram - CRUD Operations

### Complete CRUD Data Flow

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                              USER INTERACTIONS                                   │
├──────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  CREATE          READ              UPDATE               DELETE                  │
│  Add Todo        Load Todos        Mark Complete        Remove Todo             │
│  (FAB Click)     (App Start)       (Toggle Status)      (Swipe/Delete)         │
│                                                                                  │
└────────┬──────────────┬──────────────────┬──────────────────┬───────────────────┘
         │              │                  │                  │
         │              │                  │                  │
         ↓              ↓                  ↓                  ↓
    ┌─────────┐    ┌─────────┐       ┌─────────┐       ┌─────────┐
    │  Add    │    │  Load   │       │  Mark   │       │ Delete  │
    │  Event  │    │  Event  │       │  Event  │       │  Event  │
    └────┬────┘    └────┬────┘       └────┬────┘       └────┬────┘
         │              │                  │                  │
         └──────────────┴──────────────────┴──────────────────┘
                                  │
                                  ↓
                    ┌─────────────────────────────┐
                    │      TodoListBloc           │
                    │  (State Management Layer)   │
                    └──────────────┬──────────────┘
                                   │
                                   │ routes to appropriate
                                   ↓
         ┌─────────────────────────┼─────────────────────────┐
         │                         │                         │
         ↓                         ↓                         ↓
┌────────────────┐      ┌────────────────┐      ┌────────────────┐
│ AddTodoUseCase │      │ GetTodoUseCase │      │MarkTodoComplete│
│                │      │                │      │    UseCase     │
└───────┬────────┘      └───────┬────────┘      └───────┬────────┘
        │                       │                        │
┌────────────────┐      ┌────────────────┐      ┌────────────────┐
│MarkTodoIncomplete     │DeleteTodoUseCase       │               │
│    UseCase     │      │                │       │               │
└───────┬────────┘      └───────┬────────┘       │               │
        │                       │                 │               │
        └───────────────────────┴─────────────────┴───────────────┘
                                │
                                │ all use cases call
                                ↓
                    ┌─────────────────────────────┐
                    │       TodoRepo              │
                    │    (ITodoRepo Interface)    │
                    │  • addTodo()                │
                    │  • getTodos()               │
                    │  • updateTodo()             │
                    │  • deleteTodo()             │
                    └──────────────┬──────────────┘
                                   │
                                   │ delegates to
                                   ↓
                    ┌─────────────────────────────┐
                    │  TodoLocalDataSource        │
                    │  (SqfLite Operations)       │
                    │  • insert()                 │
                    │  • query()                  │
                    │  • update()                 │
                    │  • delete()                 │
                    └──────────────┬──────────────┘
                                   │
                                   │ executes SQL
                                   ↓
                    ┌─────────────────────────────┐
                    │   SqfLite Database          │
                    │   (Persistent Storage)      │
                    │                             │
                    │  INSERT INTO todos ...      │
                    │  SELECT * FROM todos ...    │
                    │  UPDATE todos SET ...       │
                    │  DELETE FROM todos ...      │
                    └──────────────┬──────────────┘
                                   │
                                   │ returns result
                                   ↓
                    ┌─────────────────────────────┐
                    │     Response Flow           │
                    │                             │
                    │  Data ──> DataSource ──>    │
                    │  Repo ──> UseCase ──> BLoC  │
                    └──────────────┬──────────────┘
                                   │
                                   │ emits state
                                   ↓
                    ┌─────────────────────────────┐
                    │    TodoListLoaded(todos)    │
                    │         or                  │
                    │    TodoListError(message)   │
                    └──────────────┬──────────────┘
                                   │
                                   │ rebuilds UI
                                   ↓
                    ┌─────────────────────────────┐
                    │       HomeScreen            │
                    │   (ListView with Todos)     │
                    └─────────────────────────────┘
```

---

### Testing

```
┌──────────────────────┐
│    flutter_test      │  Widget & Unit testing
└──────────────────────┘

┌──────────────────────┐
│      mocktail        │  Mocking framework
│      (v1.0.4)        │  • Test doubles
└──────────────────────┘  • Behavior verification

┌──────────────────────┐
│     bloc_test        │  BLoC testing utilities
│      (v10.0.0)       │  • whenListen helper
└──────────────────────┘  • State verification

┌──────────────────────┐
│  integration_test    │  E2E testing
└──────────────────────┘  • Full app testing
```

---

## Testing Strategy

### Test Pyramid

```
                    ▲
                   ╱ ╲
                  ╱   ╲
                 ╱     ╲
                ╱  E2E  ╲          Integration Tests (Slow, High Confidence)
               ╱─────────╲         • integration_test/add_todo_e2e_test.dart
              ╱           ╲        • Tests complete user flows
             ╱             ╲
            ╱   Widget     ╲      Widget Tests (Medium Speed, UI Testing)
           ╱    Tests       ╲     • home_screen_test.dart
          ╱─────────────────╲    • todo_item_widget_test.dart
         ╱                   ╲   • add_todo_form_widget_test.dart
        ╱      Unit Tests     ╲  Unit Tests (Fast, Isolated)
       ╱                       ╲ • Use case tests
      ╱─────────────────────────╲• Repository tests
     ╱                           ╲ Data source tests
    ╱_____________________________╲
           (Many tests)              (High speed, Low cost)
```

### Test Coverage Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI LAYER TESTS                           │
├─────────────────────────────────────────────────────────────────┤
│ • Widget Tests: Verify UI components render correctly           │
│ • Integration Tests: Test complete user journeys                │
│ • BLoC Tests: Verify state transitions and event handling       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER TESTS                         │
├─────────────────────────────────────────────────────────────────┤
│ • Use Case Tests: Verify business logic in isolation            │
│ • Entity Tests: Validate domain models                          │
│ • Mock repository for use case testing                          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER TESTS                          │
├─────────────────────────────────────────────────────────────────┤
│ • Repository Tests: Verify data flow and error handling         │
│ • Data Source Tests: Test database operations                   │
│ • Model Tests: Validate data transformations                    │
└─────────────────────────────────────────────────────────────────┘
```

### Test Commands

```bash
# Run all unit and widget tests
./run_test.sh
 
# Run integration tests (E2E)
./run_integration_test.sh

# Generate coverage report
./run_coverage.sh
```

### Available Test Scripts

| Script                    | Purpose             | Description                                                  |
|---------------------------|---------------------|--------------------------------------------------------------|
| `run_test.sh`             | Unit & Widget Tests | Runs all unit and widget tests with expanded reporter output |
| `run_integration_test.sh` | Integration Tests   | Runs end-to-end integration tests for complete user flows    |
| `run_coverage.sh`         | Coverage Report     | Generates HTML coverage report and opens it in browser       |

---

## Thank You
