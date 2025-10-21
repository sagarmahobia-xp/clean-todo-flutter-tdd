import 'package:clean_todo_tdd/database/drift_db.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DataModule {
  @singleton
  TodoDatabase getDatabase() {
    return TodoDatabase(NativeDatabase.memory());
  }
}
