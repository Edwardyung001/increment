import 'package:increment/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  insertData(String table, Map<String, Object?> data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  readData(String table) async {
    var connection = await database;
    return await connection?.query(table);
  }
}