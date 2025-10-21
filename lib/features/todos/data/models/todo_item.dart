import 'package:drift/drift.dart';

@DataClassName('TodoItem')
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get content => text().nullable()();

  TextColumn get generatedText => text().nullable().generatedAs(
    title + const Constant(' (') + content + const Constant(')'),
  )();
}

abstract class TodoItemView extends View {
  TodoItems get todoItems;

  @override
  Query<HasResultSet, dynamic> as() => select([todoItems.id]).from(todoItems);
}
