import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('toString should return correct string representation', () {
      final failure = TodoFailure('Test message');

      expect(failure.toString(), 'Failure: Test message');
    });

    test('should handle empty message', () {
      final failure = TodoFailure('');

      expect(failure.toString(), 'Failure: ');
    });

    test('should handle message with special characters', () {
      const specialMessage =
          'Error: {code: 500, message: "Internal Server Error"}';

      final failure = TodoFailure(specialMessage);

      expect(failure.message, specialMessage);
    });
  });
}
