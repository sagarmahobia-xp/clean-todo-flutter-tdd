import 'package:clean_todo_tdd/features/todos/data/models/todo_item.dart';
import 'package:drift/drift.dart';

abstract class TodoItemView extends View {
  TodoItems get todoItems;

  @override
  Query<HasResultSet, dynamic> as() => select([todoItems.id]).from(todoItems);
}
