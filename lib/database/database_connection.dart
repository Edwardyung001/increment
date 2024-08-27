import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getDatabasesPath();
    var path = join(directory, 'db_login');

    var database = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreatingDatabase,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  Future<void> _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE login(id INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT, password TEXT)"
    );

    await database.execute(
        "CREATE TABLE user_counts(user_id TEXT PRIMARY KEY, count INTEGER)"
    );
  }

  Future<void> _onUpgrade(Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await database.execute(
          "CREATE TABLE user_counts(user_id TEXT PRIMARY KEY, count INTEGER)"
      );
    }
  }
}
