import 'package:clean_todo_tdd/features/todos/data/models/todo_item.dart';
import 'package:clean_todo_tdd/features/todos/data/view/todo_item_view.dart';
import 'package:drift/drift.dart';

part 'drift_db.g.dart';

@DriftDatabase(tables: [TodoItems], views: [TodoItemView])
class TodoDatabase extends _$TodoDatabase {
  TodoDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
    );
  }
}
