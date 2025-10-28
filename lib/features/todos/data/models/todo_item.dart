import 'package:drift/drift.dart';

@DataClassName('TodoItem')
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get content => text().nullable()();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  TextColumn get generatedText => text().nullable().generatedAs(
    title + const Constant(' (') + content + const Constant(')'),
  )();
}
