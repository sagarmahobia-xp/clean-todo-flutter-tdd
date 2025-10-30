import 'package:clean_todo_tdd/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoEntity copyWith', () {
    test('should create a new instance with all properties unchanged when no parameters are provided', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Original Title',
        content: 'Original Content',
        completed: true,
      );

      final copiedTodo = originalTodo.copyWith();

      expect(copiedTodo, originalTodo);
      expect(copiedTodo, equals(originalTodo));
      expect(identical(copiedTodo, originalTodo), isFalse); // Should be different instances
    });

    test('should update only the id when provided to copyWith', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Original Title',
        content: 'Original Content',
        completed: false,
      );

      final updatedTodo = originalTodo.copyWith(id: 5);

      expect(updatedTodo.id, 5);
      expect(updatedTodo.title, originalTodo.title);
      expect(updatedTodo.content, originalTodo.content);
      expect(updatedTodo.completed, originalTodo.completed);
    });

    test('should update only the title when provided to copyWith', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Original Title',
        content: 'Original Content',
        completed: false,
      );

      final updatedTodo = originalTodo.copyWith(title: 'New Title');

      expect(updatedTodo.id, originalTodo.id);
      expect(updatedTodo.title, 'New Title');
      expect(updatedTodo.content, originalTodo.content);
      expect(updatedTodo.completed, originalTodo.completed);
    });

    test('should update only the content when provided to copyWith', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Original Title',
        content: 'Original Content',
        completed: false,
      );

      final updatedTodo = originalTodo.copyWith(content: 'New Content');

      expect(updatedTodo.id, originalTodo.id);
      expect(updatedTodo.title, originalTodo.title);
      expect(updatedTodo.content, 'New Content');
      expect(updatedTodo.completed, originalTodo.completed);
    });

    test('should update only the completed status when provided to copyWith', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Original Title',
        content: 'Original Content',
        completed: false,
      );

      final updatedTodo = originalTodo.copyWith(completed: true);

      expect(updatedTodo.id, originalTodo.id);
      expect(updatedTodo.title, originalTodo.title);
      expect(updatedTodo.content, originalTodo.content);
      expect(updatedTodo.completed, true);
    });

    test('should update multiple properties when multiple parameters are provided to copyWith', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Original Title',
        content: 'Original Content',
        completed: false,
      );

      final updatedTodo = originalTodo.copyWith(
        id: 10,
        title: 'Updated Title',
        completed: true,
      );

      expect(updatedTodo.id, 10);
      expect(updatedTodo.title, 'Updated Title');
      expect(updatedTodo.content, originalTodo.content); // Should remain unchanged
      expect(updatedTodo.completed, true);
    });

    test('should handle null values appropriately when using copyWith', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Original Title',
        content: 'Original Content',
        completed: false,
      );

      final updatedTodo = originalTodo.copyWith(
        title: null, // This should keep the original title
        content: null, // This should keep the original content
      );

      expect(updatedTodo.id, originalTodo.id);
      expect(updatedTodo.title, originalTodo.title); // Original title kept
      expect(updatedTodo.content, originalTodo.content); // Original content kept
      expect(updatedTodo.completed, originalTodo.completed);
    });

    test('should maintain equality when comparing with an identical copy', () {
      final originalTodo = TodoEntity(
        id: 1,
        title: 'Title',
        content: 'Content',
        completed: true,
      );

      final copiedTodo = originalTodo.copyWith();

      expect(originalTodo, copiedTodo);
      expect(originalTodo.props, copiedTodo.props);
    });
  });
}