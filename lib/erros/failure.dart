// Define an abstract base Failure class
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => 'Failure: $message';

  /// Returns a user-friendly error message suitable for displaying in the UI
  String get userFriendlyMessage => _getDefaultUserFriendlyMessage();

  String _getDefaultUserFriendlyMessage() {
    return 'Something went wrong. Please try again.';
  }
}

// Data Layer Failures
class DatabaseFailure extends Failure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const DatabaseFailure(super.message, {this.exception, this.stackTrace});

  @override
  String get userFriendlyMessage =>
      'Unable to access local storage. Please try again.';
}

/*

class NetworkFailure extends Failure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const NetworkFailure(super.message, {this.exception, this.stackTrace});

  @override
  String get userFriendlyMessage =>
      'Unable to connect to the internet. Please check your connection.';
}
// Domain Layer Failures
class ServerFailure extends Failure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const ServerFailure(super.message, {this.exception, this.stackTrace});

  @override
  String get userFriendlyMessage =>
      'Server error occurred. Please try again later.';
}

class CacheFailure extends Failure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const CacheFailure(super.message, {this.exception, this.stackTrace});

  @override
  String get userFriendlyMessage =>
      'Unable to load cached data. Please try again.';
}

class ValidationFailure extends Failure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const ValidationFailure(super.message, {this.exception, this.stackTrace});

  @override
  String get userFriendlyMessage =>
      'Invalid input. Please check your data and try again.';
}

class TodoNotFoundFailure extends TodoFailure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const TodoNotFoundFailure(
    super.message, {
    this.exception,
    this.stackTrace,
  });

  @override
  String get userFriendlyMessage => 'Todo not found. It may have been deleted.';
}


class TodoInvalidDataFailure extends TodoFailure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const TodoInvalidDataFailure(
    super.message, {
    this.exception,
    this.stackTrace,
  });

  @override
  String get userFriendlyMessage =>
      'Invalid todo data. Please check your input.';
}

*/

// Specific domain failures for Todo operations
class TodoFailure extends Failure {
  final Exception? exception;
  final StackTrace? stackTrace;

  const TodoFailure(super.message, {this.exception, this.stackTrace});

  @override
  String get userFriendlyMessage =>
      'Unable to process your todo. Please try again.';
}


// Specific operation failures
class AddTodoFailure extends TodoFailure {
  const AddTodoFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });

  @override
  String get userFriendlyMessage => 'Unable to add todo. Please try again.';
}

class GetTodosFailure extends TodoFailure {
  const GetTodosFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });

  @override
  String get userFriendlyMessage => 'Unable to load todos. Please try again.';
}

class UpdateTodoFailure extends TodoFailure {
  const UpdateTodoFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });

  @override
  String get userFriendlyMessage => 'Unable to update todo. Please try again.';
}

class DeleteTodoFailure extends TodoFailure {
  const DeleteTodoFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });

  @override
  String get userFriendlyMessage => 'Unable to delete todo. Please try again.';
}
