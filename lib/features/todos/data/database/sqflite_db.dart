import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TodoSqfliteDatabase {
  static const String tableTodos = 'todos';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnContent = 'content';

  TodoSqfliteDatabase._();

  static Future<Database> createDatabase(String path) async {
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<Database> createInMemoryDatabase() async {
    // Initialize FFI for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    return await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTodos (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnContent TEXT
      )
    ''');
  }
}
