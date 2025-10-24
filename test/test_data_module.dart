import 'package:clean_todo_tdd/features/todos/data/database/drift_db.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';

class TestTodoDatabase extends TodoDatabase {
  TestTodoDatabase(super.e);

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        // Don't prefill data for tests
      },
    );
  }
}

@module
abstract class TestDataModule {
  @singleton
  TodoDatabase getDatabase() {
    return TestTodoDatabase(NativeDatabase.memory());
  }
}
