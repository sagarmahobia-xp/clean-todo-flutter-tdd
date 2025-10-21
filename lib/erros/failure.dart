class Failure {
  final String message;
  final Error? error;
  final Exception? exception;
  final StackTrace? stackTrace; // Optional: For debugging/logging

  const Failure({
    required this.message,
    this.stackTrace,
    this.error,
    this.exception,
  });

  @override
  String toString() => 'Failure: $message';
}
